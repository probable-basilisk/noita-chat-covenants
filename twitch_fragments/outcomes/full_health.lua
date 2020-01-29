register_outcome{
  text = "Full Health",
  subtext = "Chat giveth",
  good = true,
  comment = "todo",
  rarity = 20,
  apply = function()
    spawn{"data/entities/items/pickup/heart_fullhp.xml", position=player_pos}
  end,
}