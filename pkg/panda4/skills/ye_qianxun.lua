local qianxun = fk.CreateSkill {
  name = "ye_qianxun",
  tags = {},
}

qianxun:addEffect("viewas", {
  anim_type = "control",
  pattern = "nullification",
  prompt = "#pang_qianxun",
  handly_pile = true,
  filter_pattern = function (self, player, card_name)
    local cards = player:getCardIds("h")
    return {
      max_num = #cards,
      min_num = #cards,
      pattern = ".|.|.|hand",
      subcards = cards
    }
  end,
  view_as = function(self, player, cards)
    if #cards < 1 then return end
    local card = Fk:cloneCard("nullification")
    card.skillName = qianxun.name
    card:addSubcards(cards)
    return card
  end,
  enabled_at_play = function(self, player)
    local judge = table.filter(player:getCardIds("he"), function(id)
        local card = Fk:getCardById(id)
        return card and (card.type == Card.TypeBasic or card.trueName == "slash")
    end)
    return player:usedSkillTimes(qianxun.name, Player.HistoryRound) == 0 and not player:isKongcheng() and #judge > 0
  end,
})


Fk:loadTranslationTable {["ye_qianxun"] = "谦逊",
[":ye_qianxun"] = "每轮限一次，若你手牌中包含【无懈可击】或装备牌，你可将所有手牌当【无懈可击】使用。",
["#pang_qianxun"] = "谦逊：每轮限一次，若你手牌中包含【无懈可击】或装备牌，你可将所有手牌当【无懈可击】使用。",


["$ye_qianxun1"] = "步步为营者，定无后顾之虞。",
["$ye_qianxun2"] = "明公彀中藏龙卧虎，放之海内皆可称贤。",
}
return qianxun