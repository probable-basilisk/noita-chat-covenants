local SPAWN_COOLDOWN = 600 -- let's not go overboard spawning things

register_outcome{
  text = "Angry Steve",
  subtext = "Steve is out to getcha!",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 20,
  apply = function()
    spawn{"data/entities/animals/necromancer_shop.xml", hole=true}
  end,
}

register_outcome{
  text = "Big Worm",
  subtext = "That's one big worm",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 30,
  apply = function()
    spawn{"data/entities/animals/worm_big.xml", min_rad=100, max_rad=100}
  end,
}

register_outcome{
  text = "Biggest Worm",
  subtext = "OH NONONONO",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 15,
  apply = function()
    spawn{"data/entities/animals/worm_end.xml", min_rad=100, max_rad=150}
  end,
}

register_outcome{
  text = "A Couple Worms",
  subtext = "Just a couple",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "Spawns 2 worms",
  rarity = 40,
  apply = function()
    spawn{"data/entities/animals/worm.xml", min_rad=50, max_rad=200}
    spawn{"data/entities/animals/worm.xml", min_rad=50, max_rad=200}
  end,
}

register_outcome{
  text = "Deers",
  subtext = "Oh dear...",
  cooldown = SPAWN_COOLDOWN,
  unknown = true,
  comment = "Spawns some normal deers with deercoys mixed in",
  rarity = 50,
  apply = function()
    spawn{"data/entities/projectiles/deck/exploding_deer.xml", min_rad=100, max_rad=300, count=5}
    spawn{"data/entities/animals/deer.xml", min_rad=100, max_rad=300, count=5}
  end,
}

register_outcome{
  text = "THE MOIST MOB",
  subtext = "Slurp slurp slurp",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 34,
  apply = function()
    spawn{"data/entities/animals/frog_big.xml", min_rad=30, max_rad=180, hole=true}
    spawn{"data/entities/animals/frog.xml", min_rad=50, max_rad=150, holde=true, count=math.random(3,10)}
  end,
}

register_outcome{
  text = "plaGUEE Rats",
  subtext = "Hail the rat king",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "Spawns a bunch of normal rats, plague rats and 1 to 2 skullrats",
  rarity = 36,
  apply = function()
    spawn{"data/entities/animals/rat.xml", count=math.random(20,30)}
    spawn{"data/entities/misc/perks/plague_rats_rat.xml", count=math.random(10,20)}
    spawn{"data/entities/animals/skullrat.xml", count=math.random(1,2)}
  end,
}

register_outcome{
  text = "Ultimate Killer",
  subtext = "Get ready...",
  cooldown = SPAWN_COOLDOWN,
  unknown = true,
  comment = "Spawns the ultimate killer",
  rarity = 1,
  apply = function()
    spawn{"data/entities/animals/ultimate_killer.xml"}
  end,
}

register_outcome{
  text = "Can of Worms",
  subtext = "That's annoying",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 45.5,
  apply = function()
    spawn{"data/entities/animals/worm_tiny.xml", count=10}
  end,
}