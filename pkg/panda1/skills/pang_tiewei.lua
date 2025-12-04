local tiewei = fk.CreateSkill {
  name = "pang_tiewei",
  tags = {  },
}

tiewei:addEffect(fk.CardUseFinished, {
    anim_type = "defensive",
    can_trigger = function(self, event, target, player, data)
        return target ~= player and player:hasSkill(tiewei.name) 
        and (data.card.trueName == "slash" or data.card.name == "duel")
    end,
    on_cost = function(self, event, target, player, data)
    local use = player.room:askToUseCard(player, {
      skill_name = tiewei.name,
      pattern = "slash",
      prompt = "#tiewei-invoke::"..target.id,
      cancelable = true,
      extra_data = {
        bypass_times = true,
        bypass_distances = true,
        extraUse = true,
        must_targets = {
          target.id,
        }},
      })
    if use then
      event:setCostData(self, {extra_data = use})
      return true
    end
  end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        room:useCard(event:getCostData(self).extra_data)
        room:addPlayerMark(player, "@@tiewei-turn", 1)
    end,
})

tiewei:addEffect("filter", {
    mute = true,
    card_filter = function(self, to_select, player)
        return player:hasSkill(tiewei.name) and player:getMark("@@tiewei-turn") > 0 and
        table.contains(player:getCardIds("h"), to_select.id)
    end,
    view_as = function(self, player, to_select)
        local card = Fk:cloneCard("slash", to_select.suit, to_select.number)
        card.skillName = tiewei.name
        return card
    end,
})


Fk:loadTranslationTable{
  ["pang_tiewei"] = "铁卫",
  [":pang_tiewei"] = "当其他角色使用【杀】或【决斗】结算结束后，你可以对其使用一张【杀】，然后本回合你的所有手牌均视为【杀】。",
  ["@@tiewei-turn"] = "铁卫",
  ["#tiewei-invoke"] = "铁卫：你可以对%dest使用一张【杀】",

  ["$pang_tiewei1"] = "钢铁噪音",
  ["$pang_tiewei2"] = "钢铁轰鸣声"
}

return tiewei