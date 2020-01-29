local GASSES = {}
for _, v in ipairs(CellFactory_GetAllGases()) do 
  table.insert(GASSES, {v, resolve_localized_name("$mat_" .. v)})
end

local function give_player_farts(material)
  local fart_entity = EntityLoad("data/entities/misc/effect_farts.xml")
  EntityAddChild(get_player(), fart_entity)

  local fart_effect_comp = EntityGetFirstComponent( fart_entity, "GameEffectComponent")
  ComponentSetValue(fart_effect_comp, "frames", -1)

  local emitter_comp = EntityGetFirstComponent( fart_entity, "ParticleEmitterComponent")
  ComponentSetValue(emitter_comp, "emitted_material_name", material or "blood")
  return fart_entity, fart_effect_comp
end

register_outcome{
  text = "Acid gas farts",
  subtext = "Geez what did you eat!?",
  unknown = true,
  comment = "todo",
  rarity = 30,
  material = "acid_gas",
  mutate = function(self)
    self.material, self.text = unpack(rand_choice(GASSES))
    self.text = self.text .. " farts"
  end,
  start = function(self)
    self.farts, self.fart_effect = give_player_farts(self.material)
  end,
  stop = function(self)
    if not self.farts then return end
    ComponentSetValue(self.fart_effect, "frames", -1)
    EntityKill(self.farts)
    self.farts, self.fart_effect = nil, nil
  end
}