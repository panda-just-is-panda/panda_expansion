local kuren = fk.CreateSkill({
  name = "pang_kuren",
})


kuren:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(kuren.name) and data.card.trueName == "slash"
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = {player, data.to},
      skill_name = kuren.name,
      prompt = "#pang_kuren-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    data.extra_data = data.extra_data or {}
    data.extra_data.kuren = player
    if to == player then
        local discard = room:askToDiscard(player, {
            skill_name = kuren.name,
            cancelable = false,
            min_num = 1,
            max_num = 1,
            include_equip = true,
        })
        room:setPlayerMark(data.to, "pang_kuren_benghuai", 1)
    else
        local discard = room:askToChooseCards(player, {
            target = to,
            min = 1,
            max = 1,
            flag = "he",
          skill_name = kuren.name,
        })
        room:throwCard(discard, kuren.name, to, player)
        room:setPlayerMark(player, "pang_kuren_benghuai", 1)
    end
  end
})

kuren:addEffect(fk.CardUseFinished, {
  anim_type = "drawcard",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(kuren.name) and data.extra_data and data.extra_data.kuren == player then
        local n = 0
        if data.damageDealt then
            n = 1
        end
        event:setCostData(self, {extra_data = n})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local n = event:getCostData(self).extra_data
    if n == 0 then
        room:recover({who = player, num = 1, recoverBy = player, skillName = kuren.name})
    else
        for _, to in ipairs(room.alive_players) do
            if to:getMark("pang_kuren_benghuai") > 0 and not to:hasSkill("pang_benghuai") then
                room:handleAddLoseSkills(to, "pang_benghuai", nil, true, false)
            end
        end
    end
    for _, to in ipairs(room.alive_players) do
        room:setPlayerMark(to, "pang_kuren_benghuai", 0)
    end
  end,
})

Fk:loadTranslationTable {["pang_kuren"] = "枯刃",
[":pang_kuren"] = "当你使用【杀】指定唯一目标后，你可以弃置你或目标角色一张牌，然后若此【杀】：造成伤害，你和目标角色中未因此弃置牌的角色获得“崩坏”；未造成伤害，你回复1点体力。",
["#pang_kuren-choose"] = "枯刃：你可以选择弃置你或目标角色一张牌",
["#eying"] = "令至多两名角色获得护甲或用杀",
["#eying_discard"] = "弃置一张牌",

["$pang_kuren1"] = "骨骼摩擦声",
["$pang_kuren2"] = "凋零骷髅喘息",
}
return kuren