local jigao = fk.CreateSkill({
  name = "pang_jigao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

jigao:addEffect(fk.EventPhaseStart, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = jigao.name,
      prompt = "#pang_jigao1",
    }) then
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "pang_jigao-turn", 1)
    player:drawCards(2, jigao.name)
  end
})

jigao:addEffect(fk.Damage, {
  prompt = "#pang_jigao1",
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(jigao.name) and target == player and not data.to.dead
    and player:getMark("pang_jigao-turn") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local card
    local card2 = Fk:cloneCard("supply_shortage")
    if player:hasDelayedTrick("supply_shortage") or table.contains(player.sealedSlots, player.JudgeSlot)
    or player:prohibitUse(card2) or player:isProhibited(player, card2) or player:isKongcheng() then
      room:loseHp(player, 1, jigao.name)
      if not to:hasDelayedTrick("supply_shortage") and not table.contains(to.sealedSlots, to.JudgeSlot)
    and not to:prohibitUse(card2) and not to:isProhibited(to, card2) and not to:isKongcheng() then
        card = room:askToCards(to, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        skill_name = jigao.name,
        prompt = "use_shortage",
        cancelable = false,
        })
        if #card > 0 then
          card2:addSubcards(card)
          room:useVirtualCard("supply_shortage", card2, to, to, jigao.name)
        end
      end
    else
      card = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        skill_name = jigao.name,
        prompt = "jigao_asking",
        cancelable = true,
        })
      if #card > 0 then
        card2:addSubcards(card)
        room:useVirtualCard("supply_shortage", card2, player, player, jigao.name)
        room:loseHp(to, 1, jigao.name)
      else
        room:loseHp(player, 1, jigao.name)
        if not to:hasDelayedTrick("supply_shortage") and not table.contains(to.sealedSlots, to.JudgeSlot)
        and not to:prohibitUse(card2) and not to:isProhibited(to, card2) and not to:isKongcheng() then
          card = room:askToCards(to, {
          min_num = 1,
          max_num = 1,
          include_equip = false,
          skill_name = jigao.name,
          prompt = "use_shortage",
          cancelable = false,
          })
          if #card > 0 then
            card2:addSubcards(card)
            room:useVirtualCard("supply_shortage", card2, to, to, jigao.name)
          end
        end
      end
    end
    end,
})


Fk:loadTranslationTable{["pang_jigao"] = "饥槁",
  [":pang_jigao"] = "出牌阶段开始时，你可以摸两张牌；若如此做，当你于此回合内对其他角色造成伤害后，你需选择一项：将一张手牌作为【兵粮寸断】对自己使用；失去1点体力。然后其执行另一项。",
  ["#pang_jigao1"] = "饥槁：你可以摸两张牌",
  ["jigao_asking"] = "饥槁：将一张手牌作为【兵粮寸断】对自己使用，或点取消失去1点体力",
  ["use_shortage"] = "饥槁：将一张手牌作为【兵粮寸断】对自己使用",

  ["$pang_jigao1"] = "尸壳低吼",
  ["$pang_jigao2"] = "尸壳嘶吼",
}

return jigao