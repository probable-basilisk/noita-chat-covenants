covenant_gui_lines = {"BLURGH"}
vote_gui_lines = {}

gui = gui or GuiCreate()
xpos_covenant = xpos_covenant or 2
ypos_covenant = ypos_covenant or 30
xpos_vote = xpos_vote or 70
ypos_vote = ypos_vote or 30

max_covenants = 3

vote_time_left = 0
max_vote_time = 6000
time_between_covenants = 120

function draw_twitch_display()
  GuiStartFrame( gui )
  GuiLayoutBeginVertical( gui, xpos_covenant, ypos_covenant )
  for idx, line in ipairs(covenant_gui_lines) do
    GuiText(gui, 0, 0, line)
  end
  GuiLayoutEnd( gui )
  GuiLayoutBeginVertical( gui, xpos_vote, ypos_vote )
  for idx, line in ipairs(vote_gui_lines) do
    GuiText(gui, 0, 0, line)
  end
  GuiLayoutEnd( gui )
end

covenants = {}

outcomes = {}
conditions = {}

function update_covenants()
  covenant_gui_lines = {#covenants .. " COVENANTS: "}
  local player = get_player()
  if not player then
    covenant_gui_lines[1] = "(POLYMORPHED!)"
  end
  local new_covenants = {}
  for idx, covenant in ipairs(covenants) do
    table.insert(covenant_gui_lines, "> " .. covenant:get_text())
    if player then covenant:tick() end
    if covenant:is_live() then table.insert(new_covenants, covenant) end
  end
  covenants = new_covenants
end

function draw_n_generators(generators, n, filter)
  local candidates = {}
  for idx, option in ipairs(generators) do
    if (not filter) or filter(option) then
      if type(option) == "table" and option.mutate then 
        option:mutate()
      end
      table.insert(candidates, {math.random(), option})
    end
  end
  table.sort(candidates, function(a, b) return a[1] < b[1] end)
  local res = {}
  for idx = 1, n do 
    local v = candidates[idx][2]
    if type(v) == "function" then v = v() end
    res[idx] = v
    res[idx].votes = 0
  end
  return res
end

function set_votes(outcome_votes, condition_votes)
  for idx, outcome in ipairs(outcomes) do
    outcome.votes = outcome_votes[idx] or 0
  end
  for idx, condition in ipairs(conditions) do
    condition.votes = condition_votes[idx] or 0
  end
  return UNPRINTABLE_RESULT
end

local function find_winner(options)
  local max_votes, best_option = -1, nil
  for _, option in ipairs(options) do
    if (option.votes or 0) > max_votes then
      max_votes = option.votes or 0
      best_option = option
    end
  end
  return best_option
end

function push_covenant(covenant)
  while #covenants >= max_covenants do
    local c = covenants[1]
    c:stop()
    table.remove(covenants, 1)
  end
  table.insert(covenants, covenant)
end

function do_winner()
  local outcome = copy_outcome(find_winner(outcomes))
  local condition = find_winner(conditions)
  conjunction:start(condition, outcome)
  push_covenant(conjunction)
  GamePrintImportant("A New Covenant!", conjunction:get_text())
end

function random_conjunction()
  if math.random() < 1.5 then
    return EachCovenant()
  else
    return UntilCovenant()
  end
end

function update_vote_display()
  vote_gui_lines = {
    ("-- VOTE: %ds --"):format(vote_time_left),
  }
  local outcome_keys = make_vote_keys(false)
  local condition_keys = make_vote_keys(true)

  for idx, outcome in ipairs(outcomes) do
    table.insert(
      vote_gui_lines, 
      ("%s> %s (%d)"):format(outcome_keys[idx], outcome.text, outcome.votes) 
    )
  end
  table.insert(vote_gui_lines, conjunction:get_text())
  for idx, condition in ipairs(conditions) do
    table.insert(
      vote_gui_lines, 
      ("%s> %s (%d)"):format(condition_keys[idx], condition:get_vote_text(), condition.votes) 
    )
  end
end

function setup_vote()
  conjunction = random_conjunction()
  outcomes = draw_n_generators(all_outcomes, num_vote_options, function(candidate)
    return conjunction:filter_outcome(candidate)
  end)
  conditions = draw_n_generators(all_conditions, num_vote_options)
end

function wait_opportunity()
  local timeleft = time_between_covenants
  while (#covenants >= max_covenants) and timeleft > 0 do
    timeleft = timeleft - 1
    vote_gui_lines = {("Covenant change: %ds"):format(timeleft)}
    wait(60)
  end
end

function force_vote(a, b)
  local TT = {a=1, b=2, c=3, d=4, [1]=1, [2]=2, [3]=3, [4]=4}
  outcomes[TT[a]].votes = 1000
  conditions[TT[b]].votes = 1000
  vote_time_left = 0
end

function vote_covenant()
  setup_vote()
  socket_send('{"kind": "open_voting"}')
  vote_time_left = max_vote_time
  while vote_time_left > 0 do
    update_vote_display()
    socket_send('{"kind": "query_votes"}')
    vote_time_left = vote_time_left - 1
    wait(60)
  end
  socket_send('{"kind": "close_voting"}')
  do_winner()
end

function main_script()
  wait(1)
  while true do
    wait_opportunity()
    vote_covenant()
    wait(1) -- just for safety
  end
end

function restart_main()
  async(main_script)
end

add_persistent_func("update_covenants", update_covenants)
add_persistent_func("twitch_gui", draw_twitch_display)

restart_main()
print("got through setup???")