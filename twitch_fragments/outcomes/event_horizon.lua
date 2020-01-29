register_outcome{
  text = "Event Horizon",
  subtext = "Watch your step",
  unknown = true,
  comment = "todo",
  rarity = 10,
  apply = function()
    spawn{"data/entities/projectiles/deck/black_hole_big.xml", 
          count=math.random(3,6),
          position=player_vicinity{min_rad=100, max_rad=300}}
  end,
}