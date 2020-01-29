all_conditions = {}
all_conditions['each'] = {}
all_conditions['until'] = {}

local function check_stat(keyname)
  return function()
    return tonumber(StatsGetValue(keyname)) or 0
  end
end

StatCondition = Condition:extend("StatCondition")
function StatCondition:init(stat, fstr, delta)
  self.fstr = fstr
  self.stat = stat
  self.f = check_stat(stat)
  self.delta = delta
  self:reset()
end

function StatCondition:reset()
  self.target = self.f() + self.delta
end

function StatCondition:check()
  self.cur_val = self.f()
  local condition_met = self.cur_val >= self.target
  if condition_met then -- move target forward again
    self:reset()
  end
  return condition_met
end

function StatCondition:get_text()
  local remaining = self.target - (self.cur_val or self.f())
  return self.fstr:format(remaining)
end

function StatCondition:get_vote_text()
  return self.fstr:format(self.delta)
end

local stats = {
  {"visit %d new locations", "places_visited", 1, 2},
  {"pick up %d gold", "gold_all", 10, 1000},
  {"pick up %d hearts", "heart_containers", false, 1},
  {"pick up %d items", "items", 1, 10},
  {"shoot %d times", "projectiles_shot", 10, false},
  {"kick %d times", "kicks", 1, false},
  {"kill %d enemies", "enemies_killed", 1, 50}
}

for _, info in ipairs(stats) do
  local fstr, keyname, each_delta, until_delta = unpack(info)
  if each_delta then
    table.insert(all_conditions['each'], function(d)
      return StatCondition(keyname, fstr, each_delta)
    end)
  end
  if until_delta then
    table.insert(all_conditions['until'], function(d)
      return StatCondition(keyname, fstr, until_delta)
    end)
  end
end

MoveCondition = Condition:extend("MoveCondition")
function MoveCondition:init(fstr, xmult, ymult, clamp, delta)
  self.delta = delta
  self.xmult, self.ymult = xmult, ymult
  self.clamp = clamp
  self.fstr = fstr
  self:reset()
end

function MoveCondition:reset()
  self.distance = 0
  self.x, self.y = get_player_pos()
end

function MoveCondition:check()
  local x, y = get_player_pos()
  local dx = (x - self.x) * self.xmult
  local dy = (y - self.y) * self.ymult
  if self.clamp then
    dx = math.max(0, dx)
    dy = math.max(0, dy)
  end
  self.distance = self.distance + math.sqrt(dx*dx + dy*dy)
  self.x, self.y = x, y
  local condition_met = self.distance >= self.delta
  if condition_met then -- move target forward again
    self:reset()
  end
  return condition_met
end

function MoveCondition:get_text()
  local remaining = self.delta - (self.distance or 0)
  return self.fstr:format(remaining)
end

function MoveCondition:get_vote_text()
  return self.fstr:format(self.delta)
end

local moves = {
  {"descend %d units", 0, 1, true, 200, 3000},
  {"ascend %d units", 0, -1, true, 200, 3000},
  {"travel %d units", 1.0, 1.0, false, 200, 3000},
  {"move horizontally %d units", 1.0, 0.0, false, 200, 3000}
}

for _, info in ipairs(moves) do
  local fstr, xmult, ymult, clamp, each_delta, until_delta = unpack(info)
  if each_delta then
    table.insert(all_conditions['each'], function(d)
      return MoveCondition(fstr, xmult, ymult, clamp, each_delta)
    end)
  end
  if until_delta then
    table.insert(all_conditions['until'], function(d)
      return MoveCondition(fstr, xmult, ymult, clamp, until_delta)
    end)
  end
end

function is_inventory_open()
  local player = get_player()
  if not player then return false end
  local inven_gui = EntityGetFirstComponent(player, "InventoryGuiComponent")
  if not inven_gui then return false end
  return ComponentGetValue(inven_gui, "mActive") == "1"
end

InventoryCondition = Condition:extend("InventoryCondition")
function InventoryCondition:init(count)
  self.target = count
  self.last_open = false
  self.fstr = "open inventory %d times"
  self:reset()
end

function InventoryCondition:reset()
  self.open_count = 0
end

function InventoryCondition:check()
  local cur_open = is_inventory_open()
  if cur_open and (not self.last_open) then
    self.open_count = self.open_count + 1
  end
  self.last_open = cur_open
  local met = self.open_count >= self.target
  if met then self:reset() end
  return met
end

function InventoryCondition:get_text()
  --self.fstr:format(self.target - self.open_count)
  return "open inventory"
end

function InventoryCondition:get_vote_text()
  return self.fstr:format(self.target)
end

table.insert(all_conditions['each'], function(d)
  return InventoryCondition(1)
end)

local function is_jetpack_being_used()
  local controls = EntityGetFirstComponent(get_player(), "ControlsComponent")
  if controls then 
    return ComponentGetValue(controls, "mButtonDownFly") == "1"
  else
    return false
  end
end

JetpackCondition = Condition:extend("JetpackCondition")
function JetpackCondition:init(frames)
  self.target = frames
  self.fstr = "use jetpack %d"
  self:reset()
end

function JetpackCondition:reset()
  self.jetpack_count = 0
end

function JetpackCondition:check()
  local cur_jetpacking = is_jetpack_being_used()
  if cur_jetpacking then
    self.jetpack_count = self.jetpack_count + 1
  end
  local met = self.jetpack_count >= self.target
  if met then self:reset() end
  return met
end

function JetpackCondition:get_text()
  return self.fstr:format(self.target - self.jetpack_count)
end

function JetpackCondition:get_vote_text()
  return self.fstr:format(self.target)
end

table.insert(all_conditions['each'], function(d)
  return JetpackCondition(100)
end)

-- Check stains:
local function get_stains()
  local se = EntityGetFirstComponent(get_player(), "StatusEffectDataComponent")
  return get_vector_value(se, "stain_effects")
end

--TODO