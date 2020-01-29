function GetWands()
    local childs = EntityGetAllChildren(get_player())
    local inven = nil
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityGetName(child) == "inventory_quick" then
                inven = child
            end
        end
    end
    local wands = {}
    if inven ~= nil then
        local items = EntityGetAllChildren(inven)
        for _, child_item in ipairs(items) do
            if EntityHasTag(child_item, "wand") then
                wands[_] = child_item
            end
        end
    end

    return wands or nil
end

function GetWandSpells(id)
    local childs = EntityGetAllChildren(id)
    local inven = {}
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityHasTag(child, "card_action") then
                inven[_] = child
            end
        end
    end
    return inven or nil
end


function spawn_healer_pikku( username )
    local PIKKU_TYPES = {
        Healer=1,
        Tank=2,
        Warrior=3
    };
    local PIKKU_TITLES = {
        [PIKKU_TYPES.Healer]=" the Healer",
        [PIKKU_TYPES.Tank]=" the Tank",
        [PIKKU_TYPES.Warrior]=" the Fighter",
    }
    local x, y = get_player_pos();
    local pikku = EntityLoad( "data/entities/animals/firebug.xml", x, y );
    SetRandomSeed( GameGetFrameNum(), x + y + tonumber( pikku ) );
    local pikku_type = Random( 1, 3 );
    EntityAddComponent( pikku, "SpriteComponent", {
        _tags = "enabled_in_world",
        image_file = "data/fonts/font_pixel_white.xml",
        emissive = "1",
        is_text_sprite = "1",
        offset_x = "30",
        alpha = "0.67",
        offset_y = "-4",
        update_transform = "1",
        update_transform_rotation = "0",
        text = username..PIKKU_TITLES[pikku_type],
        has_special_scale = "1",
        special_scale_x = "0.5",
        special_scale_y = "0.5",
        z_index = "-9000"
    } );

    -- here is an unlimited charm effect
    local game_effect = GetGameEffectLoadTo( pikku, "CHARM", true );
    if game_effect ~= nil then
        ComponentSetValue( game_effect, "frames", -1 );
    end

    -- pikku typing
    if pikku_type == PIKKU_TYPES.Healer then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/healshot.xml" );
            ComponentSetValue( animal_ai, "aggressiveness_min", "0" );
            ComponentSetValue( animal_ai, "aggressiveness_max", "0" );
            ComponentSetValue( animal_ai, "tries_to_ranged_attack_friends", "1" );
            ComponentSetValue( animal_ai, "max_distance_to_move_from_home", "0" );
            ComponentSetValue( animal_ai, "dont_counter_attack_own_herd", "1" );

        end
    elseif pikku_type == PIKKU_TYPES.Warrior then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
            ComponentSetValue( animal_ai, "aggressiveness_min", "100" );
            ComponentSetValue( animal_ai, "aggressiveness_max", "100" );
            ComponentSetValue( animal_ai, "escape_if_damaged_probability", "0" );
            ComponentSetValue( animal_ai, "hide_from_prey", "0" );
            ComponentSetValue( animal_ai, "sense_creatures", "1" );
            ComponentSetValue( animal_ai, "attack_only_if_attacked", "0" );
            ComponentSetValue( animal_ai, "dont_counter_attack_own_herd", "1" );
            ComponentSetValue( animal_ai, "max_distance_to_move_from_home", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/deck/light_bullet.xml" );
        end
    elseif pikku_type == PIKKU_TYPES.Tank then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_enabled", "0" );
            ComponentSetValue( animal_ai, "aggressiveness_min", "0" );
            ComponentSetValue( animal_ai, "aggressiveness_max", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/healshot.xml" );
            ComponentSetValue( animal_ai, "max_distance_to_move_from_home", "0" );
            ComponentSetValue( animal_ai, "dont_counter_attack_own_herd", "1" );
        end

        local x, y = EntityGetTransform( pikku );
        local hitbox = EntityGetFirstComponent( pikku, "HitboxComponent" );
        local radius = 10;
        local shield = EntityLoad( "data/entities/misc/animal_energy_shield.xml", x, y );
        local inherit_transform = EntityGetFirstComponent( shield, "InheritTransformComponent" );
        if inherit_transform ~= nil then
            ComponentSetValue( inherit_transform, "parent_hotspot_tag", "shield_center" );
        end
        local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
        for _,emitter in pairs( emitters ) do
            ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
        end
        local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
        ComponentSetValue( energy_shield, "radius", tostring( radius ) );

        local hotspot = EntityAddComponent( pikku, "HotspotComponent",{
            _tags="shield_center"
        } );
        ComponentSetValueVector2( hotspot, "offset", 0, -4 );

        if shield ~= nil then EntityAddChild( pikku, shield ); end
    end

    -- movement speed bonus
    local character_platforming = EntityGetFirstComponent( pikku, "CharacterPlatformingComponent" );
    local speed_multiplier = 1.6;
    if character_platforming ~= nil then
        local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
        ComponentSetMetaCustom( character_platforming, "fly_velocity_x", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_smooth_y", "0" );
        ComponentSetValue( character_platforming, "fly_speed_mult", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( fly_velocity_x * speed_multiplier ) );
    end

    -- add iframes
    local damage_models = EntityGetComponent( pikku, "DamageModelComponent" ) or {};
    for _,damage_model in pairs( damage_models ) do
        ComponentSetValue( damage_model, "invincibility_frames", "60" );
    end

    -- set to player genome
    local genomes = EntityGetComponent( pikku, "GenomeDataComponent" ) or {};
    for _,genome_data in pairs( genomes ) do
        ComponentSetValue( genome_data, "herd_id", "player" );
    end

    -- add pikku tracker (requires ti_pikku_tracker mod to function)
    EntityAddComponent( pikku, "VariableStorageComponent", {
        _tags="twitch_username,enabled_in_world,enabled_in_hand,enabled_in_inventory",
        value_string=username
    } );
    EntityAddComponent( pikku, "VariableStorageComponent", {
        _tags="spawn_frame,enabled_in_world,enabled_in_hand,enabled_in_inventory",
        value_string=tostring( GameGetFrameNum() )
    } );
    EntityAddComponent( pikku, "LuaComponent", {
        script_damage_received="mods/ti_pikku_tracker/files/pikku_damage_received.lua"
    } );
end


-- 0 to not limit axis, -1 to limit to negative values, 1 to limit to positive values
function generate_value_in_range(max_range, min_range, limit_axis)
    local range = (max_range or 0) - (min_range or 0)
    if (limit_axis or 0) == 0 then limit_axis = Random(0, 1) == 0 and 1 or -1 end

    return (Random(0, range) + (min_range or 0)) * limit_axis
end

function spawn_something(entity_path, min_dist, max_dist, from_above, black_hole, callback)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local dx = generate_value_in_range(max_dist, min_dist, 0)
        local dummy = EntityLoad("data/entities/dummy_hax.xml", x + dx, y)
        wait(20)
        local dummy_x, dummy_y = EntityGetTransform(dummy)

        EntityKill(dummy)
        if from_above then

        end
        if black_hole then
            EntityLoad("data/entities/projectiles/deck/black_hole.xml", dummy_x,
                       dummy_y)
        end
        local eid = EntityLoad(entity_path, dummy_x, dummy_y)
        if callback then callback(eid); end
    end)
end

function spawn_item_in_range(path, min_x_range, max_x_range, min_y_range,
                             max_y_range, limit_x_axis, limit_y_axis,
                             spawn_blackhole)
    local x, y = get_player_pos()
    local dx = generate_value_in_range(max_x_range, min_x_range, limit_x_axis)
    local dy = generate_value_in_range(max_y_range, min_y_range, limit_y_axis)

    if spawn_blackhole then
        EntityLoad("data/entities/projectiles/deck/black_hole.xml", x + dx,
                   y + dy)
    end
    local ix, iy = FindFreePositionForBody(x + dx, y + dy, 300, 300, 30)
    return EntityLoad(path, ix, iy)
end

function spawn_item(path, min_range, max_range, spawn_blackhole)
    return spawn_item_in_range(path, min_range, max_range, min_range, max_range,
                               0, 0, spawn_blackhole)
end

function spawn_prop(entity_path, x, y)
    async(function()
        local px, py = get_player_pos()

        local dummy = EntityLoad("data/entities/dummy_hax.xml", px + x, py + y)
        wait(60)
        local dummy_x, dummy_y = EntityGetTransform(dummy)
        EntityKill(dummy)
        local from_above = Random(0, 1)
        if from_above > 0 then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 35, dummy_x,
                                          dummy_y - 180)
            if rhit then
                dummy_y = ry + 25
            else
                dummy_y = dummy_y - 160
            end
        end
        EntityLoad(entity_path, dummy_x, dummy_y)
    end)
end
