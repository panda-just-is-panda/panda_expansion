local wajue = fk.CreateSkill({
  name = "pang_wajue", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

wajue:addEffect(fk.EventPhaseEnd, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wajue.name) and player.phase == Player.Finish 
    and #player:getCardIds("e") > 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local x = #player:getCardIds("e")
    local cards = room:getNCards(x, "bottom")
    room:turnOverCardsFromDrawPile(player, cards, wajue.name)
    local get = room:askToArrangeCards(player, {
      skill_name = wajue.name,
      card_map = {cards},
      prompt = "#wajue-choose",
      box_size = 0,
      max_limit = {1, 1},
      min_limit = {0, 1},
      default_choice = {{}, {cards[1]}}
    })[2]
    room:moveCardTo(get, Player.Hand, player, fk.ReasonJustMove, wajue.name, nil, true, player)
    room:cleanProcessingArea(cards)
  end,
})

wajue:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wajue.name) and data.card.type == Card.TypeEquip 
    and #player:getCardIds("e") > 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local x = #player:getCardIds("e")
    local cards = room:getNCards(x, "bottom")
    room:turnOverCardsFromDrawPile(player, cards, wajue.name)
    local get = room:askToArrangeCards(player, {
      skill_name = wajue.name,
      card_map = {cards},
      prompt = "#wajue-choose",
      box_size = 0,
      max_limit = {1, 1},
      min_limit = {0, 1},
      default_choice = {{}, {cards[1]}},
      cancelable = false,
    })[2]
    room:moveCardTo(get, Player.Hand, player, fk.ReasonJustMove, wajue.name, nil, true, player)
    room:cleanProcessingArea(cards)
  end,
})

Fk:loadTranslationTable {["pang_wajue"] = "挖掘",
[":pang_wajue"] = "锁定技，结束阶段或当你使用一张装备牌后，你亮出牌堆底的X张牌并获得其中一张（X为你装备区内的牌数）。",
["#wajue-choose"] = "获得其中一张牌",
}
return wajue  --不要忘记返回做好的技能对象哦