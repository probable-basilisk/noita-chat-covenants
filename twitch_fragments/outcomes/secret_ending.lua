register_outcome{
  text = "Secret Ending",
  subtext = "Jebaited!",
  bad = true,
  comment = "Spawns the portal to the hentai dimension (tentacles)",
  rarity = 27,
  apply = function()
    spawn{"data/entities/projectiles/deck/tentacle_portal.xml", hole=true, min_rad=10, max_rad=50}
  end,
}