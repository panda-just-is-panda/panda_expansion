local binshi = fk.CreateSkill({
  name = "pang_binshi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

binshi:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if not (target == player and player:hasSkill(binshi.name)) then return end
    return data.card.trueName == "slash"
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    if player.room:askToSkillInvoke(player, {
      skill_name = binshi.name,
      prompt = "#pang_binshi:"..data.to.id,
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local cards = room:askToDiscard(player, {
      skill_name = binshi.name,
      cancelable = true,
      min_num = 2,
      max_num = 2,
      include_equip = true,
      prompt = "binshi_beng:"..to.id,
    })
    if #cards > 1 and not to.dead then
      room:loseHp(to, 1, binshi.name)
    else
      local cards2 = room:askToChooseCards(player, {
        target = to,
        min = 2,
        max = 2,
        flag = "he",
        skill_name = binshi.name,
      })
      room:throwCard(cards2, binshi.name, to, player)
      if not player.dead then
        room:loseHp(player, 1, binshi.name)
      end
    end
  end
})

Fk:loadTranslationTable {["pang_binshi"] = "冰蚀",
[":pang_binshi"] = "当你使用【杀】指定目标后，你可以选择一项：弃置两张牌，然后其失去1点体力；弃置其两张牌，然后你失去1点体力。",
["#pang_binshi"] = "冰蚀：你可以弃置 %src 两张牌并失去体力或弃置两张牌并令 %src 失去体力",
["binshi_beng"] = "冰蚀：弃置两张牌，令 %src 失去体力，或点取消弃置 %src 两张牌",
["binshi_chai"] = "冰蚀：弃置 %src 两张牌",

["$pang_binshi1"] = "流髑杂音",
["$pang_binshi2"] = "流髑杂音",
}
return binshi  --不要忘记返回做好的技能对象哦