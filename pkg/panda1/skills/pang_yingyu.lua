local yingyu = fk.CreateSkill({
  name = "pang_yingyu", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

yingyu:addEffect(fk.RoundStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yingyu.name) and #player.room:getOtherPlayers(player, false) > 0
    and player.shield > 0
  end,
   on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = yingyu.name,
      cancelable = true,
    }) then
      local cards = player:getCardIds("h")
       if #cards > 0 then
        room:throwCard(cards, yingyu.name, player, player)
        player:broadcastSkillInvoke(yingyu.name, 1)
        return true
       else
        player:broadcastSkillInvoke(yingyu.name, 1)
      return true
       end
    end
end,
  on_use = function(self, event, target, player, data)
    local room = player.room
        local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room.alive_players,
      skill_name = yingyu.name,
      prompt = "#yingyu_choose",
      cancelable = false,
    })
    if #tos > 0 then
    local targets = table.filter(tos, function (p)
      return not p.dead
    end)
    for _, p2 in ipairs(targets) do
    p2:gainAnExtraTurn(true, yingyu.name)
    end
    end
  end
})

yingyu:addEffect(fk.RoundStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yingyu.name) and #player.room:getOtherPlayers(player, false) > 0
    and player.shield < 1
  end,
   on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = yingyu.name,
      cancelable = true,
    }) then
      local cards = player:getCardIds("h")
       if #cards > 0 then
        event:setCostData(self, {card_discard = #cards})
        room:throwCard(cards, yingyu.name, player, player)
                player:broadcastSkillInvoke(yingyu.name, 2)
        return true
       else
                player:broadcastSkillInvoke(yingyu.name, 2)
      return true
       end
    end
end,
  on_use = function(self, event, target, player, data)
    local room = player.room
        local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room.alive_players,
      skill_name = yingyu.name,
      prompt = "#yingyu_choose2",
      cancelable = false,
    })
    if #tos > 0 then
    local target2 = table.filter(tos, function (p)
      return not p.dead
    end)
    for _, p2 in ipairs(target2) do
    if p2 == player then
      local draw_card = event:getCostData(self).card_discard
      player:drawCards(draw_card, yingyu.name)
    end
    p2:gainAnExtraTurn(true, yingyu.name)
    end
    end
  end
})

Fk:loadTranslationTable {["pang_yingyu"] = "影驭",
[":pang_yingyu"] = "每轮开始时，你可以弃置所有手牌（无牌则不弃）并令一名角色执行一个额外的回合，然后若你没有护甲且选择的角色为自己，你摸等量张牌。",
["#yingyu_choose"] = "弃置所有手牌并令一名角色执行一个额外的回合",
}
return yingyu  --不要忘记返回做好的技能对象哦