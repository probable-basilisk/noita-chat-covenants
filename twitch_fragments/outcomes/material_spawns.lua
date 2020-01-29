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
}

--[[
register_outcome{
  text = "Random Flask",
  subtext = "What's in it?",
  good = true,
  comment = "todo",
  rarity = 15,
  apply = function()
    local potion_material = ""
    if (Random(0, 100) <= 75) then
    if (Random(0, 100000) <= 50) then
    potion_material = "magic_liquid_hp_regeneration"
    elseif (Random(200, 100000) <= 250) then
    potion_material = "purifying_powder"
    else
    potion_material = random_from_array(potion_materials_magic)
    end
    else
    potion_material = random_from_array(potion_materials_standard)
    end
    local x, y = get_player_pos()
    -- just go ahead and assume cheatgui is installed
    local entity = EntityLoad("data/hax/potion_empty.xml", x, y)
    AddMaterialInventoryMaterial(entity, potion_material, 1000)
  end,
}]]

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

--[[
register_outcome{
  text = "Rainy Day",
  subtext = "Some rain on your parade",
  unknown = true,
  comment = "todo",
  rarity = 20,
  apply = function()
    local material_choices = { "blood", "radioactive_liquid", "water", "slime", "magic_liquid_charm" };
    local min_distance = 24;
    local max_distance = 36;
    for _,player_entity in pairs( get_players() ) do
    local x, y = EntityGetTransform( player_entity );
    SetRandomSeed( GameGetFrameNum(), x + y );
    local chosen_material = material_choices[ Random( 1, #material_choices ) ];
    local distance = Random( min_distance, max_distance );
    local angle = math.rad(-90);
    local sx, sy = x + math.cos( angle ) * distance, y + math.sin( angle ) * distance;
    local cloud = EntityLoad( "data/entities/projectiles/deck/cloud_water.xml", sx, sy );
    local cloud_children = EntityGetAllChildren( cloud ) or {};
    for _,cloud_child in pairs( cloud_children ) do
    local child_components = FindComponentByType( cloud_child, "ParticleEmitterComponent" ) or {};
    for _,component in pairs( child_components ) do
    if ComponentGetValue( component, "emitted_material_name" ) == "water" then
    ComponentSetValue( component, "emitted_material_name", chosen_material );
    break;
    end
    end
    end
    end
  end,
}
]]