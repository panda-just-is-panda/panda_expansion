local skill = fk.CreateSkill({
  name = "pang_yingzi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})
--添加技能效果
skill:addEffect(fk.EventPhaseStart, { --准备阶段
  anim_type = "drawcard", --动画效果为  摸牌动画
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards( 1, pang_yingzi.name)
  end,
})
Fk:loadTranslationTable {["pang_yingzi"] = "英姿",
[":pang_yingzi"] = "准备阶段，你摸一张牌。",
}
return skill  --不要忘记返回做好的技能对象哦

