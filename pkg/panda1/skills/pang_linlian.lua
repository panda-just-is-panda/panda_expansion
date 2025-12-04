local linlian = fk.CreateSkill {
  name = "pang_linlian",
  tags = { Skill.Compulsory },
}

linlian:addEffect("prohibit",{
  prohibit_discard = function(self, player, card)
    return player:hasSkill(linlian.name) and card.suit == Card.Diamond
  end,
})

linlian:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(linlian.name) then
      for _, move in ipairs(data) do
        if move.toArea == Card.DiscardPile then
            for _, info in ipairs(move.moveInfo) do
              if Fk:getCardById(info.cardId).suit == Card.Diamond then
                return true
              end
            end
        end
      end
    end
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, linlian.name)
    local card = room:askToDiscard(player, {
        skill_name = linlian.name,
        prompt = "#linlian_discard",
        cancelable = false,
        min_num = 1,
        max_num = 1,
        include_equip = true,
    })
    end,
})


Fk:loadTranslationTable{
  ["pang_linlian"] = "啬敛",
  [":pang_linlian"] = "锁定技，你不能弃置方块牌；当方块牌进入弃牌堆时，你摸一张牌并弃置一张牌。",
  ["#linlian_discard"] = "啬敛：弃置一张牌",

  ["$pang_linlian1"] = "哼啊～",
  ["$pang_linlian2"] = "哼啊——",
}

return linlian