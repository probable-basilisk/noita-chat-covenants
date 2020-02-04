function get_player()
  return EntityGetWithTag("player_unit")[1]
end

function get_players()
  return EntityGetWithTag("player_unit") or {}
end

function get_player_pos()
  return EntityGetTransform(get_player())
end
player_pos = get_player_pos

function get_closest_entity(px, py, tag)
  if not py then
    tag = px
    px, py = get_player_pos()
  end
  return EntityGetClosestWithTag(px, py, tag or "hittable")
end

function get_entity_mouse(tag)
  local mx, my = DEBUG_GetMouseWorld()
  return get_closest_entity(mx, my, tag or "hittable")
end

function get_mouse_pos()
  return DEBUG_GetMouseWorld()
end
mouse_pos = get_mouse_pos

function teleport(x, y)
  EntitySetTransform(get_player(), x, y)
end

local metafuncs = {}
function resolve_pos(pos)
  if type(pos) == "function" then 
    return pos()
  else
    return unpack(pos)
  end
end

function vicinity(pos, options)
  options = options or {}
  local min_rad = options.min_rad or 50
  local max_rad = options.max_rad or 100
  local theta_max = options.theta_max or (math.pi*2.0)
  return function()
    local x, y = resolve_pos(pos)
    -- Note: this is not a uniform distribution, it samples
    -- more densely closer to the center
    local rad = math.random(min_rad, max_rad)
    local theta = math.random()*theta_max
    x = x + math.cos(theta)*rad
    y = y + math.sin(theta)*rad
    print(x, y)
    return FindFreePositionForBody(x, y, 300, 300, 30)
  end
end

function player_vicinity(options)
  return vicinity(player_pos, options)
end

function below_player(options)
  options = copy(options)
  options.theta_max = math.pi
  return player_vicinity(options)
end

function from_above(pos, options)
  options = options or {}
  local y_margin = options.margin or 30
  local trace_dist = options.max_dist or 200
  return function()
    local x, y = resolve_pos(pos)
    local rhit, rx, ry = Raytrace(x, y - y_margin, x, y - trace_dist)
    y = (rhit and (ry + y_margin)) or (y - trace_dist)
    return x, y
  end
end

function above_player(options)
  return from_above(player_pos, options)
end

function spawn(options)
  local entities = {}
  for i = 1, options.count or 1 do
    local pos = options.position or options.pos or player_vicinity(options)
    if type(pos) == "function" then
      pos = {pos()}
    end
    if type(pos) == "function" then
      error("Position is wrong; did you forget {} (e.g., below_player{})?")
    end
    local x, y = unpack(pos)

    if options.hole or options.blackhole then
      EntityLoad("data/entities/projectiles/deck/black_hole.xml", x, y)
    end
    --print("Spawning ", options.xml or options[1], x, y)
    entities[i] = EntityLoad(options.xml or options[1], x, y)
  end
  if #entities <= 1 then return entities[1] else return entities end
end

function resolve_localized_name(s, default)
  if not s then return "NIL" end
  if s:sub(1, 1) ~= "$" then return s end
  local rep = GameTextGet(s)
  if rep and rep ~= "" then
    return rep
  else
    return default or s
  end
end

function get_player_health()
  local damagemodel = EntityGetFirstComponent(get_player(), "DamageModelComponent")
  if not damagemodel then return 0, 0 end
  local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
  local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
  return cur_hp, max_hp
end

function twiddle_health(f)
  local damagemodels = EntityGetComponent(get_player(), "DamageModelComponent")
  if (damagemodels ~= nil) then
    for i, damagemodel in ipairs(damagemodels) do
      local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
      local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
      local new_cur, new_max = f(cur_hp, max_hp)
      ComponentSetValue(damagemodel, "max_hp", new_max)
      ComponentSetValue(damagemodel, "hp", new_cur)
    end
  end
end

function symmetric_rand(mag) 
  return (math.random() * 2.0 - 1.0) * (mag or 1.0)
end

function rand_choice(options)
  return options[math.random(#options)]
end

function wrap_spawn(path, offset_mag)
  return function() spawn_item(path, offset_mag) end
end

function add_text_to_entity(entity, text)
  local component = EntityAddComponent( entity, "SpriteComponent", {
    _tags = "enabled_in_world",
    image_file = text.font or "data/fonts/font_pixel_white.xml",
    emissive = "1",
    is_text_sprite = "1",
    offset_x = text.offset_x or "0",
    offset_y = text.offset_y or "0",
    alpha = text.alpha or "1",
    update_transform = "1",
    update_transform_rotation = "0",
    text = text.string or "",
    has_special_scale = "1",
    special_scale_x = text.scale_x or "1",
    special_scale_y = text.scale_y or "1",
    z_index = "-9000"
  } )
  return component
end

function get_player_wands()
  local inven = nil
  for _, child in ipairs(EntityGetAllChildren(get_player()) or {}) do
    if EntityGetName(child) == "inventory_quick" then
      inven = child
      break
    end
  end
  if not inven then return end
  local wands = {}
  for _, child_item in ipairs(EntityGetAllChildren(inven) or {}) do
    if EntityHasTag(child_item, "wand") then
      table.insert(wands, child_item)
    end
  end
  return wands
end

function get_wand_spells(entity)
  local spells = {}
  for _, child in ipairs(EntityGetAllChildren(entity) or {}) do
    if EntityHasTag(child, "card_action") then
      table.insert(spells, child)
    end
  end
  return spells
end

function frames_as_secs(frames)
  local secs = frames / 60.0
  if secs > 10 then
    return ("%d"):format(secs)
  else
    return ("%0.2fs"):format(secs)
  end
end
