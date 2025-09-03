local limu = fk.CreateSkill {
  name = "pang_limu",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["pang_limu"] = "立牧",
  [":pang_limu"] = "限定技，回合结束时，你可以获得所有本回合进入弃牌堆的牌，然后你执行一个额外的回合。",

  ["$pang_limu1"] = "今诸州纷乱，当立牧以定！",
  ["$pang_limu2"] = "此非为偏安一隅，但求一方百姓安宁！",
}

limu:addEffect(fk.TurnEnd, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(limu.name) and player:usedSkillTimes(limu.name, Player.HistoryGame) == 0
    end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = {}
    room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
      for _, move in ipairs(e.data) do
        if move.toArea == Card.DiscardPile then
          for _, info in ipairs(move.moveInfo) do
            if table.contains(room.discard_pile, info.cardId) then
              table.insertIfNeed(cards, info.cardId)
            end
          end
        end
      end
    end, Player.HistoryTurn)
    if #cards > 0 then
      room:obtainCard(player, cards, true, fk.ReasonJustMove, player)
    end
    player:gainAnExtraTurn(true, limu.name)
  end,
})

return limu