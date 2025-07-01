local kuangluan = fk.CreateSkill({
  name = "pang_kuangluan", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

kuangluan:addEffect(fk.EventPhaseStart, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, kuangluan.name)
    local use = room:askToUseCard(player, {
      skill_name = kuangluan.name,
      pattern = "slash",
      prompt = "#kuangluan_sha",
      extra_data = {
        bypass_times = true,
      }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
    else
        room:loseHp(player, 1, kuangluan.name)
    end
  end,
})
kuangluan:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return 1
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, kuangluan.name)
    local use = room:askToUseCard(player, {
      skill_name = kuangluan.name,
      pattern = "slash",
      prompt = "#kuangluan_sha",
      extra_data = {
        bypass_times = true,
      }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
    else
        room:loseHp(player, 1, kuangluan.name)
    end
  end,
})

Fk:loadTranslationTable {["pang_kuangluan"] = "狂乱",
[":pang_kuangluan"] = "锁定技，结束阶段或当你受到伤害后，你摸一张牌并选择一项：使用一张【杀】；失去1点体力。",
["#kuangluan_sha"] = "你需使用一张【杀】，否则失去1点体力",
}
return kuangluan  --不要忘记返回做好的技能对象哦