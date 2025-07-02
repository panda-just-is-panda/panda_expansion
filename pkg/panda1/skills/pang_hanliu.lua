local hanliu = fk.CreateSkill({
  name = "pang_hanliu", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

hanliu:addEffect("targetmod", {
bypass_distances = function(self, player, skill, card, to)
    return card and player:hasSkill(hanliu.name) and to and to:isWounded()
  end,
})

hanliu:addEffect("distance", {
  correct_func = function(self, from, to)
    if from:isWounded() and to:hasSkill(hanliu.name) then
      return 1
    end
  end,
})

Fk:loadTranslationTable{
  ["pang_binshi"] = "寒流",
  [":pang_binshi"] = "锁定技，你对已受伤的角色使用牌无距离限制，已受伤的角色计算和你的距离+1。",
}

return hanliu