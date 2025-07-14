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
[":pang_paixing"] = "你可以将两/三/四张点数相同的牌作为【过河拆桥】/【无中生有】/【无懈可击】使用。",
}

return paixing