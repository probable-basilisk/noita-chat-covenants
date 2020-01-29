if not perk_list then 
  print("DOING PERKS????")
  dofile("data/scripts/lib/utilities.lua")
  dofile("data/scripts/perks/perk_list.lua")
  dofile("data/scripts/perks/perk.lua")
  print("PERK????", tostring(perk_list))
end

register_outcome{
  text = "Random Perk",
  subtext = "Lucky... or maybe not?",
  unknown = true,
  comment = "todo",
  rarity = 10,
  cooldown = 60*60*5,
  apply = function()
    local perk = rand_choice(perk_list)
    -- reroll useless perk
    while perk.id == "MYSTERY_EGGPLANT" do
      perk = rand_choice(math.random(1, #perk_list))
    end
    local x, y = get_player_pos()
    local perk_entity = perk_spawn(x, y - 8, perk.id)
    perk_pickup(perk_entity, get_player(), nil, true, false)
  end,
}