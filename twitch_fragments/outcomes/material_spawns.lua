local LIQUIDS = {}
for _, v in ipairs(CellFactory_GetAllLiquids()) do 
  table.insert(LIQUIDS, {v, resolve_localized_name("$mat_" .. v)})
end

-- Note here we make "mutating" outcomes rather than clogging
-- up the outcomes list with like thirty variations on circles
register_outcome{
  text = "Circle of acid",
  subtext = "Who thought this was a good idea",
  bad = true,
  material = "acid",
  mutate = function(self)
    self.material, self.text = unpack(rand_choice(LIQUIDS))
    self.text = "Circle of " .. self.text
  end,
  apply = function(self)
    local circle = spawn{"data/entities/projectiles/deck/circle_acid.xml", hole=true}
    local emitter_comp = EntityGetFirstComponent(circle, "ParticleEmitterComponent")
    ComponentSetValue(emitter_comp, "emitted_material_name", self.material or "acid")
  end,
}

-- Seas hard-crash the game for some reason!
--[[
register_outcome{
  text = "Sea of acid",
  subtext = "Who thought this was a good idea",
  bad = true,
  material = "acid",
  mutate = function(self)
    self.material, self.text = unpack(LIQUIDS[math.random(#LIQUIDS)])
    self.text = "Sea of " .. self.text
  end,
  apply = function(self)
    local sea = spawn{"data/entities/projectiles/deck/sea_lava.xml", 
                      hole=true, position=below_player{}}
    local emitter_comp = EntityGetFirstComponent(sea, "MaterialSeaSpawnerComponent")
    ComponentSetValue(emitter_comp, "material", self.material or "acid")
  end,
}]]

register_outcome{
  text = "Flask of ...",
  subtext = "What's in it?",
  good = true,
  comment = "todo",
  rarity = 15,
  mutate = function(self)
    self.material, self.text = unpack(rand_choice(LIQUIDS))
    self.text = "Flask of " .. self.text
  end,
  apply = function(self)
    local quantity = 1000
    if math.random() < 0.1 then
      quantity = 10000 -- LOL
    end
    -- just go ahead and assume cheatgui is installed
    local entity = spawn{"data/hax/potion_empty.xml", hole=true}
    AddMaterialInventoryMaterial(entity, self.material, quantity)
  end,
}

--[[
register_outcome{
  text = "The Alchemic Circle",
  subtext = "Yikes",
  unknown = true,
  comment = "todo",
  rarity = 3.3,
  apply = function()
    local above = Random(0, 1) > 0
    local mats = {
      "void_liquid",
      "oil",
      "fire",
      "blood",
      "water",
      "acid",
      "alcohol",
      "material_confusion",
      "magic_liquid_movement_faster",
      "magic_liquid_worm_attractor",
      "magic_liquid_protection_all",
      "magic_liquid_mana_regeneration",
      "magic_liquid_teleportation",
      "magic_liquid_hp_regeneration"
    }
    local circle = spawn_something("data/entities/projectiles/deck/circle_acid.xml", 80, 160, above, true)
    async(function()
      ComponentSetValue( EntityGetFirstComponent( circle, "LifetimeComponent" ), "lifetime", "900" )
      ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "airflow_force", "0.01" );
      ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "image_animation_speed", "3" );
      for i = 1, 10 do
        ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "emitted_material_name", mats[ Random( 1, #mats ) ] );
        wait(20)
      end
    end)
  end,
}]]

register_outcome{
  text = "Rain of ...",
  subtext = "Some rain on your parade",
  comment = "todo",
  rarity = 20,
  mutate = function(self)
    self.material, self.text = unpack(rand_choice(LIQUIDS))
    self.text = "Rain of " .. self.text
  end,
  apply = function(self)
    local cloud = spawn{"data/entities/projectiles/deck/cloud_water.xml", position=above_player{}}
    for _, child in pairs(EntityGetAllChildren(cloud) or {}) do
      for _, comp in pairs(EntityGetComponent(child, "ParticleEmitterComponent" ) or {} ) do
        if ComponentGetValue(comp, "emitted_material_name" ) == "water" then
          ComponentSetValue(comp, "emitted_material_name", self.material)
        end
      end
    end
  end,
}