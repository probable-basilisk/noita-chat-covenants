register_outcome{add_position_modifier{
  text = "Random Wand",
  subtext = "WOW!!",
  good = true,
  comment = "todo",
  rarity = 18,
  cooldown = seconds(30),
  possible_positions={"at_player", "at_enemy"},
  apply = function(self)
    local rnd = Random(0, 1000)
    if rnd < 200 then
      spawn{"data/entities/items/wand_level_01.xml", 
            position=self.position_target}
    elseif rnd < 600 then
      spawn{"data/entities/items/wand_level_02.xml", 
            position=self.position_target}
    elseif rnd < 850 then
      spawn{"data/entities/items/wand_level_03.xml", 
            position=self.position_target}
    elseif rnd < 998 then
      spawn{"data/entities/items/wand_level_04.xml", 
            position=self.position_target}
    else
      spawn{"data/entities/items/wand_level_05.xml", 
            position=self.position_target}
    end
  end,
}}