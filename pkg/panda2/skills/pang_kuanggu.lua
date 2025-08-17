local kuanggu = fk.CreateSkill{
  name = "pang_kuanggu",
}

Fk:loadTranslationTable {
  ["pang_kuanggu"] = "狂骨",
  [":pang_kuanggu"] = "当你对距离不大于1的角色造成1点伤害后，你可以摸一张牌或回复1点体力。",
}

kuanggu:addEffect(fk.Damage, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(kuanggu.name) and (data.extra_data or {}).kuangguCheck
  end,
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"draw1", "Cancel"}
    if player:isWounded() then
      table.insert(choices, 2, "recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = kuanggu.name,
    })
    if choice ~= "Cancel" then
      event:setCostData(self, {choice = choice})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if event:getCostData(self).choice == "recover" then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = kuanggu.name
      }
    else
      player:drawCards(1, kuanggu.name)
    end
  end,
})

kuanggu:addEffect(fk.BeforeHpChanged, {
  can_refresh = function(self, event, target, player, data)
    if data.damageEvent and player == data.damageEvent.from and player:compareDistance(target, 2, "<") then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    data.damageEvent.extra_data = data.damageEvent.extra_data or {}
    data.damageEvent.extra_data.kuangguCheck = true
  end,
})

return kuanggu