register_outcome{
  text = "CHONKY",
  subtext = "That's one CHONKY Noita",
  unknown = true,
  comment = "Makes the player stomp cause damage to the terrain",
  rarity = 60,
  start = function(self)
    local player = get_player()
    local chardatacomp = EntityGetComponent(player, "CharacterDataComponent")
    for _, charmodel in ipairs(chardatacomp or {}) do
      ComponentSetValue(charmodel, "eff_hg_damage_min", "80000")
      ComponentSetValue(charmodel, "eff_hg_damage_max", "150000")
      ComponentSetValue(charmodel, "eff_hg_size_x", "30")
      ComponentSetValue(charmodel, "eff_hg_size_y", "10")
      ComponentSetValue(charmodel, "destroy_ground", "1")
    end
  end,
  stop = function(self)
    local player = get_player()
    local chardata = EntityGetComponent(player, "CharacterDataComponent")
    for _, model in ipairs(chardata or {}) do
      ComponentSetValue(model, "eff_hg_damage_min", "10")
      ComponentSetValue(model, "eff_hg_damage_max", "95")
      ComponentSetValue(model, "eff_hg_size_x", "6.42857")
      ComponentSetValue(model, "eff_hg_size_y", "5.14286")
    end
  end,
}