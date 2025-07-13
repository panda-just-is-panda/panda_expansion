local feiji = fk.CreateSkill{
  name = "pang_feiji",
}


feiji:addEffect("viewas", {
  anim_type = "control",
  pattern = "ex_nihilo",
  prompt = "#feiji",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected < 3 then
        if #selected == 0 then
            return Fk:getCardById(to_select).suit ~= Card.NoNumber
        elseif #selected == 1 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
        elseif #selected == 2 then
            return Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[1]))
            and Fk:getCardById(to_select):compareNumberWith(Fk:getCardById(selected[2]))
      end
    end
  end,
  view_as = function(self, player, cards)
    if #cards < 3 or #cards > 3 then return end
    local card = Fk:cloneCard("ex_nihilo")
    card.skillName = feiji.name
    card:addSubcard(cards)
    return card
  end,
  enabled_at_response = function (self, player, response)
    return not response and #player:getCardIds("he") > 2
  end,
})

Fk:loadTranslationTable {["pang_feiji"] = "三不带",
[":pang_feiji"] = "你可以将三张点数相同的牌作为【无中生有】使用。",
["#feiji"] = "你可以将三张点数相同的牌作为【无中生有】使用"
}

return feiji