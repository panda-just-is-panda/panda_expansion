local cuiyu = fk.CreateSkill {
  name = "pang_cuiyu",
  tags = {},
}

cuiyu:addEffect(fk.DrawNCards, {
  anim_type = "drawcard",
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "@@cuiyu")
    data.n = data.n + 4
  end,
})

cuiyu:addEffect(fk.AfterCardsMove, {
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(cuiyu.name, true) and player.room.current == player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    for _, move in ipairs(data) do
      if move.to == player and move.toArea == Player.Hand then
        for _, info in ipairs(move.moveInfo) do
          if table.contains(player:getCardIds("h"), info.cardId) then
            room:setCardMark(Fk:getCardById(info.cardId), "@@cuiyu-inhand-turn", 1)
          end
        end
      end
    end
  end,
})

cuiyu:addEffect(fk.CardUsing, {
    can_trigger = function(self, event, target, player, data)
    return player:hasSkill(cuiyu.name) and player:getMark("@@cuiyu") > 0 
    and data.card and data.card:getMark("@@cuiyu-inhand-turn") > 0
  end,
    on_cost = Util.TrueFunc,
    on_use = function(self, event, target, player, data)
        local room = player.room
        room:addPlayerMark(player, "cuiyu_ban-turn", 1)
        player:drawCards(2)
    end,
})

cuiyu:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    return player:getMark("cuiyu_ban-turn") > 0
  end,
})

cuiyu:addEffect(fk.TurnEnd, {
    mute = true,
  anim_type = "special",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(cuiyu.name)
  end,
  on_refresh = function(self, event, target, player, data)
    for _, p in ipairs(player.room.alive_players) do
      player.room:setPlayerMark(p, "@@cuiyu", 0)
    end
  end,
})

Fk:loadTranslationTable {["pang_cuiyu"] = "萃喻",
[":pang_cuiyu"] = "摸牌阶段，你可以多摸四张牌；若如此做，当你使用本回合获得的牌时，你不能再使用牌。",
["@@cuiyu"] = "萃喻",
["@@cuiyu-inhand-turn"] = "萃喻",
}

return cuiyu