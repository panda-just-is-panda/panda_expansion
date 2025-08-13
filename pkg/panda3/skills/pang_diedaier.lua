local diedai = fk.CreateSkill {
  name = "pang_diedaier",
  tags = {Skill.Quest},
}

diedai:addEffect(fk.GameStart, {
  mute = true,
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(diedai.name) and player:getMark("@dianchi") == 20
  end,
  on_cost = Util.TrueFunc,
  on_use = function (self, event, target, player, data)
    local room = player.room
    room:notifySkillInvoked(player, diedai.name)
    player:broadcastSkillInvoke(diedai.name, 1)
    local choices = {}
    if not player:hasSkill("pang_jiejin") then
      table.insert(choices, 1, "jiejin")
    end
    if not player:hasSkill("pang_hedao") then
      table.insert(choices, 1, "hedao")
    end
    if not player:hasSkill("pang_zhisu") then
      table.insert(choices, 1, "zhisu")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = diedai.name,
    })
    if choice == "zhisu" then
      room:handleAddLoseSkills(player, "pang_zhisu", nil, true, false)
    elseif choice == "hedao" then
      room:handleAddLoseSkills(player, "pang_hedao", nil, true, false)
    elseif choice == "jiejin" then
      room:handleAddLoseSkills(player, "pang_jiejin", nil, true, false)
    end
  end,
})

diedai:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(diedai.name) and data.damageType == fk.ThunderDamage
  end,
  on_trigger = function(self, event, target, player, data)
    for _ = 1, data.damage do
      if event:isCancelCost(self) or not player:hasSkill(diedai.name) then break end
      self:doCost(event, target, player, data)
    end
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "@dianchi", 2)
    if player:getMark("@dianchi") == 6 or player:getMark("@dianchi") == 12 or player:getMark("@dianchi") == 18 then
      player:broadcastSkillInvoke(diedai.name, 1)
      local choices = {}
    if not player:hasSkill("pang_jiejin") then
      table.insert(choices, 1, "jiejin")
    end
    if not player:hasSkill("pang_hedao") then
      table.insert(choices, 1, "hedao")
    end
    if not player:hasSkill("pang_zhisu") then
      table.insert(choices, 1, "zhisu")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = diedai.name,
    })
    if choice == "zhisu" then
      room:handleAddLoseSkills(player, "pang_zhisu", nil, true, false)
    elseif choice == "hedao" then
      room:handleAddLoseSkills(player, "pang_hedao", nil, true, false)
    elseif choice == "jiejin" then
      room:handleAddLoseSkills(player, "pang_jiejin", nil, true, false)
    end
    end
    if player:hasSkill("pang_jiejin") and player:hasSkill("pang_hedao") and player:hasSkill("pang_zhisu") then
      room:notifySkillInvoked(player, diedai.name)
      player:broadcastSkillInvoke(diedai.name, 2)
      room:handleAddLoseSkills(player, "pang_shenghua")
      room:setPlayerMark(player, "@diedai_xiu", 0)
      room:updateQuestSkillState(player, diedai.name)
      room:invalidateSkill(player, diedai.name)
    end
  end
})

diedai:addEffect(fk.Damaged, {
  mute = true,
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(diedai.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "@diedai_xiu", 1)
    if player:getMark("@diedai_xiu") > 4 then
      room:notifySkillInvoked(player, diedai.name)
      player:broadcastSkillInvoke(diedai.name, 3)
      room:changeMaxHp(player, -1)
      room:setPlayerMark(player, "@diedai_xiu", 0)
      room:updateQuestSkillState(player, diedai.name, true)
      room:invalidateSkill(player, diedai.name)
    end
  end,
})

diedai:addEffect("filter", {
  mute = true,
  card_filter = function(self, to_select, player)
    return player:hasSkill(diedai.name) and to_select.name == "slash" and
      table.contains(player:getCardIds("h"), to_select.id)
  end,
  view_as = function(self, player, to_select)
    local card = Fk:cloneCard("thunder__slash", to_select.suit, to_select.number)
    card.skillName = diedai.name
    return card
  end,
})

Fk:loadTranslationTable {["pang_diedaier"] = "迭代",
[":pang_diedaier"] = "使命技，你的普通【杀】均视为雷【杀】；游戏开始时，或场上所有角色每受到共计5点雷电伤害后，你获得“质速”、“荷导”和“阶进”中的一个技能。<br>\
  　成功：你因此获得三个技能后，你获得“升华”。<br>\
  　失败：你受到共计5点伤害后，你减1点体力上限。",
["zhisu"] = "获得“质速”（每回合首次使用基本牌额外结算一次）",
["hedao"] = "获得“荷导”（每回合首次使用非基本牌时摸两张牌）",
["jiejin"] = "获得“阶进”（有角色死亡时对任意角色使用雷【杀】）",
["@dianchi"] = "电能",
["@diedai_xiu"] = "朽",

  ["$pang_diedaier1"] = "Program activating.",
  ["$pang_diedaier2"] = "I, robot, child of science.",
  ["$pang_diedaier3"] = "And now to return to my long term mission: rest.",
}

return diedai