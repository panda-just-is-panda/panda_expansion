local yiyu = fk.CreateSkill {
  name = "pang_yiyu",
}

Fk:loadTranslationTable{
  ["pang_yiyu"] = "溢欲",
  [":pang_yiyu"] = "一名角色的摸牌阶段，你可以令其多摸四张牌；若如此做，本回合的弃牌阶段结束时，你获得此阶段弃置的所有牌，然后你依次将其中一张牌作为【乐不思蜀】、【兵粮寸断】置入其判定区内。",

  ["#yiyu-invoke"] = "溢欲：你可以令%dest多摸四张牌",
  ["#yiyu-negative1"] = "溢欲：将一张牌作为乐不思蜀置入%dest判定区内",
  ["#yiyu-negative2"] = "溢欲：将一张牌作为兵粮寸断置入%dest判定区内",
  ["@@yiyu-inhand-phase"] = "溢欲",



}

yiyu:addEffect(fk.DrawNCards, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yiyu.name)
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = yiyu.name,
      prompt = "#yiyu-invoke::" .. target.id,
    }) then
    return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(target, "pang_yiyu-turn", 1)
    data.n = data.n + 4
  end,
})

yiyu:addEffect(fk.EventPhaseEnd, {
  anim_type = "support",
  can_refresh = function(self, event, target, player, data)
    if player:hasSkill(yiyu.name) and target.phase == Player.Discard and not target.dead and target:getMark("pang_yiyu-turn") > 0 then
      local room = player.room
      local guzheng_all, cards = {}, {}
      room.logic:getEventsByRule(GameEvent.MoveCards, 1, function (e)
        for _, move in ipairs(e.data) do
          for _, info in ipairs(move.moveInfo) do
            local id = info.cardId
            if not table.contains(cards, id) then
              table.insert(cards, id)
              if move.toArea == Card.DiscardPile and move.moveReason == fk.ReasonDiscard and
                room:getCardArea(id) == Card.DiscardPile then
                table.insert(guzheng_all, id)
                room:setCardMark(Fk:getCardById(id), "@@yiyu-inhand-phase", 1)
              end
            end
          end
        end
        return false
      end, nil, Player.HistoryPhase)
      if #guzheng_all > 0 then
        event:setCostData(self, {extra_data = {guzheng_all}})
        return true
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = room.current
    local guzheng_all = event:getCostData(self).extra_data[1]
    room:moveCardTo(guzheng_all, Card.PlayerHand, player, fk.ReasonJustMove, yiyu.name, nil, true, player, "@@yiyu-inhand-phase")
    local ids = {}
    for _, id in ipairs(player:getCardIds("h")) do
      if Fk:getCardById(id):getMark("@@yiyu-inhand-phase") > 0 then
        table.insert(ids, id)
      end
    end
    if #guzheng_all > 0 then
        if not to:hasDelayedTrick("indulgence") and not table.contains(to.sealedSlots, to.JudgeSlot) then
            local to_select = room:askToCards(player, {
            min_num = 1,
            max_num = 1,
            pattern = tostring(Exppattern{ id = ids }),
            prompt = "#yiyu-negative1::" .. to.id,
            skill_name = yiyu.name,
            cancelable = false,
            })
            local card1 = Fk:cloneCard("indulgence")
            card1:addSubcards(to_select)
            card1.skillName = yiyu.name
            room:moveCards{
            from = player,
            to = to,
            toArea = Player.Judge,
            ids = {to_select},
            moveReason = fk.ReasonJustMove,
            skillName = yiyu.name,
            virtualEquip = card1,
      }
        end
    end
    if #guzheng_all > 1 then
        if not to:hasDelayedTrick("supply_shortage") and not table.contains(to.sealedSlots, to.JudgeSlot) then
            local to_select2 = room:askToCards(player, {
            min_num = 1,
            max_num = 1,
            pattern = tostring(Exppattern{ id = ids }),
            prompt = "#yiyu-negative2::" .. to.id,
            skill_name = yiyu.name,
            cancelable = false,
            })
            local card2 = Fk:cloneCard("supply_shortage")
            card2:addSubcards(to_select2)
            card2.skillName = yiyu.name
            room:moveCards{
            from = player,
            to = to,
            toArea = Player.Judge,
            ids = {to_select2},
            moveReason = fk.ReasonJustMove,
            skillName = yiyu.name,
            virtualEquip = card2,
            }
        end
    end
  end,
})

return yiyu