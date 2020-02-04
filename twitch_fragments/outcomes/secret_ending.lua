register_outcome{add_position_modifier{
  text = "Secret Ending",
  subtext = "Jebaited!",
  bad = true,
  comment = "Spawns the portal to the hentai dimension (tentacles)",
  rarity = 27,
  apply = function(self)
    spawn{"data/entities/projectiles/deck/tentacle_portal.xml", 
          hole=true, pos=self.position_target}
  end,
}}