local gongwu = fk.CreateSkill({
  name = "pang_gongwu", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

gongwu:addEffect(fk.EventPhaseStart, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gongwu) and
      player.phase == Player.Start
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return p ~= data.from
    end)
    local to = room:askToChoosePlayers(player, {
      skill_name = gongwu.name,
      min_num = 1,
      max_num = 1,
      targets = targets,
      prompt = "#gongwu-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    player:drawCards(1, gongwu.name)
    to:drawCards(1, gongwu.name)
    room:addPlayerMark(player, "gongwu-turn", 1)
    room:addPlayerMark(to, "gongwu-turn", 1)
  end,
})
gongwu:addEffect("filter", {
  mute = true,
  card_filter = function(self, to_select, player)
    return to_select.color == card.Red and
    player:getMark("tianyi_win-turn") > 0 and scope == Player.HistoryTurn and
    table.contains(player:getCardIds("h"), to_select.id)
  end,
  view_as = function(self, player, card)
    return Fk:cloneCard("slash", card.suit, card.number)
  end,
})

Fk:loadTranslationTable {["pang_gongwu"] = "共舞",
[":pang_gongwu"] = "准备阶段，你可以和一名其他角色各摸一张牌，然后直到本回合结束，你和其的所有红色手牌均视为【火杀】。",
["#gongwu"] = "选择一名角色和你一起起舞！",
}
return kuangluan  --不要忘记返回做好的技能对象哦