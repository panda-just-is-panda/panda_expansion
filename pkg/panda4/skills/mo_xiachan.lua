local xiachan = fk.CreateSkill {
  name = "mo_xiachan",
  tags = {Skill.Compulsory},
}

Fk:loadTranslationTable{
  ["mo_xiachan"] = "挟缠",
  [":mo_xiachan"] = "锁定技，你的牌被响应过的回合内，你因【杀】或【决斗】造成的伤害+1。",
  ["@@mo_xiachan-turn"] = "挟缠",


  ["$mo_xiachan1"] = "脱！",
  ["$mo_xiachan2"] = "谁来与我大战三百回合？",
}

local spec = {
  anim_type = "offensive",
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(xiachan.name) and target ~= player and
      data.responseToEvent and data.responseToEvent.from == player and
      data.responseToEvent.card
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if player:getMark("@@mo_xiachan-turn") == 0 then
      room:addPlayerMark(player, "@@mo_xiachan-turn", 1)
    end
  end,
}

xiachan:addEffect(fk.CardUsing, spec)
xiachan:addEffect(fk.CardResponding, spec)

xiachan:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return player:getMark("@@mo_xiachan-turn") > 0 and target == player and
      data.card and (data.card.trueName == "slash" or data.card.name == "duel") and data.by_user
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

return xiachan