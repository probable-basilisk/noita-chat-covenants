register_outcome{
  text = "Random Spell",
  subtext = "A small favour",
  good = true,
  comment = "todo",
  rarity = 15,
  apply = function()
    local x, y = get_player_pos()
    SetRandomSeed( GameGetFrameNum(), x + y )
    
    local chosen_action = GetRandomAction( x, y, Random( 0, 6 ), Random( 1, 9999999 ) )
    local action = CreateItemActionEntity( chosen_action, x, y )
    EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true )
    EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false )
  end,
}