register_outcome{ identity{
  text = "Chests",
  subtext = "Which one is the real one?",
  unknown = true,
  comment = "Spawns mimics and a chest",
  rarity = 38,
  apply = function(self)
    spawn{"data/entities/animals/chest_mimic.xml", count=5, hole=true, pos=self.position_target}
    spawn{"data/entities/items/pickup/chest_random.xml", hole=true, pos=self.position_target}
  end,
} }