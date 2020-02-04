local SPAWN_COOLDOWN = seconds(10) -- let's not go overboard spawning things

register_outcome{add_position_modifier{
  text = "Angry Steve",
  subtext = "Steve is out to getcha!",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 20,
  apply = function(self)
    spawn{"data/entities/animals/necromancer_shop.xml", hole=true,
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "Big Worm",
  subtext = "That's one big worm",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 30,
  apply = function(self)
    spawn{"data/entities/animals/worm_big.xml",
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "Biggest Worm",
  subtext = "OH NONONONO",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 15,
  apply = function(self)
    spawn{"data/entities/animals/worm_end.xml",
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "A Couple Worms",
  subtext = "Just a couple",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "Spawns 2 worms",
  rarity = 40,
  apply = function(self)
    spawn{"data/entities/animals/worm.xml",
          pos=self.position_target}
    spawn{"data/entities/animals/worm.xml",
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "Deers",
  subtext = "Oh dear...",
  cooldown = SPAWN_COOLDOWN,
  unknown = true,
  comment = "Spawns some normal deers with deercoys mixed in",
  rarity = 50,
  apply = function(self)
    spawn{"data/entities/projectiles/deck/exploding_deer.xml", count=5,
          pos=self.position_target}
    spawn{"data/entities/animals/deer.xml", count=5,
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "MOIST MOB MEMBER",
  subtext = "Slurp slurp slurp",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 34,
  apply = function(self)
    if math.random() < 0.1 then
      spawn{"data/entities/animals/frog_big.xml", hole=true,
            pos=self.position_target}
    else
      spawn{"data/entities/animals/frog.xml", hole=true, count=math.random(1,2),
            pos=self.position_target}
    end
  end,
}}

register_outcome{add_position_modifier{
  text = "plaGUEE rat",
  subtext = "Hail the rat king",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "Spawns a bunch of normal rats, plague rats and 1 to 2 skullrats",
  rarity = 36,
  apply = function(self)
    local ent_xml = weighted_choice{
      {"data/entities/animals/rat.xml", 20},
      {"data/entities/misc/perks/plague_rats_rat.xml", 10},
      {"data/entities/animals/skullrat.xml", 1}
    }
    spawn{ent_xml, pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "Ultimate Killer",
  subtext = "Get ready...",
  cooldown = SPAWN_COOLDOWN,
  unknown = true,
  comment = "Spawns the ultimate killer",
  rarity = 1,
  apply = function(self)
    spawn{"data/entities/animals/ultimate_killer.xml",
          pos=self.position_target}
  end,
}}

register_outcome{add_position_modifier{
  text = "Can of Worms",
  subtext = "That's annoying",
  cooldown = SPAWN_COOLDOWN,
  bad = true,
  comment = "todo",
  rarity = 45.5,
  apply = function(self)
    spawn{"data/entities/animals/worm_tiny.xml", count=3,
          pos=self.position_target}
  end,
}}