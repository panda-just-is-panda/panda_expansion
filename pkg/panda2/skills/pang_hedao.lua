local hedao = fk.CreateSkill {
  name = "pang_hedao",
  tags = {Skill.Compulsory},
}

hedao:addEffect(fk.CardUsing, {
  anim_type = "control",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(hedao.name) then
      local use_events = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from == player and use.card.type ~= Card.TypeBasic
      end, Player.HistoryTurn)
      return #use_events == 1 and use_events[1].data == data
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(2, hedao.name)
  end,
})

Fk:loadTranslationTable {["pang_hedao"] = "质速",
[":pang_hedao"] = "锁定技，你每回合首次使用非基本牌时摸两张牌。",
}

return hedao