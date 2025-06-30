local wangling = fk.CreateSkill({
  name = "pang_wangling", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

wangling:addEffect(fk.HpLost, {
  anim_type = "drawcard",
  on_use = function(self, event, target, player, data)
    player:drawCards(1, wangling.name)
  end,
})

Fk:loadTranslationTable {["pang_wangling"] = "亡灵",
[":pang_wangling"] = "锁定技，当你失去体力时，你摸一张牌。",
}
return wangling  --不要忘记返回做好的技能对象哦