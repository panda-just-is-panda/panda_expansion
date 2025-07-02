local haibi = fk.CreateSkill({
  name = "pang_haibi", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

haibi:addEffect("maxcards", {
  correct_func = function(self, player)
    if player:hasSkill(haibi.name) and player:isWounded() then
      return 2
    end
  end,
})

haibi:addEffect("distance", {
  correct_func = function(self, from, to)
    if to:isWounded() and to:hasSkill(haibi.name) then
      return 1
    end
  end,
})


Fk:loadTranslationTable {["pang_haibi"] = "骸避",
[":pang_haibi"] = "锁定技，若你已受伤，你的手牌上限+2，其他角色计算和你的距离+1。",

}

return haibi