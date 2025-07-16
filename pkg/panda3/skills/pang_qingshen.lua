local qingshen = fk.CreateSkill{
  name = "pang_qingshen",
  tags = {Skill.Permanent},
}

qingshen:addEffect(fk.GameStart, {
can_refresh = function(self, event, target, player, data)
    return player:hasSkill(qingshen.name)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "guan_lieqiong", nil, true, false)
    room:handleAddLoseSkills(player, "guan_fushi", nil, true, false)
    room:handleAddLoseSkills(player, "mobile__hanzhan", nil, true, false)
  end,
})

Fk:loadTranslationTable{
  ["pang_qingshen"] = "请神",
  [":pang_qingshen"] = "持恒技，游戏开始时，你获得有持恒技标签的“酣战”，“缚豕”和“裂穹”。",
}


return qingshen