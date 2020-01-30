register_outcome{
  text = "Explosives",
  subtext = "Might cause explosions",
  bad = true,
  comment = "todo",
  rarity = 37,
  apply = function()
    local barrel_entities = {
      "data/entities/props/physics_propane_tank.xml",
      "data/entities/props/physics_pressure_tank.xml",
      "data/entities/props/physics_box_explosive.xml",
      "data/entities/props/physics_barrel_oil.xml",
      "data/entities/props/physics_barrel_radioactive.xml"
    }
    async(function()
      for i = 1, 20 do
        spawn{rand_choice(barrel_entities), min_rad=50, max_rad=500}
        wait(15)
      end
    end)
  end,
}