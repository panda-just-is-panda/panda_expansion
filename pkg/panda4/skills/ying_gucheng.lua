local gucheng = fk.CreateSkill({
  name = "ying_gucheng", 
  tags = {}, 
})


Fk:loadTranslationTable{
  ["ying_gucheng"] = "固城",
  [":ying_gucheng"] = "每回合限一次，你于回合外使用牌或受到伤害后，可以摸一张牌，然后你本回合于另一时机可以摸两张牌或回复1点体力。",

  ["#gucheng-invoke1"] = "固城（使用牌后）：你可以摸一张牌",
  ["#gucheng-invoke2"] = "固城（受到伤害后）：你可以摸一张牌",

  ["@@gucheng_damage-turn"] = "使用牌后可发动",
  ["@@gucheng_use-turn"] = "受到伤害后可发动",
  ["pang_recover"] = "回复1点体力",

}

gucheng:addEffect(fk.CardUseFinished, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gucheng.name) and player.room.current ~= player
    and player:usedSkillTimes(gucheng.name, Player.HistoryTurn) == 0
  end,
  on_cost = function (self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = gucheng.name,
      prompt = "#gucheng-invoke1",
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, gucheng.name)
    room:addPlayerMark(player, "@@gucheng_use-turn")
  end,
})


gucheng:addEffect(fk.Damaged, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gucheng.name) and player.room.current ~= player
    and player:usedSkillTimes(gucheng.name, Player.HistoryTurn) == 0
  end,
  on_cost = function (self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = gucheng.name,
      prompt = "#gucheng-invoke2",
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, gucheng.name)
    room:addPlayerMark(player, "@@gucheng_damage-turn")
  end,
})

gucheng:addEffect(fk.CardUseFinished, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(gucheng.name) and player:getMark("@@gucheng_damage-turn") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local choices = {"draw2", "Cancel"}
    if player:isWounded() then
      table.insert(choices, 2, "pang_recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = gucheng.name,
    })
    if choice == "pang_recover" then
      room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = gucheng.name
      })
    elseif choice == "draw2" then
      player:drawCards(2, gucheng.name)
    end
  end,
})

gucheng:addEffect(fk.Damaged, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(gucheng.name) and player:getMark("@@gucheng_use-turn") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local choices = {"draw2", "Cancel"}
    if player:isWounded() then
      table.insert(choices, 2, "pang_recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = gucheng.name,
    })
    if choice == "pang_recover" then
      room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = gucheng.name
      })
    elseif choice == "draw2" then
      player:drawCards(2, gucheng.name)
    end
  end,
})



return gucheng