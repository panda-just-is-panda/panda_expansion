local huifu = fk.CreateSkill({
  name = "pang_huifu", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})
huifu:addEffect(fk.TurnEnd, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huifu.name)
    and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player or e.data.to == player end, Player.HistoryTurn) > 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end) > 0 then
    local cards = player.room:getCardsFromPileByRule("slash", 1, "discardPile")
    if #cards > 0 then
      player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, huifu.name)
      if player.dead then return false end
    end
    end
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0 then
         local slash = Fk:cloneCard("slash")
    local max_num = slash.skill:getMaxTargetNum(player, slash)
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(slash, p, {bypass_times = true})
    end)
    if #targets > 0 then
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = max_num,
      targets = targets,
      skill_name = huifu.name,
      prompt = "#huifu_choose",
      cancelable = true,
    })
    if #tos > 0 then
        local targets = tos
        room:sortByAction(targets)
    room:useVirtualCard("slash", nil, player, targets, huifu.name, true)
    end
    end
      end
end
})

Fk:loadTranslationTable {["pang_huifu"] = "挥斧",
[":pang_huifu"] = "每回合结束时，若你本回合：造成过伤害，你获得弃牌堆中的一张【杀】；受到过伤害，你可以视为使用一张【杀】。",
["#huifu_choose"] = "视为使用一张【杀】",

["$pang_huifu1"] = "哼哼～",
["$pang_huifu2"] = "哼哼！",
}
return huifu  --不要忘记返回做好的技能对象哦