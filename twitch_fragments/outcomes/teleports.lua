register_outcome{
  text = "Teleport to enemy",
  bad = true,
  apply = function()
    local x, y = get_any_enemy_pos()
    EntitySetTransform(get_player(), x, y)
  end,
}

register_outcome{
  text = "Enemy teleports to you",
  bad = true,
  apply = function()
    local x, y = get_player_pos()
    local mx, my = get_mouse_pos()
    local enemy_ent = get_closest_entity(mx, my, "homing_target")
    if enemy_ent then
      EntitySetTransform(enemy_ent, x, y)
    end
  end,
}

