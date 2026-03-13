local yuhuo = fk.CreateSkill({
  name = "pang_yuhuo", 
  tags = {}, 
})

Fk:loadTranslationTable{
  ["pang_yuhuo"] = "狱火",
  [":pang_yuhuo"] = "回合结束时，或你使用的伤害牌被抵消后，你可以从牌堆或弃牌堆中获得一张【火攻】。",

  ["#pang_yuhuo1"] = "狱火：你可以获得一张【火攻】",
  ["#pang_yuhuo2"] = "狱火：有人抵消了你的伤害牌，你很生气，你可以获得一张【火攻】",
}

yuhuo:addEffect(fk.TurnEnd, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yuhuo.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = yuhuo.name,
      prompt = "#pang_yuhuo1",
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:getCardsFromPileByRule("fire_attack")
    if #cards > 0 then
      local id = cards[1]
      room:obtainCard(player, id, true, fk.ReasonJustMove, player, yuhuo.name)
    else
      cards = room:getCardsFromPileByRule("fire_attack", 1, "discardPile")
      if #cards > 0 then
        local id = cards[1]
        room:obtainCard(player, id, true, fk.ReasonJustMove, player, yuhuo.name)
      end
    end
    if #cards == 0 then
        player:chat("唉，厂长太弱太弱，加强厂长")
    end
  end,
})

yuhuo:addEffect(fk.CardEffectCancelledOut, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return data.from and data.from == player and player:hasSkill(yuhuo.name)
    and data.card and data.card.is_damage_card
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = yuhuo.name,
      prompt = "#pang_yuhuo2",
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:getCardsFromPileByRule("fire_attack")
    if #cards > 0 then
      local id = cards[1]
      room:obtainCard(player, id, true, fk.ReasonJustMove, player, yuhuo.name)
    else
      cards = room:getCardsFromPileByRule("fire_attack", 1, "discardPile")
      if #cards > 0 then
        local id = cards[1]
        room:obtainCard(player, id, true, fk.ReasonJustMove, player, yuhuo.name)
      end
    end
    if #cards == 0 then
        player:chat("唉，厂长太弱太弱，加强厂长")
    end
  end,
})

return yuhuo