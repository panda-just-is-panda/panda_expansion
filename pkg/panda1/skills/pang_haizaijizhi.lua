local haizaijizhi = fk.CreateSkill {
  name = "pang_haizaijizhi",
  tags = {Skill.Permanent, Skill.Compulsory},
}

haizaijizhi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(haizaijizhi.name)
  end,
  on_use = function(self, event, target, player, data)
    player:gainAnExtraTurn(true, haizaijizhi.name)
  end,
})

haizaijizhi:addEffect(fk.RoundStart, {
    anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player.room:getBanner("RoundCount") == 1 and player:hasSkill(haizaijizhi.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local targets = room:getOtherPlayers(player, false)
    for _, p in targets do
    room:setPlayerMark(targets, "@@haizaijizhi", 1)
    end
  end,
})

haizaijizhi:addEffect(fk.RoundEnd, {
    late_refresh = true,
  can_refresh = function (self, event, target, player, data)
    return target == player and
      table.find({ "@@haizaijizhi" }, function(markName)
        return player:getMark(markName) ~= 0
      end)
  end,
  on_refresh = function (self, event, target, player, data)
    local room = player.room
    for _, markName in ipairs({ "@@haizaijizhi" }) do
      room:setPlayerMark(player, markName, 0)
    end
  end,
})

haizaijizhi:addEffect("invalidity", {
  invalidity_func = function(self, from, skill)
    return from:getMark("@@haizaijizhi") > 0 and skill:isPlayerSkill(from)
  end
})


Fk:loadTranslationTable {["pang_haizaijizhi"] = "还在机制",
[":pang_haizaijizhi"] = "持恒技，游戏开始时，你执行一个额外的回合；本局游戏的首轮内，其他角色的所有技能失效。",
["@@haizaijizhi"] = "胖怒"
}
return haizaijizhi