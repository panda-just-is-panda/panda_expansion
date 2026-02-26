local zaita = fk.CreateSkill({
  name = "pang_zaita", 
  tags = {},
})


zaita:addEffect(fk.TurnEnd, { --
  anim_type = "offensive", 
  mute = true,
  can_trigger = function(self, event, target, player, data)
    local damage_card = {}
    player.room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
      for _, move in ipairs(e.data) do
        if move.toArea == Card.DiscardPile then
          for _, info in ipairs(move.moveInfo) do
            if table.contains(player.room.discard_pile, info.cardId) and
              Fk:getCardById(info.cardId).is_damage_card then
              table.insertIfNeed(damage_card, info.cardId)
            end
          end
        end
      end
    end, Player.HistoryTurn)
    if not player:hasSkill(zaita.name) then return false end
    return #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0
    and player:getMark("zaita_datato-round") == 0
    or #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0
    and player:getMark("zaita_datafrom-round") == 0 and #damage_card > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if #room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0
    and player:getMark("zaita_datato-round") == 0 then
        if room:askToSkillInvoke(player, {
            skill_name = zaita.name,
            prompt = "pang_zaita-invoke1",
        }) then
            room:setPlayerMark(player, "zaita_invoke1", 1)
            return true
        end
    end
    if #room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0
    and player:getMark("zaita_datafrom-round") == 0 then
        if room:askToSkillInvoke(player, {
            skill_name = zaita.name,
            prompt = "pang_zaita-invoke2",
        }) then
            room:setPlayerMark(player, "zaita_invoke2", 1)
            return true
        end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player:getMark("zaita_invoke1") > 0 then
        room:throwCard(player:getCardIds("he"), zaita.name, player, player)
        player:drawCards(4, zaita.name)
        room:setPlayerMark(player, "zaita_datato-round", 1)
        player:broadcastSkillInvoke(zaita.name, 1)
    end
    local damage_card = {}
    room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
    for _, move in ipairs(e.data) do
        if move.toArea == Card.DiscardPile then
            for _, info in ipairs(move.moveInfo) do
                if table.contains(room.discard_pile, info.cardId) and
                Fk:getCardById(info.cardId).is_damage_card then
                    table.insertIfNeed(damage_card, info.cardId)
                end
            end
        end
    end
    end, Player.HistoryTurn)
    if #room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0
    and player:getMark("zaita_invoke2") == 0 and player:getMark("zaita_datafrom-round") == 0
    and #damage_card > 0 then
        if room:askToSkillInvoke(player, {
            skill_name = zaita.name,
            prompt = "pang_zaita-invoke2",
        }) then
            room:setPlayerMark(player, "zaita_invoke2", 1)
            return true
        end
    end
    if player:getMark("zaita_invoke2") > 0 then
        local use = room:askToUseRealCard(player, {
            skill_name = zaita.name,
            pattern = tostring(Exppattern{ id = damage_card }),
            expand_pile = damage_card,
            prompt = "#pang__zaita_use",
            extra_data = {
              bypass_times = true
            }
          })
        room:setPlayerMark(player, "zaita_datafrom-round", 1)
    end
    room:setPlayerMark(player, "zaita_invoke1", 0)
    room:setPlayerMark(player, "zaita_invoke2", 0)
end,
})

Fk:loadTranslationTable {["pang_zaita"] = "再踏",
[":pang_zaita"] = "每轮各限一次，你受到过伤害的回合结束时，你可以弃置所有牌(无牌则不弃)并摸四张牌；你造成过伤害的回合结束时，你可以使用本回合进入弃牌堆的一张伤害牌。",
["pang_zaita-invoke1"] = "再踏：你可以弃置所有牌并摸四张牌",
["pang_zaita-invoke2"] = "再踏：你可以使用本回合进入弃牌堆的一张伤害牌",
["#pang__zaita_use"] = "再踏：使用一张伤害牌",

["$pang_zaita1"] = "激昂的小曲～",
["$pang_zaita2"] = "遭遇战的小曲～",
}
return zaita