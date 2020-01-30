local true_original_gravity = nil
local function set_gravity(v)
  local cpc = EntityGetFirstComponent(get_player(), "CharacterPlatformingComponent")
  if not true_original_gravity then
    true_original_gravity = ComponentGetValue(cpc, "pixel_gravity")
  end
  ComponentSetValue(cpc, "pixel_gravity", v)
end

local function restore_gravity()
  if true_original_gravity then set_gravity(true_original_gravity) end
end

register_outcome{
  text = "Low gravity",
  subtext = "how annoying",
  comment = "Completely miniscule gravity",
  rarity = 50,
  start = function(self)
    set_gravity("10")
  end,
  stop = function(self)
    restore_gravity()
  end,
}

register_outcome{
  text = "High gravity",
  subtext = "how annoying",
  comment = "Annoyingly high gravity",
  rarity = 50,
  start = function(self)
    set_gravity("900")
  end,
  stop = function(self)
    restore_gravity()
  end,
}