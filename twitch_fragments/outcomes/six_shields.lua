-- TODO: make this a continuous outcome

--[[
register_outcome{
  text = "6 SHIELDS WHAT?!?!?",
  subtext = "But projectiles hit like a truck!",
  good = true,
  comment = "todo",
  rarity = 15,
  apply = function()
    local player = get_player()
    local shieldrad = tonumber(GlobalsGetValue("twitch_shieldsize", "10"))
    for i = 1, 6 do
    local x, y = get_player_pos()
    local shield = EntityLoad("data/entities/misc/perks/shield.xml", x, y)
    
    local emitters =
    EntityGetComponent(shield, "ParticleEmitterComponent") or {};
    for _, emitter in pairs(emitters) do
    ComponentSetValueValueRange(emitter, "area_circle_radius",
    shieldrad, shieldrad);
    end
    local energy_shield = EntityGetFirstComponent(shield,
    "EnergyShieldComponent");
    ComponentSetValue(energy_shield, "radius", tostring(shieldrad));
    ComponentSetValue(energy_shield, "recharge_speed", "0.015");
    if shield ~= nil then EntityAddChild(player, shield); end
    shieldrad = shieldrad + 2
    end
    GlobalsSetValue("twitch_shieldsize", tostring(shieldrad))
    local damagemodels = EntityGetComponent(player, "DamageModelComponent")
    if (damagemodels ~= nil) then
    for i, damagemodel in ipairs(damagemodels) do
    local projectile_resistance =
    tonumber(ComponentObjectGetValue(damagemodel,
    "damage_multipliers",
    "projectile"))
    projectile_resistance = projectile_resistance * 2
    ComponentObjectSetValue(damagemodel, "damage_multipliers",
    "projectile",
    tostring(projectile_resistance))
    end
    end
  end,
}
]]