register_outcome{
  text = "Small health up",
  subtext = "Lucky you!",
  good = true,
  comment = "todo",
  rarity = 30,
  apply = function()
    twiddle_health(function(cur, max) return cur + 0.1, max + 0.1 end)
  end,
}

register_outcome{
  text = "Health Up",
  subtext = "Lucky you!",
  good = true,
  comment = "todo",
  rarity = 30,
  apply = function()
    twiddle_health(function(cur, max) return cur + 1, max + 1 end)
  end,
}