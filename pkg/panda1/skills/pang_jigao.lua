local jigao = fk.CreateSkill({
  name = "pang_jigao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

jigao:addEffect(fk.Damage, {
  prompt = "#pang_jigao1",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jigao.name) and target == player and not data.to.dead
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    if room:askToSkillInvoke(player, {
      skill_name = jigao.name,
      prompt = "#pang_jigao1",
    }) then
      event:setCostData(self, {tos = {data.to}})
      to:drawCards(1)
      return true
    end
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local card = table.filter(to:getCardIds("he"), function(id)
    local card_pick = Fk:getCardById(id)
        return card_pick and card_pick.color == card_pick.Black and not to:prohibitDiscard(id)
        end)
    local choices = {"losehp"}
    if not to:hasDelayedTrick("supply_shortage") 
    and not table.contains(to.sealedSlots, to.JudgeSlot)
    and #card > 0
    then
      table.insert(choices, 2, "shortage")
    end
    local choice = room:askToChoice(to, {
      choices = choices,
      skill_name = jigao.name,
    })
        if choice == "shortage" then
            local to_select = room:askToCards(to, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = jigao.name,
      pattern = ".|.|spade,club",
      prompt = "use_shortage",
      cancelable = false,
    })
        if #to_select > 0 then
            local card2 = Fk:cloneCard("supply_shortage")
      card2:addSubcards(to_select)
      if not player:prohibitUse(card2) and not player:isProhibited(player, card2) then
    room:useVirtualCard("supply_shortage", card2, to, to, jigao.name)
      end
    end
        else
            room:loseHp(to, 1, jigao.name)
            player:drawCards(1)
    end
     end
})

jigao:addEffect(fk.Damaged, {
  prompt = "#pang_jigao1",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jigao.name) and target == player and not player.dead
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = jigao.name,
      prompt = "#pang_jigao1",
    }) then
      event:setCostData(self, {tos = {player}})
      player:drawCards(1)
      return true
    end
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
    local card = table.filter(player:getCardIds("he"), function(id)
    local card_pick = Fk:getCardById(id)
        return card_pick and card_pick.color == card_pick.Black and not player:prohibitDiscard(id)
        end)
    local choices = {"losehp"}
    if not data.to:hasDelayedTrick("supply_shortage") 
        and not table.contains(data.to.sealedSlots, data.to.JudgeSlot)
        and #card > 0
    then
      table.insert(choices, 2, "shortage")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = jigao.name,
    })
    if choice == "shortage" then
            local to_select = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = jigao.name,
      pattern = ".|.|spade,club",
      prompt = "use_shortage",
      cancelable = false,
    })
        if #to_select > 0 then
            local card2 = Fk:cloneCard("supply_shortage")
      card2:addSubcards(to_select)
      if not player:prohibitUse(card2) and not player:isProhibited(player, card2) then
    room:useVirtualCard("supply_shortage", card2, player, player, jigao.name)
      end
    end
    else
        room:loseHp(player, 1, jigao.name)
        player:drawCards(1)
    end
    end
})

Fk:loadTranslationTable{["pang_jigao"] = "饥槁",
  [":pang_jigao"] = "当你造成或受到伤害后，你可以令受到伤害的角色摸一张牌并选择一项：失去1点体力，你摸一张牌；将一张黑色牌作为【兵粮寸断】对自己使用。",
  ["#pang_jigao1"] = "你可以令其摸一张牌并选择失去体力或对自己用【兵粮寸断】",
  ["losehp"] = "失去体力",
  ["shortage"] = "获得饥饿",
  ["use_shortage"] = "将一张黑色牌作为兵粮寸断使用",
  ["#pang_jigao2"] = "你可以摸一张牌并选择失去体力或对自己用【兵粮寸断】",
}

return jigao