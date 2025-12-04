local gangli = fk.CreateSkill {
  name = "pang_gangli",
  tags = {Skill.Switch},
}

Fk:loadTranslationTable {["pang_gangli"] = "钢力",
[":pang_gangli"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】①无次数限制②无距离限制。",

[":pang_gangli_yang"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】<font color=\"#E0DB2F\">①无次数限制</font>②无距离限制。",
[":pang_gangli_yin"] = "转换技，当你使用【杀】造成伤害时，你可以令此伤害+1；其他角色对你使用【杀】①无次数限制<font color=\"#E0DB2F\">②无距离限制</font>。",

["#gangli"] = "你可以令此伤害+1",

["$pang_gangli1"] = "哈～",
["$pang_gangli2"] = "哈——",
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

gangli:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and to and to == player and card.trueName == "slash" 
    and player:getSwitchSkillState(gangli.name, true) == fk.SwitchYang
  end,
  bypass_distances = function(self, player, skill, card)
    return card and to and to == player and card.trueName == "slash" 
    and player:getSwitchSkillState(gangli.name, true) ~= fk.SwitchYang
  end,
})


return gangli