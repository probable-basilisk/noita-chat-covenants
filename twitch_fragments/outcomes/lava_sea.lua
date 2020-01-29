register_outcome{
  text = "Sea of Lava",
  subtext = "Watch your step",
  bad = true,
  comment = "todo",
  rarity = 42,
  apply = function()
    spawn_item_in_range("data/entities/projectiles/deck/sea_lava.xml", 0, 200,
    20, 100, 0, 1, false)
  end,
}