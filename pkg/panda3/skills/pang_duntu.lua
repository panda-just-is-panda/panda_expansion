local duntu = fk.CreateSkill{
  name = "pang_duntu",
    tags = {Skill.Permanent, Skill.Compulsory},
}

duntu:addEffect(fk.GameStart, {
  mute = true,
can_refresh = function(self, event, target, player, data)
    return player:hasSkill(duntu.name)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "pang_aiganglie", nil, true, false)
  end,
})

duntu:addEffect(fk.CardUseFinished, {
  mute = true,
can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(duntu.name) and not player:hasSkill("tiandu")
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "tiandu", nil, true, false)
  end,
})

duntu:addEffect(fk.TurnEnd, {
  mute = true,
can_refresh = function(self, event, target, player, data)
    return player:hasSkill(duntu.name) and player:hasSkill("tiandu")
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "-tiandu", nil, true, false)
  end,
})

duntu:addEffect(fk.Death, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(duntu.name) and data.killer == player
  end,
  on_refresh = function(self, event, target, player, data)
    player:broadcastSkillInvoke(duntu.name, 1)
    local room = player.room
    room:handleAddLoseSkills(player, "-pang_duntu|-pang_ganglie|pang_ganglieex|pang_dunnu", nil, true, false)
    if player.general == "pang__xiahoudun" then
      player.general = "pang__exxiahoudun"
      room:broadcastProperty(player, "general")
    else
      player.deputyGeneral = "pang__exxiahoudun"
      room:broadcastProperty(player, "deputyGeneral")
    end
    if player:hasSkill("tiandu") then
        room:handleAddLoseSkills(player, "-tiandu", nil, true, false)
    end
    if player:hasSkill("pang_aiganglie") then
        room:handleAddLoseSkills(player, "-pang_aiganglie", nil, true, false)
    end
  end,
})

duntu:addEffect(fk.EnterDying, {
  mute = true,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "-pang_duntu|-pang_ganglie|pang_ganglieex|pang_dunnu", nil, true, false)
    player:broadcastSkillInvoke(duntu.name, 1)
    if player.general == "pang__xiahoudun" then
      player.general = "pang__exxiahoudun"
      room:broadcastProperty(player, "general")
    else
      player.deputyGeneral = "pang__exxiahoudun"
      room:broadcastProperty(player, "deputyGeneral")
    end
    if player:hasSkill("tiandu") then
        room:handleAddLoseSkills(player, "-tiandu", nil, true, false)
    end
    if player:hasSkill("pang_aiganglie") then
        room:handleAddLoseSkills(player, "-pang_aiganglie", nil, true, false)
    end
  end,
})

Fk:loadTranslationTable{
  ["pang_duntu"] = "惇途",
  [":pang_duntu"] = "游戏开始时，你获得“唉刚烈”；<br>\
  当你使用一张牌后，本回合你获得“天妒”；<br>\
  当你杀死角色或进入濒死状态时，你界限突破！",
}

return duntu