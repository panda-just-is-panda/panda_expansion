local aiganglie = fk.CreateSkill{
  name = "pang_aiganglie",
}

aiganglie:addEffect(fk.DamageInflicted, {
  anim_type = "negative",
  can_refresh = function (self, event, target, player, data)
    return player:hasSkill(aiganglie.name) and player == target and player:usedSkillTimes(aiganglie.name, Player.HistoryTurn) == 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local cards = room:getCardsFromPileByRule(".|.|heart")
    if #cards > 0 then
      local id = cards[1]
      table.removeOne(room.draw_pile, id)
      table.insert(room.draw_pile, 1, id)
      room:syncDrawPile()
    end
  end,
})

Fk:loadTranslationTable{
  ["pang_aiganglie"] = "唉刚烈",
  [":pang_aiganglie"] = "持恒技，锁定技，你每回合首次受到伤害时，你将牌堆中的一张红桃牌置于牌堆顶。",
}

return aiganglie