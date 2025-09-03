local limu = fk.CreateSkill {
  name = "pang_limu",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["pang_limu"] = "立牧",
  [":pang_limu"] = "限定技，每轮结束时，你可以将弃牌堆中的所有红色牌移出游戏并洗牌，然后你执行一个额外的回合。",

  ["$pang_limu1"] = "今诸州纷乱，当立牧以定！",
  ["$pang_limu2"] = "此非为偏安一隅，但求一方百姓安宁！",
}

limu:addEffect(fk.RoundEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(limu.name) and player:usedSkillTimes(limu.name, Player.HistoryGame) == 0
    end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = {}
    for _, id in ipairs(room.discard_pile) do
        if Fk:getCardById(id).color == Card.red then
            table.insert(cards, id)
        end
    end
    if #cards > 0 then
      room:moveCardTo(cards, Card.Void, nil, fk.ReasonJustMove, limu.name, nil, true, player)
      player:gainAnExtraTurn(true, limu.name)
    end
    room:shuffleDrawPile()
  end,
})

return limu