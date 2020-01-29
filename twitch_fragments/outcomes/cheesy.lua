register_outcome{
  text = "Cheese",
  subtext = "GIVE ME THE CHEESE",
  unknown = true,
  comment = "todo",
  rarity = 10,
  apply = function()
    local px, py = get_player_pos()
    EntityLoad("data/entities/cheesy.xml", px, py)
  end,
}