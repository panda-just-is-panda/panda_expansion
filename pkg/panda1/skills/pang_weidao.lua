local weidao = fk.CreateSkill {
  name = "pang_weidao",
  tags = {Skill.Switch},
}

weidao:addEffect(fk.EventPhaseStart, {
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(weidao.name) and player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player:getSwitchSkillState(weidao.name, true) == fk.SwitchYang then
      local duel = Fk:cloneCard("duel")
    local max_num = duel.skill:getMaxTargetNum(player, duel)
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(duel, p)
    end)
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = max_num,
      targets = targets,
      skill_name = weidao.name,
      prompt = "#weidao1",
      cancelable = true,
    })
    if #tos > 0 then
        local targets = tos
        room:sortByAction(targets)
    room:useVirtualCard("duel", nil, player, targets, weidao.name, true)
    end
    else
      local duel = Fk:cloneCard("duel")
      duel.skillName = weidao.name
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return not p:isProhibited(player, Fk:cloneCard("duel"))
    end)
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = weidao.name,
      prompt = "#weidao2",
      cancelable = true,
    })
    if #tos > 0 then
    room:useVirtualCard("duel", nil, player, tos, weidao.name, true)
    end
    end
  end,
})

Fk:loadTranslationTable {["pang_weidao"] = "卫道",
[":pang_weidao"] = "转换技，准备阶段，①你可以视为使用一张【决斗】②你可以令一名其他角色视为对你使用一张【决斗】。",
["#weidao1"] = "你可以视为使用一张【决斗】",
["#weidao2"] = "你可以令一名角色视为对你使用一张【决斗】"
}
return weidao  --不要忘记返回做好的技能对象哦