local swj = fk.CreateSkill {
  name = "pang_siweijiang",
  tags = { },
}

Fk:loadTranslationTable{
  ["pang_siweijiang"] = "丝为缰",
  [":pang_siweijiang"] = "当点数为4的牌进入弃牌堆时，你获得之；每回合开始时，你可以将一张点数为4的牌置于牌堆顶；当其他角色使用点数为4的牌时，你可以获得其两张牌。",
  ["#swj"] = "丝为缰：你可以将一张点数为4的牌置于牌堆顶",
  ["#swj_2"] = "丝为缰：将一张点数为4的牌置于牌堆顶",
  ["#swj_tou"] = "丝为缰：你可以获得%src两张牌",
}

swj:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(swj.name) then
      local ids = {}
      for _, move in ipairs(data) do
        if move.toArea == Card.DiscardPile then
            for _, info in ipairs(move.moveInfo) do
              if Fk:getCardById(info.cardId).number == 4 then
                table.insertIfNeed(ids, info.cardId)
              end
            end
          end
        end
      ids = table.filter(ids, function (id)
        return table.contains(player.room.discard_pile, id)
      end)
      ids = player.room.logic:moveCardsHoldingAreaCheck(ids)
      if #ids > 0 then
        if player:hasSkill("pang_jianjiefu") then
          event:setCostData(self, {cards = ids})
          return true
        else
          player:chat(
          "你已触发邪恶胖的邪恶陷阱，此技能回收牌的效果不会在你没有“茧结缚”的时候被发动！{emoji56}{emoji56}{emoji56}")
        end
      end
      
    end
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local ids = table.simpleClone(event:getCostData(self).cards)
    room:moveCardTo(ids, Card.PlayerHand, player, fk.ReasonJustMove, swj.name, nil, true, player)
  end,
})

swj:addEffect(fk.TurnStart, {
  anim_type = "control",
  prompt = "#swj",
  can_trigger = function(self, event, target, player, data)
    local card = table.filter(player:getCardIds("he"), function(id)
        local card_pick = Fk:getCardById(id)
        if card_pick.number == 4 then
          return card_pick
        end
        end)
    if player:hasSkill(swj.name)
    and #card > 0 then
        return true
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local card = table.filter(player:getCardIds("he"), function(id)
        local card_pick = Fk:getCardById(id)
        if card_pick.number == 4 then
          return card_pick
        end
        end)
    local to_select = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      pattern = ".|4",
      skill_name = swj.name,
      prompt = "#swj_2",
      cancelable = false,
    })
        if #to_select > 0 then
        room:moveCards({
      ids = to_select,
      from = player,
      toArea = Card.DrawPile,
      moveReason = fk.ReasonPut,
      skillName = swj.name,
      proposer = player,
      moveVisible = true,
    })
        end
  end,
})

swj:addEffect(fk.CardUsing, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and not target:isNude() and player:hasSkill(swj.name) and data.card.number == 4
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = swj.name,
      prompt = "#swj_tou:"..target.id,
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:askToChooseCards(player, {
      target = target,
      min = 2,
      max = 2,
      flag = "he",
      skill_name = swj.name,
    })
    room:obtainCard(player, cards, false, fk.ReasonPrey, player, swj.name)
  end,
})


return swj