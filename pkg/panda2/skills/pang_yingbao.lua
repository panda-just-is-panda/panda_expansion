local yingbao = fk.CreateSkill{
  name = "pang_yingbao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_yingbao"] = "蝇暴",
  [":pang_yingbao"] = "锁定技，你造成的伤害+1；你的【桃】和【酒】均视为【杀】。",

  ["$pang_yingbao1"] = "激昂的小曲～",
}

yingbao:addEffect(fk.GameStart, {
    mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yingbao.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:broadcastSkillInvoke(yingbao.name, 1)
  end,
})

yingbao:addEffect(fk.DamageCaused, {anim_type = "offensive",
    mute = true,
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(yingbao.name) then
      event:setCostData(self, { tos = { data.to }})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,})

yingbao:addEffect("filter", {
  mute = true,
  card_filter = function(self, to_select, player)
    return player:hasSkill(yingbao.name) and (to_select.trueName == "peach" or to_select.trueName == "analeptic") and
      table.contains(player:getCardIds("h"), to_select.id)
  end,
  view_as = function(self, player, to_select)
    local card1 = Fk:cloneCard("slash", to_select.suit, to_select.number)
    card1.skillName = yingbao.name
    return card1
  end,
})


return yingbao