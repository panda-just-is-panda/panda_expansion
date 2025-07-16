local glory = fk.CreateSkill({
  name = "pang_zhandourongyao", ---技能内部名称，要求唯一性
  tags = {Skill.Lord}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

glory:addEffect(fk.GameStart, {
    can_refresh = function(self, event, target, player, data)
        return player:hasSkill(glory.name)
    end,
    on_refresh = function(self, event, target, player, data)
        local room = player.room
        for _, p in ipairs(room:getAlivePlayers()) do
            if p.kingdom == "wei" then
                room:handleAddLoseSkills(p, "pang_jiang", nil, false, true)
            end
        end
    end,
})

Fk:loadTranslationTable {["pang_zhandourongyao"] = "战斗荣耀",
[":pang_zhandourongyao"] = "主公技，游戏开始时，所有魏势力角色获得“激昂”。",
}
return glory