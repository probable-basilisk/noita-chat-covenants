local function get_enemy_xml(ent)
  local stats_comp = EntityGetFirstComponent(ent, "GameStatsComponent")
  if not stats_comp then return nil end
  local animal_name = ComponentGetValue(stats_comp, "name")
  return "data/entities/animals/" .. animal_name .. ".xml"
end

local function clone_nearby_entity(x, y, tag)
  local ent = get_closest_entity(x, y, tag or "homing_target")
  if not ent then return end
  local xml = get_enemy_xml(ent)
  if not xml then return end
  print("Trying to clone ", xml)
  local ex, ey = EntityGetTransform(ent)
  local nx, ny = FindFreePositionForBody(ex, ey, 300, 300, 30)
  return EntityLoad(xml, nx, ny)
end

register_outcome{
  text = "Clone enemy",
  bad = true,
  apply = function()
    local x, y = get_player_pos()
    clone_nearby_entity(x, y)
  end,
}