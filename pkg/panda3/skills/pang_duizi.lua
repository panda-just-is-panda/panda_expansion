local duizi = fk.CreateSkill{
  name = "pang_duizi",
}


duizi:addEffect("viewas", {
  anim_type = "control",
  pattern = "dismantlement",
  prompt = "#duizi",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected < 3 then
        if #selected == 0 then
            return Fk:getCardById(to_select).suit ~= Card.NoNumber
        elseif #selected == 1 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
      end
    end
  end,
  view_as = function(self, player, cards)
    if #cards < 2 or #cards > 2 then return end
    local card = Fk:cloneCard("dismantlement")
    card.skillName = duizi.name
    card:addSubcards(cards)
    return card
  end,
  enabled_at_response = function (self, player, response)
    return not response and #player:getCardIds("he") > 1
  end,
})

Fk:loadTranslationTable {["pang_duizi"] = "对子",
[":pang_duizi"] = "你可以将两张点数相同的牌作为【过河拆桥】使用。",
["#duizi"] = "你可以将两张点数相同的牌作为【过河拆桥】使用",

["$pang_duizi1"] = "顺风的小曲～",
}

return duizi