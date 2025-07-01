local shifu = fk.CreateSkill({
  name = "pang_shifu", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

shifu:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if not (target == player and player:hasSkill(shifu.name)) then return end
    return data.card.trueName == "slash"
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    if player.room:askToSkillInvoke(player, {
      skill_name = shifu.name,
      prompt = "#pang_shifu",
    }) then
      room:loseHp(player, 1, shifu.name)
      room:loseHp(data.to, 1, shifu.name)
      if not data.to.dead and not player.dead and not data.to:isNude() then
      return true
    end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local choices = {"shifu_submit", "Cancel"}
    local choice = room:askToChoice(to, {
      choices = choices,
      skill_name = shifu.name,
    })
    if choice ~= "Cancel" then
        local cards = room:askToCards(to, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = shifu.name,
        prompt = "shifu_asking2",
        cancelable = false,
      })
      room:obtainCard(player, cards, false, fk.ReasonGive)
      room:recover({who = player, num = 1, recoverBy = player, skillName = shifu.name})
      room:recover({who = to, num = 1, recoverBy = to, skillName = shifu.name})
    end
  end
})

Fk:loadTranslationTable {["pang_shifu"] = "尸腐",
[":pang_shifu"] = "当你使用【杀】指定其他角色为目标后，你可以和其各失去1点体力，然后其可以交给你一张牌并和你回复1点体力。",
["#pang_shifu"] = "你可以和其各失去1点体力",
["shifu_submit"] = "交牌",
["shifu_asking"] = "你可以交给对方一张牌并和其各回复1点体力",
["shifu_asking2"] = "交给对方一张牌",
}
return shifu  --不要忘记返回做好的技能对象哦