register_outcome{
  text = "Earthquake!",
  subtext = "Take cover!",
  bad = true,
  comment = "todo",
  rarity = 10,
  apply = function()
    spawn{"data/entities/projectiles/deck/crumbling_earth.xml", position=player_pos}
  end,
}