register_outcome{
  text = "Unshuffle",
  subtext = "Yay!",
  good = true,
  comment = "todo",
  rarity = 22.5,
  apply = function()
    local wands = GetWands()
    if wands == nil then return end
    local to_boost = Random(1, table.getn(wands))
    
    for i = 1, to_boost do
    local ability = EntityGetAllComponents(wands[i])
    for _, c in ipairs(ability) do
    if ComponentGetTypeName(c) == "AbilityComponent" then
    cur = 0
    ComponentObjectSetValue(c, "gun_config",
    "shuffle_deck_when_empty", tostring(cur))
    end
    end
    end
  end,
}