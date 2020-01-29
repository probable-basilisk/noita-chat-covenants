register_outcome{
  text = "Enemy Shields",
  subtext = "Can you break them?",
  bad = true,
  comment = "todo",
  rarity = 10,
  apply = function()
    local x, y = get_player_pos()
    for _, entity in pairs( EntityGetInRadiusWithTag( x, y, 1024, "enemy" ) or {} ) do
      local x, y = EntityGetTransform( entity )
      local hitbox = EntityGetFirstComponent( entity, "HitboxComponent" )
      local height, width = nil, 18, 18
      if hitbox then
        height = tonumber( ComponentGetValue( hitbox, "aabb_max_y" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_y" ) )
        width = tonumber( ComponentGetValue( hitbox, "aabb_max_x" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_x" ) )
      end
      local radius = math.max( height, width ) + 6
      local shield = EntityLoad( "data/entities/misc/animal_energy_shield.xml", x, y )
      local inherit_transform = EntityGetFirstComponent( shield, "InheritTransformComponent" )
      if inherit_transform then
        ComponentSetValue( inherit_transform, "parent_hotspot_tag", "shield_center" )
      end
      local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) 
      for _, emitter in pairs(emitters or {}) do
        ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius )
      end
      local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" )
      ComponentSetValue( energy_shield, "radius", tostring( radius ) )
      local hotspot = EntityAddComponent( entity, "HotspotComponent", {
        _tags="shield_center"
      })
      ComponentSetValueVector2( hotspot, "offset", 0, -height * 0.3 )      
      if shield then EntityAddChild( entity, shield ) end
    end
  end,
}