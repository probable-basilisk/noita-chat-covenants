register_outcome{
  text = "Dryspell",
  subtext = "Cool?",
  good = true,
  comment = "todo",
  rarity = 50,
  start = function(self)
    local px, py = get_player_pos()
    self.dry_entity = EntityLoad("data/entities/dryspell.xml", px, py)
    EntityAddChild(get_player(), self.dry_entity)
  end,
  stop = function(self)
    if self.dry_entity then EntityKill(self.dry_entity) end
    self.dry_entity = nil
  end,
}