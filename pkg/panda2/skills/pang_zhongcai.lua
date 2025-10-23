local zhongcai = fk.CreateSkill {
  name = "pang_zhongcai",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["pang_zhongcai"] = "忠裁",
  [":pang_zhongcai"] = "锁定技，游戏开始时，你获得一张【杀】；每回合结束时，你获得此【杀】；你除此【杀】之外的【杀】视为【铁索连环】。",

  ["@@pang_zhongcai"] = "忠裁",

}

zhongcai:addEffect(fk.GameStart, {
  anim_type = "drawcard",
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(zhongcai.name)
  end,
   on_cost = function (self, event, target, player, data)
    return true
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local cards = room:getCardsFromPileByRule("slash", 1)
    if #cards > 0 then
      local id = cards[1]
      room:setPlayerMark(player, "zhongcai_slash", id)
      room:setCardMark(Fk:getCardById(id), "@@pang_zhongcai", 1)
      local card = Fk:getCardById(id)
      room:moveCardTo(card, Card.PlayerHand, player, fk.ReasonPrey, zhongcai.name,nil, true, player)
    end
  end,
})

zhongcai:addEffect(fk.TurnEnd, {
    mute = true,
    can_trigger = function(self, event, target, player, data)
        return player:hasSkill(zhongcai.name) and not table.contains(player:getCardIds('h'),player:getMark("zhongcai_slash"))
    end,
    on_cost = function (self, event, target, player, data)
    return true
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local id = player:getMark("zhongcai_slash")
        room:moveCardTo(id, Card.PlayerHand, player, fk.ReasonPrey, zhongcai.name,nil, true, player)
    end,
})

zhongcai:addEffect("filter", {
  mute = true,
  card_filter = function(self, to_select, player)
    return player:hasSkill(zhongcai.name) and to_select.trueName == "slash" and
      to_select:getMark("@@pang_zhongcai") == 0
  end,
  view_as = function(self, player, to_select)
    local card = Fk:cloneCard("iron_chain", to_select.suit, to_select.number)
    card.skillName = zhongcai.name
    return card
  end,
})


return zhongcai