register_outcome{
  text = "Full Health",
  subtext = "Chat giveth",
  good = true,
  comment = "todo",
  rarity = 20,
  apply = function()
    twiddle_health(function(cur_hp, max_hp)
      return max_hp, max_hp
    end)
  end,
}

register_outcome{
  text = "Small Heal",
  subtext = "Chat giveth",
  good = true,
  comment = "todo",
  rarity = 20,
  apply = function()
    twiddle_health(function(cur_hp, max_hp)
      return math.min(max_hp, cur_hp+1), max_hp
    end)
  end,
}


register_outcome{
  text = "Max HP = HP",
  good = false,
  apply = function()
    twiddle_health(function(cur_hp, max_hp)
      return cur_hp, cur_hp
    end)
  end
}