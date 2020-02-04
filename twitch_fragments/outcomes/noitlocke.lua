-- TODO: fix this
--[[
local function freeze_wands(frozen)
  local fkey = (frozen and "1") or "0"
  local wands = GetWands()
  if not wands then return end
  for _, wid in ipairs(wands) do
    local actions = GetWandSpells(wid)
    for _, aid in ipairs(actions or {}) do
      local action_comps = EntityGetAllComponents(aid)
      for i, c in ipairs(action_comps) do
        if ComponentGetTypeName(c) == "ItemComponent" then
          ComponentSetValue(c, "is_frozen", fkey)
        end
      end
    end
  end
end

register_outcome{
  text = "NOITLOCKE",
  subtext = "Is this Pokiman?!?!",
  legendary = true,
  comment = "Can't edit wands at all",
  rarity = 50,
  start = function(self)
    self.frame = 0
  end,
  stop = function(self)
    freeze_wands(false)
  end,
  tick = function(self)
    self.frame = self.frame + 1
    if self.frame % 120 ~= 0 then return end
    freeze_wands(true)
  end
}]]