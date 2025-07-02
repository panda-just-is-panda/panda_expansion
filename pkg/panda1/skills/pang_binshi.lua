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
      prompt = "#pang_binshi",
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local choices = {"Cancel"}
    local cards_player = player:getCardIds("he")
    local cards_to = to:getCardIds("he")
    if #cards_to > 1 then
      table.insert(choices, 1, "binshi_chai")
    end
    if #cards_player > 1 then
      table.insert(choices, 1, "binshi_beng")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = binshi.name,
    })
    if choice == "binshi_chai" then
        local cards2 = room:askToChooseCards(player, {
            target = to,
            min = 1,
            max = 2,
            flag = "he",
          skill_name = binshi.name,
        })
        room:throwCard(cards2, binshi.name, to, player)
        if not player.dead then
            room:loseHp(player, 1, binshi.name)
      end
    elseif choice == "binshi_beng" then
        local card = room:askToDiscard(player, {
          skill_name = binshi.name,
          cancelable = false,
          min_num = 2,
          max_num = 2,
          include_equip = true,
        })
        if not to.dead then
            room:loseHp(to, 1, binshi.name)
        end
    end
  end
})

Fk:loadTranslationTable {["pang_binshi"] = "冰蚀",
[":pang_binshi"] = "当你使用【杀】指定目标后，你可以选择一项：弃置两张牌，然后其失去1点体力；弃置其两张牌，然后你失去1点体力。",
["#pang_binshi"] = "你可以发动“冰蚀”",
["binshi_chai"] = "弃置其牌，你失去体力",
["binshi_beng"] = "你弃置牌，其失去体力",
["binshi_chai2"] = "弃置其两张牌",
}
return binshi  --不要忘记返回做好的技能对象哦