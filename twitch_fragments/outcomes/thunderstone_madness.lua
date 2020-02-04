register_outcome{add_position_modifier{
  text = "THUNDERSTONES!?!",
  subtext = "Ay",
  unknown = true,
  comment = "todo",
  rarity = 39,
  apply = function(self)
    spawn{"data/entities/items/pickup/thunderstone.xml", count=15,
          pos=self.position_target}
  end,
}}