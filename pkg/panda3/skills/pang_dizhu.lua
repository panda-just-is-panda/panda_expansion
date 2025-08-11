local dizhu = fk.CreateSkill({
  name = "pang_dizhu", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory, Skill.Permanent}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

dizhu:addEffect(fk.GameStart, {
    mute = true,
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(dizhu.name)
  end,
  on_use = function(self, event, target, player, data)
    player:broadcastSkillInvoke(dizhu.name, 1)
    local num = 17 - player:getHandcardNum()
    player.room:drawCards(player, num, dizhu.name)
  end,
})

dizhu:addEffect("maxcards", {
  fixed_func = function(self, player)
    if player:hasSkill(dizhu.name) then
        return 54
    end
  end,
})

dizhu:addEffect(fk.AfterCardsMove, {
    mute = true,
  can_refresh = function(self, event, target, player, data)
    if player:hasSkill(dizhu.name) and player:isKongcheng() then
        for _, move in ipairs(data) do
            if move.from == player then
                for _, info in ipairs(move.moveInfo) do
                if info.fromArea == Card.PlayerHand then
                    return true
                end
                end
            end
        end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    player:broadcastSkillInvoke(dizhu.name, 2)
     if player.role == "lord" or player.role == "loyalist" then
      player.room:gameOver("lord+loyalist")
    else
      player.room:gameOver(player.role)
    end
  end,
})

Fk:loadTranslationTable {["pang_dizhu"] = "地主",
[":pang_dizhu"] = "持恒技，游戏开始时，你将手牌摸至17张；你的手牌上限为54；当你失去最后一张手牌后，你获得游戏胜利。",

["$pang_dizhu1"] = "斗地主开场音乐",
["$pang_dizhu2"] = "+600豆",
}
return dizhu