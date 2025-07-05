local introtheme = fk.CreateSkill({
  name = "pang_introtheme", ---技能内部名称，要求唯一性
  tags = {Skill.Wake, Skill.Lord}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

introtheme:addEffect(fk.GameStart, {
 can_trigger = function(self, event, target, player, data)
    return player:hasSkill(introtheme.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
  end
})

Fk:loadTranslationTable {["pang_introtheme"] = "奇厄教主",
[":pang_huifu"] = "主公技，游戏开始时，你播放炫酷的入场音乐。",
}
return introtheme  --不要忘记返回做好的技能对象哦