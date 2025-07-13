local jinxing = fk.CreateSkill({
  name = "pang_jinxing", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

jinxing:addEffect(fk.RoundStart, {
  anim_type = "support",
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(jinxing.name)
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    player.room:addPlayerMark(player, "@jinxing_huihe")
  end
})

jinxing:addEffect(fk.TurnStart, {
     can_refresh = function (self, event, target, player, data)
    return player:hasSkill(jinxing.name) and player:getMark("@jinxing_huihe") > 0
    end,
    on_refresh = function (self, event, target, player, data)
        player.room:setPlayerMark(player, "@jinxing_huihe", 0)
    end
})

jinxing:addEffect(fk.RoundEnd, {
    can_trigger = function (self, event, target, player, data)
    return player:hasSkill(jinxing.name) and player:getMark("@jinxing_huihe") > 0
end,
    on_cost = function(self, event, target, player, data)
        if player.room:askToSkillInvoke(player, {
            skill_name = jinxing.name,
            prompt = "#jinxing",})
        then 
            return true
        end
end,
    on_use = function (self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player, "@jinxing_huihe", 0)
    player:gainAnExtraTurn(true, jinxing.name)
  end
})

Fk:loadTranslationTable {["pang_jinxing"] = "尽兴",
[":pang_jinxing"] = "每轮结束时，若你本轮未执行过回合，你执行一个额外的回合；你于此回合内使用牌无次数限制。",
["#jinxing"] = "你可以执行一个额外的回合",
[ "@jinxing_huihe"] = "尽兴",
}
return jinxing