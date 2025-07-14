local paixing = fk.CreateSkill{
  name = "pang_paixing",
  tags = {},
}

paixing:addEffect(fk.TurnStart, {
can_refresh = function(self, event, target, player, data)
    return player:hasSkill(paixing.name) and player:usedSkillTimes(paixing.name, Player.HistoryGame) == 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "pang_duizi", nil, true, false)
    room:handleAddLoseSkills(player, "pang_feiji", nil, true, false)
    room:handleAddLoseSkills(player, "pang_zhadan", nil, true, false)
  end,
})



Fk:loadTranslationTable {["pang_paixing"] = "牌型",
[":pang_paixing"] = "游戏开始时，你获得“对子”、“三带”和“炸弹”。",
}

return paixing