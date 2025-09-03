local tongjue = fk.CreateSkill {
  name = "pang_tongjue",
  tags = { Skill.Compulsory, Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_tongjue"] = "通绝",
  [":pang_tongjue"] = "主公技，锁定技，不为群势力的角色计算和你的距离+X（X为场上群势力角色数）。",
}

tongjue:addEffect("distance", {
  correct_func = function(self, from, to)
    local X = 0
    for _, p in ipairs(room.alive_players) do
      if p.kingdom == "qun" then
        X = X + 1
      end
    end
    if from.kingdom ~= "qun" and to:hasSkill(tongjue.name) then
      return X
    end
  end,
})

return tongjue