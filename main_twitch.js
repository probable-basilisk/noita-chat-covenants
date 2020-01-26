require('dotenv').config();
const ws = require('ws');
const tmi = require('tmi.js');
const fs = require('fs');

// eh...
const CHANNEL = process.argv[2] || process.env.CHANNEL_NAME;

const WS_PORT = 9090;
const SECS_BETWEEN_VOTES = process.env.SECS_BETWEEN_VOTES || 10;
const SECS_FOR_VOTE = process.env.SECS_FOR_VOTE || 60;

const wss = new ws.Server({ port: WS_PORT });
console.log("WS listening on " + WS_PORT);

let noita = null;
let con = null;

function getConnectionName(ws) {
  return ws._socket.remoteAddress + ":" + ws._socket.remotePort;
}

function isConnectionLocalhost(ws) {
  const addr = ws._socket.remoteAddress
  return (addr == "::1") || (addr == "127.0.0.1") || (addr == "localhost") || (addr == "::ffff:127.0.0.1")
}

function noitaDoFile(fn) {
  if (noita == null) {
    return;
  }
  const fdata = fs.readFileSync(fn);
  noita.send(fdata);
}

// TODO: refactor all this into a common file
wss.on('connection', function connection(ws) {
  const cname = getConnectionName(ws);
  console.log("New connection: " + cname);
  if (!isConnectionLocalhost(ws)) {
    console.log("Connection refused: not localhost!");
    ws.terminate();
    return
  }

  ws.on('message', function incoming(data, flags) {
    let jdata = null;
    // special case: if the string we get is prefixed with ">",  
    // don't try to interpret as JSON, just treat it as a print
    if (data.slice(0, 1) == ">") {
      //console.log(data);
      if(con != null) {
        con.send(JSON.stringify({ kind: "print", text: data.slice(1) }));
      }
      return;
    } else {
      try {
        jdata = JSON.parse(data);
      } catch (e) {
        console.log(data);
        console.error(e);
        return;
      }
    }

    if (jdata["kind"] === "heartbeat") {
      if (noita != ws) {
        console.log("Registering noita!");
        noita = ws;
        ws.send(`GamePrint('Chat covenants connected as ${cname}')`);
        ws.send("set_print_to_socket(true)");
        noitaDoFile("twitch_fragments/30log.lua");
        noitaDoFile("twitch_fragments/covenant.lua");
        noitaDoFile("twitch_fragments/conditions.lua");
        noitaDoFile("twitch_fragments/outcomes.lua");
        noitaDoFile("twitch_fragments/setup.lua");
      }
    } else if(jdata["kind"] === "open_voting") {
      openVoting();
    } else if(jdata["kind"] === "close_voting") {
      closeVoting();
    } else if(jdata["kind"] === "query_votes") {
      queryVotes();
    }
  });

  ws.on('close', function closed(_ws, code, reason) {
    console.log("Connection closed: " + code + ", " + reason);
    if (ws === noita) {
      console.log("Noita closed");
      noita = null;
    }
  });
});

let acceptingVotes = false;
let userVotes = [{}, {}];

function openVoting() {
  userVotes = [{}, {}];
  acceptingVotes = true;
}

function closeVoting() {
  acceptingVotes = false;
}

function queryVotes() {
  if (noita == null) {
    return;
  }
  let [countsA, countsB] = getVotes();
  noita.send(`set_votes({${countsA.join(",")}}, {${countsB.join(",")}})`);
}

function accumVotes(voteDict) {
  let votes = [0, 0, 0, 0];
  for (uname in userVotes) {
    let v = userVotes[uname];
    if (v >= 0 && v < 4) {
      votes[v] += 1;
    }
  }
  return votes;
}

function getVotes() {
  return [accumVotes(userVotes[0]), accumVotes(userVotes[1])];
}

const topChoices = {"a": 0, "b": 1, "c": 2, "d": 3};
const botChoices = {"1": 0, "2": 1, "3": 2, "4": 3};

function handleVote(username, v) {
  // Generously try to accept anything like:
  // "a", "1", "a1", "1a"
  // (not "a 1" though that's too much of a pain)
  if(!acceptingVotes) {
    return;
  }
  let firstPart = v.trim().split(" ")[0];
  if(firstPart.length == 0 || firstPart.length > 2) {
    return;
  }
  for(charpos in firstPart) {
    let char = v[charpos].toLowerCase();
    if(char in topChoices) {
      userVotes[0][username] = topChoices[char];
    }
    if(char in botChoices) {
      userVotes[1][username] = botChoices[char];
    }
  }
}

const options = {
  options: {debug: true},
  connection: {reconnect: true}
  //identity: { username: process.env.TWITCH_USERNAME, password: process.env.TWITCH_OAUTH}
};

const chatClient = new tmi.client(options);
chatClient.connect().then((_client) => {
  chatClient.join(CHANNEL);

  chatClient.on("message", function (channel, userstate, message, self) {
    // console.log(message);
    // console.log(userstate);
    if (self) return; // Don't listen to my own messages..
    if (userstate["message-type"] === "chat") {
      handleVote(userstate['user-id'], message);
    }
  });
});

///////////////////////////////////////////////
//////////////// Dev console stuff
///////////////////////////////////////////////
const crypto = require('crypto');
const open = require('open');

function randomToken() {
  return crypto.randomBytes(16).toString('hex');
}
const TOKEN = randomToken();

const con_wss = new ws.Server({ port: 9191 });
console.log("CON-WS listening on " + 9191);

con_wss.on('connection', function connection(ws) {
  const cname = getConnectionName(ws);
  console.log("New connection: " + cname);
  if (!isConnectionLocalhost(ws)) {
    console.log("Connection refused: not localhost!");
    ws.terminate();
    return
  }

  ws.on('message', function incoming(data, flags) {
    let jdata = null;
    try {
      jdata = JSON.parse(data);
    } catch (e) {
      console.log(data);
      console.error(e);
      return;
    }

    if (jdata["kind"] === "heartbeat") {
      if (con != ws) {
        if (jdata["token"] != TOKEN) {
          console.log("Invalid token! Got: " + jdata["token"]);
          ws.terminate();
          return;
        }
        console.log("Registering console!");
        con = ws;
        ws.send(JSON.stringify({ kind: "print", text: `Connected as ${cname}` }));
      }
    } else {
      // con -> noita
      if (noita != null) {
        // Don't want to involve JSON parser on Noita end,
        // so send just the raw command
        noita.send(jdata["command"]);
      }
    }
  });
  ws.on('close', function closed(_ws, code, reason) {
    console.log("Connection closed: " + code + ", " + reason);
    if (ws === noita) {
      console.log("Noita closed");
      noita = null;
    }
    if (ws === con) {
      console.log("Console webpage closed");
      con = null;
    }
  });
});

const { join } = require('path');
const polka = require('polka');

const HTTP_PORT = 8080;
const dir = join(__dirname, 'www_console');
const serve = require('serve-static')(dir);

const secret_dir = "/" + TOKEN

polka()
  .use(secret_dir, serve)
  .listen(HTTP_PORT, err => {
    if (err) throw err;
    console.log(`Console on localhost:${HTTP_PORT}${secret_dir}`);
    open(`http://localhost:${HTTP_PORT}${secret_dir}`);
  });
