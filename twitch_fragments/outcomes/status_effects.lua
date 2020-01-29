-- {effect_name, whether_good}
local EFFECTS = {
  {"BLINDNESS", "Blindness", false},
  {"CONFUSION", "Confusion", false},
  {"WORM_ATTRACTOR", "Attract worms", false},
  {"DRUNK", "Drunk", false},
  {"CRITICAL_HIT_BOOST", "Better crits", true},
  {"DAMAGE_MULTIPLIER", "More damage", true},
  {"EDIT_WANDS_EVERYWHERE", "Edit wands", true},
  --{"ELECTROCUTION", true}, -- works but game-ender
  {"EXPLODING_CORPSE_SHOTS", "Exploding shots", true},
  {"EXTRA_MONEY", "More money", true},
  {"GLOBAL_GORE", "More gore", true}, -- more blood
  {"HEALING_BLOOD", "Vampirism", true}, -- heal by drinking blood
  {"LEVITATION", "Levitation??", true}, -- ??
  {"REMOVE_FOG_OF_WAR", "No fog", true},
  {"TELEPATHY", "Telepathy???", true}, -- ??
  {"WORM_DETRACTOR", "Worms hate you", true},
  {"MELEE_COUNTER", "Melee counterhit", true}
}

for _, effect_info in ipairs(EFFECTS) do
  local code_name, text, good = unpack(effect_info)
  register_effect{
    text = text,
    effect_name = code_name,
    bad = not good,
    rarity = 6,
  }
end

register_outcome{
  text = "Electrocution",
  subtext = "Positively shocking!",
  bad = true,
  comment = "electrocutes player",
  rarity = 6,
  apply = function()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo( player, "ELECTROCUTION", true )
    if game_effect then ComponentSetValue( game_effect, "frames", 120 ) end
  end,
}