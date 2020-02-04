register_outcome{add_position_modifier{
  text = "Pocket change",
  subtext = "Quick, before it disappears!",
  good = true,
  comment = "todo",
  rarity = 50,
  apply = function(self)
    local ent_xml = weighted_choice{
      {"data/entities/items/pickup/goldnugget_10.xml", 10000},
      {"data/entities/items/pickup/goldnugget_50.xml", 1000},
      {"data/entities/items/pickup/goldnugget_200.xml", 100},
      {"data/entities/items/pickup/goldnugget_1000.xml", 10},
      {"data/entities/items/pickup/goldnugget_10000.xml", 1},
    }
    spawn{ent_xml, pos=self.position_target}
  end,
}}

register_outcome{
  text = "Gold Rush",
  subtext = "Quick, before it disappears!",
  good = true,
  comment = "todo",
  rarity = 50,
  apply = function(self)
    spawn{"data/entities/items/pickup/goldnugget.xml", 
          count=math.random(15,30)}
  end,
}