local chouqi = fk.CreateSkill{
  name = "pang_chouqi",
  tags = {  },
}

Fk:loadTranslationTable {
  ["pang_chouqi"] = "仇起",
  [":pang_chouqi"] = "当一名角色受到除你以外的角色造成的伤害后，你可以选择一项，然后视为对伤害来源使用一张【杀】：此技能失效直到伤害来源死亡或你对其造成伤害；失去1点体力。",

  ["pang_losehp"] = "失去1点体力",
  ["#chouqi-invoke"] = "你可以选择一项负面，然后视为对%src使用一张【杀】",
  ["limit_skill"] = "此技能失效直到你对%src造成伤害",
  ["@@pang_chouqi"] = "仇起失效",
  ["@@pang_beichouqi"] = "仇起目标",
}

chouqi:addEffect(fk.Damaged, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(chouqi.name) and data.from and data.from ~= player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if player.room:askToSkillInvoke(player, {
      skill_name = chouqi.name,
      prompt = "#chouqi-invoke:"..data.from.id,
    }) then
    return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.from
    local choices = {"pang_losehp", "limit_skill:"..to.id}
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = chouqi.name,
    })
    if choice == "losehp" then
        room:loseHp(player, 1, chouqi.name)
    else
        room:setPlayerMark(player, "@@pang_chouqi", 1)
        room:setPlayerMark(to, "@@pang_beichouqi", 1)
        room:invalidateSkill(player, chouqi.name)
    end
    room:sortByAction(to)
    room:useVirtualCard("slash", nil, player, to, chouqi.name, true)
  end,
})


chouqi:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@@pang_chouqi") > 0 and data.to:getMark("@@pang_beichouqi") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    room:setPlayerMark(player, "@@pang_chouqi", 0)
    room:setPlayerMark(to, "@@pang_beichouqi", 0)
    room:validateSkill(player, chouqi.name)
  end,
})




return chouqi