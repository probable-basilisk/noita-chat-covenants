register_outcome{
  text = "Spell Refresher",
  subtext = "Do you even need it?",
  good = true,
  comment = "todo",
  rarity = 48,
  apply = function()
    spawn{"data/entities/items/pickup/spell_refresh.xml", position=player_pos}
  end,
}