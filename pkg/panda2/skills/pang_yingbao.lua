local yingbao = fk.CreateSkill{
  name = "pang_yingbao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_yingbao"] = "蝇暴",
  [":pang_yingbao"] = "锁定技，你造成的伤害+1；你的【桃】视为无次数限制的【杀】。",

  ["$pang_yingbao1"] = "",
  ["$pang_yingbao2"] = "",
}

local jiaozi_spec = { ---@type TrigSkelSpec<fun(self: TriggerSkill, event: DamageEvent, target: ServerPlayer, player: ServerPlayer, data: DamageData):any>
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(jiaozi.name) and
      table.every(player.room:getOtherPlayers(player, false), function(p)
        return player:getHandcardNum() > p:getHandcardNum()
      end) then
      event:setCostData(self, { tos = { data.to }, anim_type = (event == fk.DamageInflicted and "negative") })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
}

yingbao:addEffect(fk.DamageCaused, {anim_type = "offensive",
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
  card_filter = function(self, to_select, player)
    return player:hasSkill(yingbao.name) and to_select.trueName == "peach" and
      table.contains(player:getCardIds("h"), to_select.id)
  end,
  view_as = function(self, player, to_select)
    local card = Fk:cloneCard("slash", Card.suit, to_select.number)
    card.skillName = yingbao.name
    return card
  end,
})
yingbao:addEffect("targetmod", {
  bypass_times =  function(self, player, skill, card, to)
    return player:hasSkill(yingbao.name) and card and card.trueName == "slash" and card.skillName == yingbao.name
  end,
})

return yingbao