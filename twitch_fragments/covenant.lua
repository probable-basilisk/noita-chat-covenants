math.randomseed(os.time())

num_vote_options = 4

function make_vote_keys(alphabetical)
  local keys = {}
  for idx = 1, num_vote_options do
    if alphabetical then
      keys[idx] = string.char(string.byte("a") - 1 + idx)
    else
      keys[idx] = tostring(idx)
    end
  end
  return keys
end

Placeholder = class("Placeholder")
function Placeholder:init(text)
  self.text = text
end
function Placeholder:start() end
Placeholder.stop = Placeholder.start
Placeholder.reset = Placeholder.start
function Placeholder:check() return false end
function Placeholder:get_text() return self.text end
Placeholder.get_vote_text = Placeholder.get_text

Covenant = class("Covenant")
function Covenant:init(condition, outcome)
  if condition and outcome then
    self:start(condition, outcome)
  else
    self.condition = Placeholder("VVV")
    self.outcome = Placeholder("^^^")
  end
end
Covenant.kind = "generic"

function Covenant:start(condition, outcome)
  self.outcome = outcome
  self.condition = condition
  self.alive = true
  self.condition:reset()
end

function Covenant:stop()
  self.alive = false
end

function Covenant:is_live()
  return self.alive
end
Covenant.is_alive = Covenant.is_live -- alias

-- should return true if this outcome can work with this
-- covenant
function Covenant:filter_outcome()
  return true
end

UntilCovenant = Covenant:extend("UntilCovenant")
UntilCovenant.kind = "until"

function UntilCovenant:start(...)
  UntilCovenant.super.start(self, ...)
  if not (self.outcome.start and self.outcome.stop) then
    print("Outcome [" .. self.outcome.text .. "] is not startable!")
    self.alive = false
    return
  end
  if self.condition:check() then
    self.alive = false
    return
  end
  self.outcome:start()
end

function UntilCovenant:stop()
  if not self.alive then return end
  self.alive = false
  self.outcome:stop()
end

function UntilCovenant:tick()
  if not self.alive then return end
  if self.condition:check() then
    self.alive = false
    self.outcome:stop()
    return
  end
  if self.outcome.tick then self.outcome:tick() end
end

function UntilCovenant:get_text()
  return self.outcome.text .. " UNTIL " .. self.condition:get_text()
end

function UntilCovenant:filter_outcome(outcome)
  -- an 'UNTIL' outcome needs to be continuous (can start and stop)
  return outcome.start ~= nil
end

OnceCovenant = Covenant:extend("OnceCovenant")
OnceCovenant.kind = "once"

function OnceCovenant:tick()
  if not self.alive then return end
  if self.condition:check() then
    self.outcome:apply()
    self.alive = false
  end
end

function OnceCovenant:get_text()
  return self.outcome.text .. " ONCE " .. self.condition:get_text()
end

function OnceCovenant:filter_outcome(outcome)
  return outcome.apply ~= nil
end

EachCovenant = Covenant:extend("EachCovenant")
EachCovenant.kind = "each"

function EachCovenant:init(...)
  EachCovenant.super.init(self, ...)
  self._cooldown = 0
  self._should_fire = false
end

function EachCovenant:tick()
  -- basically the logic here with "_should_fire" is that if you
  -- trigger the condition *during* the cooldown, it'll buffer one
  -- additional outcome to happen right when the cooldown ends
  self._cooldown = self._cooldown - 1
  if self.condition:check() then self._should_fire = true end
  if self._should_fire and self._cooldown <= 0 then
    self._cooldown = self.outcome.cooldown or 60
    self.outcome:apply()
    self._should_fire = false
  end
end

function EachCovenant:get_text()
  local text = self.outcome.text .. " EACH TIME " .. self.condition:get_text()
  if self._cooldown > 0 then
    text = "[" .. self._cooldown .. "] " .. text
    if self._should_fire then text = "+" .. text end
  end
  return text
end

function EachCovenant:filter_outcome(outcome)
  return outcome.apply ~= nil
end

-- Outcomes --------
--------------------

local EVALUABLE_MT = {
  __index = function(t, idx)
    local raw = rawget(t, "_raw")
    local v = raw[idx]
    local holdout = rawget(t, "_holdout")
    if holdout[idx] or (type(v) ~= "function") then return v end
    local happy, result = pcall(v, raw)
    if not happy then
      print("Outcome error in field [" .. idx .. "]: " .. result)
      return nil
    end
    return result
  end,
  __newindex = function(t, idx, val)
    local raw = rawget(t, "_raw")
    raw[idx] = val
  end
}

function make_evaluable(t, holdout)
  local ret = {_raw = t, _holdout = holdout or {
    start = true, stop = true, tick = true, apply = true
  }}
  setmetatable(ret, EVALUABLE_MT)
  return ret
end

function copy_outcome(t)
  local ret = {}
  for k, v in pairs(rawget(t, "_raw")) do
    ret[k] = v
  end
  return make_evaluable(ret)
end

local function tags_to_keys(tags)
  local ret = {}
  for _, v in ipairs(tags) do ret[v] = true end
  return true
end

local next_uid = 1
function register_outcome(options)
  options.text = options.text or "Do something?"
  options.required_tags = options.required_tags or {}
  options.forbidden_tags = options.forbidden_tags or {}
  options._uid = next_uid
  next_uid = next_uid + 1
  table.insert(all_outcomes, make_evaluable(options))
end

-- Conditions

Condition = class("Condition")
function Condition:init(f, desc)
  self.f = f
  self.desc = desc or "condition is met"
end

function Condition:reset()
  -- eh
end

function Condition:get_text()
  return self.desc
end

function Condition:get_vote_text()
  return self:get_text()
end

function Condition:check()
  return self.f
end

function rate_limit_condition(condition_func, check_period)
  check_period = check_period or 6
  return coroutine.wrap(function()
    while true do
      local val = condition_func()
      for _ = 1, check_period do coroutine.yield(val) end
    end
  end)
end

-- core covenant logic