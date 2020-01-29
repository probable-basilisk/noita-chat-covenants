register_outcome{
  text = "THUNDERSTONES!?!",
  subtext = "Ay",
  unknown = true,
  comment = "todo",
  rarity = 39,
  apply = function()
    spawn{"data/entities/items/pickup/thunderstone.xml", count=15}
  end,
}