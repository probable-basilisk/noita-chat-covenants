register_outcome{
  text = "Chests",
  subtext = "Which one is the real one?",
  unknown = true,
  comment = "Spawns mimics and a chest",
  rarity = 38,
  apply = function()
    spawn{"data/entities/animals/chest_mimic.xml", count=5}
    spawn{"data/entities/items/pickup/chest_random.xml"}
  end,
}