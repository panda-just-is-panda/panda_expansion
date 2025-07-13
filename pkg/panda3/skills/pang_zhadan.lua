local zhadan = fk.CreateSkill{
  name = "pang_zhadan",
}


zhadan:addEffect("viewas", {
  anim_type = "control",
  pattern = "nullification",
  prompt = "#zhadan",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected < 4 then
        if #selected == 0 then
            return Fk:getCardById(to_select).suit ~= Card.NoNumber
        elseif #selected == 1 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
        elseif #selected == 2 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
            and Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[2]))
        elseif #selected == 3 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
            and Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[2]))
            and Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[3]))
      end
    end
  end,
  view_as = function(self, player, cards)
    if #cards < 4 or #cards > 4 then return end
    local card = Fk:cloneCard("nullification")
    card.skillName = zhadan.name
    card:addSubcards(cards)
    return card
  end,
  enabled_at_response = function (self, player, response)
    return not response and #player:getCardIds("he") > 3
  end,
})

Fk:loadTranslationTable {["pang_zhadan"] = "炸弹",
[":pang_zhadan"] = "你可以将四张点数相同的牌作为【无懈可击】使用。",
["#zhadan"] = "你可以将四张点数相同的牌作为【无懈可击】使用"
}

return zhadan

