local zhisu = fk.CreateSkill {
  name = "pang_zhisu",
  tags = {Skill.Compulsory},
}

zhisu:addEffect(fk.CardUsing, {
  anim_type = "control",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(zhisu.name) then
      local use_events = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from == player and use.card.type == Card.TypeBasic
      end, Player.HistoryTurn)
      return #use_events == 1 and use_events[1].data == data
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data.additionalEffect = (data.additionalEffect or 0) + 1
  end,
})

Fk:loadTranslationTable {["pang_zhisu"] = "质速",
[":pang_zhisu"] = "锁定技，你每回合首次使用的基本牌额外结算一次。",
}

return zhisu