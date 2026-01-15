local chengyu = fk.CreateSkill({
  name = "bi_chengyu", 
  tags = {}, 
})

chengyu:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#chengyu-active",
  max_phase_use_time = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(chengyu.name, Player.HistoryPhase) < 1 and not player:isKongcheng()
  end,
  target_num = 0,
  min_card_num = 2,
  card_filter = function(self, player, to_select, selected)
    if #selected < 2 then return false end
    return table.contains(player:getCardIds("h"), to_select)
  end,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local cards = effect.cards
    room:recastCard(cards, player, chengyu.name)
    local suits, types = {}, {}
    local cards2 = {}
    room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
      for _, move in ipairs(e.data) do
        if move.toArea == Card.DiscardPile then
          for _, info in ipairs(move.moveInfo) do
            if table.contains(room.discard_pile, info.cardId) then
              table.insertIfNeed(cards2, info.cardId)
            end
          end
        end
      end
    end, Player.HistoryTurn)
    for _, id in ipairs(cards2) do
        table.insertIfNeed(suits, Fk:getCardById(id).suit)
        table.insertIfNeed(types, Fk:getCardById(id).type)
    end
    table.removeOne(suits, Card.NoSuit)
    if #suits == 4 or #types == 3 then
        room:addPlayerMark(player, "@@chengyu")
    end
end,
})

chengyu:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@@chengyu") > 0 
  end,
  on_refresh = function(self, event, target, player, data)
    if not data.extraUse then
      data.extraUse = true
      player:addCardUseHistory(data.card.trueName, -1)
    end
    data.disresponsiveList = table.simpleClone(player.room.players)
    player.room:setPlayerMark(player, "@@chengyu", 0)
  end,
})

chengyu:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and player:getMark("@@chengyu") > 0
  end,
})


Fk:loadTranslationTable {["bi_chengyu"] = "成玉",
[":bi_chengyu"] = "出牌阶段限一次，你可以重铸至少两张手牌，若本回合有三种类别或四种花色的牌进入弃牌堆，本阶段你使用下一张牌无次数限制且不可响应。",
["#chengyu-active"] = "成玉：你可以重铸至少两张手牌，若包含三种类别或四种花色则本阶段你使用下一张牌无次数限制且不可响应",
["@@chengyu"] = "成玉",

}
return chengyu