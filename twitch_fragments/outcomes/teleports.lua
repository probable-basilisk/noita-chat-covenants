register_outcome{
  text = "Teleport to enemy",
  bad = true,
  apply = function(self)
    local x, y = get_any_enemy_pos()
    EntitySetTransform(get_player(), x, y)
  end,
}

register_outcome{add_position_modifier{
  text = "Enemy teleports",
  bad = true,
  apply = function(self)
    local x, y = (self.position_target or get_player_pos)()
    local mx, my = get_mouse_pos()
    local enemy_ent = get_closest_entity(mx, my, "homing_target")
    if enemy_ent then
      EntitySetTransform(enemy_ent, x, y)
    end
  end,
}}

