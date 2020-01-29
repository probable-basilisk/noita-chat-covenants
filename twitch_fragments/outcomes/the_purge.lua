register_outcome{
  text = "The Purge",
  subtext = "BATTLE ROYALE",
  unknown = true,
  comment = "Everyone against eachother",
  rarity = 44,
  start = function(self)
    local player = get_player()
    local world_entity_id = GameGetWorldStateEntity()
    if not world_entity_id then return end
    local comp_worldstate = EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
    if not comp_worldstate then return end
    local global_genome = ComponentGetValue(comp_worldstate, "global_genome_relations_modifier")
    self.original_modifier = global_genome
    ComponentSetValue(comp_worldstate, "global_genome_relations_modifier", "-200")
  end,
  stop = function(self)
    local world_entity_id = GameGetWorldStateEntity()
    if not world_entity_id then return end
    local comp_worldstate = EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
    if not comp_worldstate then return end
    ComponentSetValue(comp_worldstate, "global_genome_relations_modifier", tostring(self.original_modifier))
  end,
}