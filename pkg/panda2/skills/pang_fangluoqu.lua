local flq = fk.CreateSkill {
  name = "pang_fangluoqu",
  tags = { Skill.Lord, Skill.Wake },
}

Fk:loadTranslationTable{
  ["pang_fangluoqu"] = "纺络曲",
  [":pang_fangluoqu"] = "主公技，觉醒技，准备阶段，若所有忠臣和内奸均已死亡，“茧结缚”失效直到你于一回合内使用两张牌名相同的牌。",
}

flq:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    local melody = table.filter(player.room:getOtherPlayers(player, false), function (p)
      return p.role ~= "rebel"
    end)
    return target == player and player:hasSkill(flq.name) and
      player.phase == Player.Start and
      #melody == 0 and
      player:usedSkillTimes(flq.name, Player.HistoryGame) == 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player, "flq_awake", 1)
  end,
})

flq:addEffect("invalidity", {
  invalidity_func = function(self, from, skill)
    return
      from:getMark("flq_awake") > 0 and skill:isPlayerSkill(from, flq.name, true)
  end
})

flq:addEffect(fk.CardUsing, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(flq.name) and
      #player.room.logic:getEventsOfScope(GameEvent.UseCard, 2, function(e)
        local use = e.data
        return use.card.trueName == data.card.trueName and table.contains(use.from, player)
      end, Player.HistoryTurn) > 1
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "flq_awake", 0)
  end,
})

return flq