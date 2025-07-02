local chuijiao = fk.CreateSkill({
  name = "pang_chuijiao", ---技能内部名称，要求唯一性
  tags = {Skill.Limited}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

chuijiao:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#chuijiao",
  min_card_num = 1,
  min_target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(chuijiao.name, Player.HistoryGame) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return not to_select.dead
  end,
  feasible = function(self, player, selected, selected_cards)
    return #selected == #selected_cards and #selected > 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    room:throwCard(effect.cards, chuijiao.name, player, player)
    local targets = table.simpleClone(effect.tos)
    room:sortByAction(targets)
    for _, p in ipairs(targets) do
      if not p.dead then
        room:changeShield(p, 1, {cancelable = false})
        if not p:hasSkill("pang_beilve") then
            room:handleAddLoseSkills(p, "pang_beilve", nil, true, false)
        end
      end
  end
end
})

Fk:loadTranslationTable {["pang_chuijiao"] = "吹角",
[":pang_chuijiao"] = "限定技，出牌阶段，你可以弃置任意张牌，然后你令等量名角色各获得1点护甲并获得“备掠”。",
["#chuijiao"] = "弃置任意张牌并令等量角色获得护甲和“备掠”",
}
return chuijiao  --不要忘记返回做好的技能对象哦