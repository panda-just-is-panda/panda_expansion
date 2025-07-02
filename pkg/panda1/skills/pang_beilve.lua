local beilve = fk.CreateSkill({
  name = "pang_beilve", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

beilve:addEffect(fk.EventPhaseStart, { 
anim_type = "drawcard", 
cancelable = true,
can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Start
  end,
on_cost = function(self, event, target, player, data)
    local room = player.room
    local player = player
    if player.room:askToSkillInvoke(player, {
      skill_name = beilve.name,
      prompt = "#beilve",
    }) then
    local num = 3 - player:getHandcardNum()
    if player.shield > 0 then
      room:addPlayerMark(player, "beilve-turn", 1)
    end
    if num > 0 then
      player:drawCards(num, beilve.name)
    else
      return true
    end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player.shield < 1 then
      room:changeShield(player, 1, {cancelable = false})
    end
  end,
})

beilve:addEffect(fk.EventPhaseChanging, {
  can_refresh = function(self, event, target, player, data)
    local room = player.room
    if target == player and player:getMark("beilve-turn") > 0 and not data.skipped and
      data.phase == Player.Discard then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    data.skipped = true
    if player.dead then return end
    player:gainAnExtraPhase(Player.Play, beilve.name)
  end,
  })

Fk:loadTranslationTable {["pang_beilve"] = "备掠",
[":pang_beilve"] = "准备阶段，你可以将手牌数摸至三张，然后若你：未因此摸牌且没有护甲，你获得1点护甲；有护甲，你本回合的弃牌阶段改为出牌阶段。",
["#beilve"] = "你可以将手牌摸至三张，并根据自身状态获得后续效果",
["jielve-turn"] = "——劫掠——"
}
return beilve  --不要忘记返回做好的技能对象哦