register_outcome{
  text = "Gold Rush",
  subtext = "Quick, before it disappears!",
  good = true,
  comment = "todo",
  rarity = 50,
  apply = function()
    spawn{"data/entities/items/pickup/goldnugget.xml", 
          count=math.random(15,30)}
  end,
}