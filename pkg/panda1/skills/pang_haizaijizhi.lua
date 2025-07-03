local haizaijizhi = fk.CreateSkill {
  name = "pang_haizaijizhi",
  tags = {Skill.Permanent, Skill.Compulsory},
}

haizaijizhi:addEffect(fk.GameStart, {
    anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(haizaijizhi.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
   local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return not p.dead
    end)
    for _, p2 in ipairs(targets) do
    room:setPlayerMark(p2, "@@haizaijizhi", 1)
    end
  end,
})

haizaijizhi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(haizaijizhi.name)
  end,
  on_use = function(self, event, target, player, data)
    player:gainAnExtraTurn(true, haizaijizhi.name)
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