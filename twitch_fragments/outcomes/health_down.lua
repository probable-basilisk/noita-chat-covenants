register_outcome{
  text = "Health Down",
  subtext = "Unlucky :(",
  bad = true,
  comment = "todo",
  rarity = 30,
  apply = function()
    twiddle_health(function(cur, max)
      max = max * 0.8
      cur = math.min(max, cur)
      return cur, max
    end)
  end,
}