local jigao = fk.CreateSkill({
  name = "pang_jigao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

jigao:addEffect(fk.Damage, {
  prompt = "#pang_jigao1",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jigao.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"losehp", "Cancel"}
    if not data.to:hasDelayedTrick("supply_shortage") and not table.contains(data.to.sealedSlots, data.to.JudgeSlot) then
      table.insert(choices, 2, "shortage")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = jigao.name,
    })
    if choice ~= "Cancel" then
      event:setCostData(self, {choice = choice})
      return true
    end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local choice = event:getCostData(self).choice
        local card = player:getCardIds("he")
        card = table.filter(card, card.color == card.Black)
        if choice == "shortage" then
            local to_select = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = jigao.name,
      pattern = card,
      prompt = "use_shortage",
      cancelable = false,
    })
        if #card > 0 then
            local card2 = Fk:cloneCard("supply_shortage")
      card2:addSubcard(to_select)
      return not player:prohibitUse(card) and not player:isProhibited(player, card)
    end
    room:useVirtualCard("supply_shortage", to_select, data.to, player, jigao.name)
    end
     end
})

jigao:addEffect(fk.Damaged, {
  prompt = "#pang_jigao2",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jigao.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"losehp", "Cancel"}
    if not data.to:hasDelayedTrick("supply_shortage") and not table.contains(data.to.sealedSlots, data.to.JudgeSlot) then
      table.insert(choices, 2, "shortage")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = jigao.name,
    })
    if choice ~= "Cancel" then
      event:setCostData(self, {choice = choice})
      return true
    end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local choice = event:getCostData(self).choice
        local card = player:getCardIds("he")
        card = table.filter(card, card.color == card.Black)
        if choice == "shortage" then
            local to_select = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = jigao.name,
      pattern = card,
      prompt = "use_shortage",
      cancelable = false,
    })
        if #card > 0 then
            local card2 = Fk:cloneCard("supply_shortage")
      card2:addSubcard(to_select)
      return not player:prohibitUse(card) and not player:isProhibited(player, card)
    end
    room:useVirtualCard("supply_shortage", to_select, player, data.to, jigao.name)
    end
     end
})

Fk:loadTranslationTable{["pang_jigao"] = "饥槁",
  [":pang_jigao"] = "当你造成或受到伤害后，你可以摸两张牌并选择一项：失去1点体力；将一张黑色牌作为【兵粮寸断】对受到伤害的角色使用。",
  ["#pang_jigao1"] = "你可以摸两张牌并选择失去体力或对其用【兵粮寸断】",
  ["losehp"] = "失去体力",
  ["shortage"] = "使用兵粮寸断",
  ["use_shortage"] = "将一张黑色牌作为兵粮寸断使用",
  ["#pang_jigao2"] = "你可以摸两张牌并选择失去体力或对自己用【兵粮寸断】",
}

return jigao