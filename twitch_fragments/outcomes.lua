all_outcomes = {}

function resolve_localized_name(s, default)
  if s:sub(1,1) ~= "$" then return s end
  local rep = GameTextGet(s)
  if rep and rep ~= "" then return rep else return default or s end
end

function twiddle_health(f)
  local damagemodels = EntityGetComponent( get_player(), "DamageModelComponent" )
  if( damagemodels ~= nil ) then
    for i,damagemodel in ipairs(damagemodels) do
      local max_hp = tonumber(ComponentGetValue( damagemodel, "max_hp"))
      local cur_hp = tonumber(ComponentGetValue( damagemodel, "hp"))
      local new_cur, new_max = f(cur_hp, max_hp)
      ComponentSetValue( damagemodel, "max_hp", new_max)
      ComponentSetValue( damagemodel, "hp", new_cur)
    end
  end
end

function urand(mag)
  return math.floor((math.random()*2.0 - 1.0)*mag)
end

function spawn_item(path, offset_mag)
  local x, y = get_player_pos()
  local dx, dy = urand(offset_mag or 0), urand(offset_mag or 0)
  print(x + dx, y + dy)
  local entity = EntityLoad(path, x + dx, y + dy)
end

function wrap_spawn(path, offset_mag)
  return function() spawn_item(path, offset_mag) end
end

-- 0 to not limit axis, -1 to limit to negative values, 1 to limit to positive values
function generate_value_in_range(max_range, min_range, limit_axis)
  local range = (max_range or 0) - (min_range or 0)
  if (limit_axis or 0) == 0 then
    limit_axis = Random(0, 1) == 0 and 1 or -1
  end

  return (Random(0, range) + (min_range or 0)) * limit_axis
end

function spawn_item_in_range(path, min_x_range, max_x_range, min_y_range, max_y_range, limit_x_axis, limit_y_axis, spawn_blackhole)
  local x, y = get_player_pos()
  local dx = generate_value_in_range(max_x_range, min_x_range, limit_x_axis)
  local dy = generate_value_in_range(max_y_range, min_y_range, limit_y_axis)

  if spawn_blackhole then
    EntityLoad("data/entities/projectiles/deck/black_hole.xml", x + dx, y + dy)
  end
  
  return EntityLoad(path, x + dx, y + dy)
end

function spawn_item(path, min_range, max_range, spawn_blackhole)
  return spawn_item_in_range(path, min_range, max_range, min_range, max_range, 0, 0, spawn_blackhole)
end

function copy(options)
  local ret = {}
  for k, v in pairs(options) do ret[k] = v end
  return ret
end

function register_effect(options)
  options.start = function(self)
    local player = get_player()
    self.effect = GetGameEffectLoadTo(player, self.effect_name, true)
    ComponentSetValue(self.effect, "frames", -1)
  end
  options.stop = function(self)
    if not self.effect then return end
    ComponentSetValue(self.effect, "frames", 1)
    self.effect = nil
  end
  register_outcome(options)
end