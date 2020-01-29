register_outcome{
  text = "Random Wand",
  subtext = "WOW!!",
  good = true,
  comment = "todo",
  rarity = 18,
  apply = function()
    local rnd = Random(0, 1000)
    if rnd < 200 then
      spawn{"data/entities/items/wand_level_01.xml", position=player_pos}
    elseif rnd < 600 then
      spawn{"data/entities/items/wand_level_02.xml", position=player_pos}
    elseif rnd < 850 then
      spawn{"data/entities/items/wand_level_03.xml", position=player_pos}
    elseif rnd < 998 then
      spawn{"data/entities/items/wand_level_04.xml", position=player_pos}
    else
      spawn{"data/entities/items/wand_level_05.xml", position=player_pos}
    end
  end,
}