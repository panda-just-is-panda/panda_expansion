
local mozong = fk.CreateSkill({
  name = "pang_mozong", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

mozong:addEffect("targetmod", {
  bypass_distances =  function(self, player, skill)
    if skill.trueName == "slash_skill" and player:hasSkill(mozong.name) then
      return true
    end
  end,
  extra_target_func = function(self, player, skill)
    if skill.trueName == "slash_skill" and player:hasSkill(mozong.name) then
      return 2
    end
  end,
})

mozong:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(mozong.name) and
      data.card.trueName == "slash" and not data.to.dead and not data.to:isNude()
      and player.shield < 1
  end,
     on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = mozong.name,
      cancelable = false,
    }) then
      return true
    end
    end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local card = room:askToChooseCard(player, {
          target = to,
          skill_name = mozong.name,
          flag = "he",
          cancelable = false,
        })
        room:throwCard(card, mozong.name, to, player)
    player:broadcastSkillInvoke(mozong.name, 2)
  end,
})


Fk:loadTranslationTable {["pang_mozong"] = "末纵",
[":pang_mozong"] = "你使用【杀】无距离限制且可以额外指定至多两名角色为目标；若你没有护甲，你使用【杀】指定目标后弃置所有目标角色各一张牌。",
["#mozong_choose"] = "弃置其一张牌"
}
return mozong  --不要忘记返回做好的技能对象哦