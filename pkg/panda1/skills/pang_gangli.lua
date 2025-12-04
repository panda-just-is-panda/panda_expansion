local gangli = fk.CreateSkill {
  name = "pang_gangli",
  tags = {Skill.Switch},
}

Fk:loadTranslationTable {["pang_gangli"] = "钢力",
[":pang_gangli"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】①无次数限制②不能被响应。",

[":pang_gangli_yang"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】<font color=\"#E0DB2F\">①无次数限制</font>②不能被响应。",
[":pang_gangli_yin"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】①无次数限制<font color=\"#E0DB2F\">②不能被响应</font>。",

["#gangli"] = "你可以令此伤害+1",

["$pang_gangli1"] = "钢铁噪音",
["$pang_gangli2"] = "duang——！",
}

gangli:addEffect(fk.DamageCaused, {
prompt = "#gangli",
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gangli.name) and data.card and (data.card.trueName == "slash")
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(1)
  end,
})

gangli:addEffect(fk.PreCardUse, {
  can_refresh = function (self, event, target, player, data)
    return target == player and data.card.trueName == "slash" 
    and player:getSwitchSkillState(gangli.name, true) ~= fk.SwitchYang
  end,
  on_refresh = function (self, event, target, player, data)
    data.extraUse = true
  end,
})

gangli:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and to and to:hasSkill(gangli.name)
    and card.trueName == "slash" 
    and to:getSwitchSkillState(gangli.name, true) ~= fk.SwitchYang
  end,
})


gangli:addEffect(fk.TargetConfirmed, {
  can_refresh = function (self, event, target, player, data)
    return target == player and player:hasSkill(gangli.name) and data.from ~= player 
    and  data.card.trueName == "slash" and player:getSwitchSkillState(gangli.name, true) == fk.SwitchYang
  end,
  on_refresh = function (self, event, target, player, data)
    data.disresponsive = true
  end,
})


return gangli