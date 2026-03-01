local weidao = fk.CreateSkill {
  name = "pang_weidao",
  tags = {Skill.Switch},
}

weidao:addEffect(fk.EventPhaseStart, {
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(weidao.name) and player.phase == Player.Start and
    player:getSwitchSkillState(weidao.name, true) ~= fk.SwitchYang
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
      local duel = Fk:cloneCard("duel")
    local max_num = duel.skill:getMaxTargetNum(player, duel)
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(duel, p)
    end)
    if #targets > 0 then
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = max_num,
      targets = targets,
      skill_name = weidao.name,
      prompt = "#weidao1",
      cancelable = false,
    })
    if #tos > 0 then
        local targets = tos
        room:sortByAction(targets)
    room:useVirtualCard("duel", nil, player, targets, weidao.name, true)
    end
  end
  end,
})
weidao:addEffect(fk.EventPhaseStart, {
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(weidao.name) and target.phase == Player.Finish and player:getSwitchSkillState(weidao.name, true) == fk.SwitchYang
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
      local duel = Fk:cloneCard("duel")
    room:useVirtualCard("duel", nil, target, player, weidao.name, true)
  end,
})


Fk:loadTranslationTable {["pang_weidao"] = "卫道",
[":pang_weidao"] = "转换技，①准备阶段，你可以视为使用一张【决斗】②其他角色的结束阶段，你可以令其视为对你使用一张【决斗】。",

[":pang_weidao_yang"] = "转换技，<font color=\"#E0DB2F\">①准备阶段，你可以视为使用一张【决斗】</font>" ..
"②其他角色的结束阶段，你可以令其视为对你使用一张【决斗】。",
[":pang_weidao_yin"] = "转换技，①准备阶段，你可以视为使用一张【决斗】"..
"<font color=\"#E0DB2F\">②其他角色的结束阶段，你可以令其视为对你使用一张【决斗】</font>。",

["#weidao1"] = "你可以视为使用一张【决斗】",
["#weidao2"] = "你可以令一名角色视为对你使用一张【决斗】",

["$pang_weidao1"] = "哼哼！",
["$pang_weidao2"] = "哼哼——！",
}
return weidao  --不要忘记返回做好的技能对象哦