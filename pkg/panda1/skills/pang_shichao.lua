local shichao = fk.CreateSkill({
  name = "pang_shichao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

shichao:addEffect(fk.TurnEnd, { 
  anim_type = "control",
  prompt = "#pang_shichao",
  can_trigger = function(self, event, target, player, data)
    local n = player:getLostHp()
    return target == player and player:hasSkill(shichao.name) and
      player:usedSkillTimes(shichao.name, Player.HistoryRound) < n
    end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = player
    if not to.dead then
      to:gainAnExtraTurn(true, shichao.name)
    end
  end,
})

Fk:loadTranslationTable {["pang_shichao"] = "尸潮",
[":pang_shichao"] = "每轮限X次，回合结束时，你可以执行一个额外的回合（X为你已损失的体力值）。",
["#pang_shichao"] = "你可以执行一个额外的回合。",
}
return shichao  --不要忘记返回做好的技能对象哦