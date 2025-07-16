local glory = fk.CreateSkill({
  name = "pang_zhandourongyao", ---技能内部名称，要求唯一性
  tags = {Skill.Lord}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

glory:addAcquireEffect(function (self, player)
  local room = player.room
  for _, p in ipairs(room:getAlivePlayers()) do
            if p.kingdom == "wei" then
                room:handleAddLoseSkills(p, "pang_jiang", nil, false, true)
            else
                room:handleAddLoseSkills(p, "-pang_jiang", nil, false, true)
            end
        end
end)

glory:addEffect(fk.AfterPropertyChange, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if player.kingdom == "wei" and table.find(room.alive_players, function (p)
      return p:hasSkill(glory.name, true)
    end) then
      room:handleAddLoseSkills(player, "pang_jiang", nil, false, true)
    else
      room:handleAddLoseSkills(player, "-pang_jiang", nil, false, true)
    end
  end,
})

Fk:loadTranslationTable {["pang_zhandourongyao"] = "战斗荣耀",
[":pang_zhandourongyao"] = "主公技，魏势力角色视为拥有“激昂”。",
}
return glory