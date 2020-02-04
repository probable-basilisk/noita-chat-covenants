local POSITIONS = {
  below_player = {below_player{}, "below player"},
  near_player = {player_vicinity{}, "near player"},
  at_player = {player_pos, "at player position"},
  above_player = {above_player{}, "above player"},
  at_mouse = {mouse_pos, "at mouse position"},
  near_mouse = {vicinity(mouse_pos, {min_rad = 0, max_rad = 50}), "near mouse"},
  at_enemy = {get_any_enemy_pos, "on top of enemy"},
  near_enemy = {vicinity(get_any_enemy_pos, {min_rad = 0, max_rad = 50}), "near enemy"},
  above_mouse = {from_above(mouse_pos), "above mouse position"},
  above_enemy = {from_above(get_any_enemy_pos), "above enemy"}
}

local DEFAULT_POSITIONS = {"near_player", "near_mouse", "near_enemy", "at_mouse", "above_player", "above_enemy"}

function add_position_modifier(options)
  local inner_mutate = options.mutate
  local base_text = options.text
  options.mutate = function(self)
    if inner_mutate then inner_mutate(self) end
    local newpos = POSITIONS[rand_choice(self.possible_positions or DEFAULT_POSITIONS)]
    if not newpos then return end
    local posfunc, posdesc = unpack(newpos)
    self.position_target = posfunc
    -- HACK: want to avoid the situation where we end up with things
    -- like "on enemy near player at mouse position" because it keeps
    -- on appending
    local text = (inner_mutate and self.text) or base_text
    self.text = (text or "?") .. " " .. posdesc
  end
  return options
end