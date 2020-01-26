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
    self.condition = Placeholder("(" .. table.concat(make_vote_keys(false), ",") .. ")")
    self.outcome = Placeholder("(" .. table.concat(make_vote_keys(true), ",") .. ")")
  end
end

function Covenant:start(condition, outcome)
  self.outcome = outcome
  self.condition = condition
  self.alive = true
  self.condition:reset()
end

function Covenant:stop()
end

function Covenant:is_live()
  return self.alive
end

UntilCovenant = Covenant:extend("UntilCovenant")
function UntilCovenant:start(...)
  UntilCovenant.super.start(self, ...)
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
  self.outcome:apply_tick()
end

function UntilCovenant:get_text()
  return self.outcome:get_text() .. " UNTIL " .. self.condition:get_text()
end

OnceCovenant = Covenant:extend("OnceCovenant")
function OnceCovenant:tick()
  if not self.alive then return end
  if self.condition:check() then
    self.outcome:apply_once()
    self.alive = false
  end
end

function OnceCovenant:get_text()
  return self.outcome:get_text() .. " ONCE " .. self.condition:get_text()
end

EachCovenant = Covenant:extend("EachCovenant")
function EachCovenant:tick()
  if self.condition:check() then
    self.outcome:apply_tick()
  end
end

function EachCovenant:get_text()
  return self.outcome:get_text() .. " EACH TIME " .. self.condition:get_text()
end

-- Outcomes
Outcome = class("Outcome")
function Outcome:init(f, desc)
  self.f = f
  self.desc = desc or "something happens"
end

function Outcome:get_text()
  return self.desc
end

function Outcome:start()
  -- 'stateless' outcomes don't need to implement these
end

function Outcome:stop()
  -- ^^
end

function Outcome:apply_tick()
  self.f()
end

function Outcome:apply_once()
  self.f()
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