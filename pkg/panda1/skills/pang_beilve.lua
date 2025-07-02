local beilve = fk.CreateSkill({
  name = "pang_beilve", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

beilve:addEffect(fk.EventPhaseStart, { 
anim_type = "drawcard", 
prompt = "#beilve",
can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Start
  end,
on_cost = function(self, event, target, player, data)
    local player = player
    local num = 4 - player:getHandcardNum()
    if num > 0 then
      player:drawCards(num, beilve.name)
    else
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player.shield < 1 then
      room:changeShield(player, 1, {cancelable = false})
    else
      room:addPlayerMark(player, "beilve-turn", 1)
    end
  end,
})

beilve:addEffect(fk.EventPhaseChanging, {
  can_refresh = function(self, event, target, player, data)
    if target == player and player:getMark("guju_juli-turn") > 0 and not data.skipped and
      data.phase == Player.Discard then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player,"guju_juli-turn",0)
    room:sendLog{
      type = "#PhaseChanged",
      from = player.id,
      arg = Util.PhaseStrMapper(data.phase),
      arg2 = "phase_play",
    }
    data.phase = Player.Play
  end,
  })

Fk:loadTranslationTable {["pang_beilve"] = "备掠",
[":pang_beilve"] = "准备阶段，你可以将手牌数摸至四张，然后若你未因此摸牌且：没有护甲，你获得1点护甲；有护甲，你本回合的弃牌阶段改为出牌阶段。",
["#beilve"] = "你可以将手牌摸至四张，然后根据自身状态获得后续效果",
}
return jielve  --不要忘记返回做好的技能对象哦