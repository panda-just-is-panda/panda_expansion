---@param player ServerPlayer @ 目标角色
EnterHidden = function (player)
  local room = player.room
  if player:getMark("__hidden_general") == 0 and player:getMark("__hidden_deputy") == 0 then
  room:sendLog({
    type = "#EnterHidden",
    from = player.id,
  })
  local skills = "hidden_skill&"
  room:setPlayerMark(player, "__hidden_general", player.general)
  for _, s in ipairs(Fk.generals[player.general]:getSkillNameList(true)) do
    if player:hasSkill(s, true) then
      skills = skills.."|-"..s
    end
  end
  if player.deputyGeneral ~= "" then
    room:setPlayerMark(player, "__hidden_deputy", player.deputyGeneral)
    for _, s in ipairs(Fk.generals[player.deputyGeneral]:getSkillNameList(true)) do
      if player:hasSkill(s, true) then
        skills = skills.."|-"..s
      end
    end
  end
  player.general = "hiddenone"
  player.gender = General.Male
  room:broadcastProperty(player, "gender")
  if player.deputyGeneral ~= "" then
    player.deputyGeneral = ""
  end
  player.kingdom = "jin"
  room:setPlayerMark(player, "__hidden_record",
  {
    maxHp = player.maxHp,
    hp = player.hp,
  })
  player.maxHp = 1
  player.hp = 1
  for _, property in ipairs({"general", "deputyGeneral", "kingdom", "maxHp", "hp"}) do
    room:broadcastProperty(player, property)
  end
  room:handleAddLoseSkills(player, skills, nil, false, true)
  end
end


local gentle = fk.CreateSkill({
  name = "hua_gentle_night", 
  tags = {Skill.Limited}, 
})

Fk:loadTranslationTable {["hua_gentle_night"] = "夜色温柔",
[":hua_gentle_night"] = "限定技，当你进入濒死状态时，你可以令一名其他角色获得“怀橘”与1枚“橘”，然后其视为对你使用一张【杀】。若你因此被其杀死，则其执行的奖惩为反贼奖惩；若你未死亡，你回复所有体力，然后隐匿。",
["#gentle-orange"] = "夜色温柔：你可以令一名其他角色获得“怀橘”与1枚“橘”，然后其视为对你使用【杀】",
}

gentle:addEffect(fk.EnterDying, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gentle.name) and
      player:usedSkillTimes(gentle.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = gentle.name,
        prompt = "#gentle-orange",
        cancelable = true,
      })
    if #tos > 0 then
        event:setCostData(self, {tos = tos})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    if not to.dead then
        room:handleAddLoseSkills(to, "hua_huaiju", nil, true, false)
        if not player.dead then
            room:useVirtualCard("slash", nil, to, player, gentle.name, true)
        end
    end
    if not player.dead then
        room:setPlayerMark(to, "orange_holding", 0)
        room:recover{
            who = player,
            num = player.maxHp,
            recoverBy = player,
            skillName = gentle.name,
        }
        EnterHidden(player)
    end

  end,
})

gentle:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and data.card and table.contains(data.card.skillNames, gentle.name)
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addPlayerMark(data.from, "orange_holding", 1)
  end,
})

gentle:addEffect(fk.BuryVictim, {
  anim_type = "drawcard",
  can_refresh = function(self, event, target, player, data)
      return data.damage and data.damage.from and data.damage.from:getMark("orange_holding") > 0
      and target == player and player:hasSkill(gentle.name, false, true)
      and not (data.extra_data and data.extra_data.skip_reward_punish)
  end,
  on_refresh = function(self, event, target, player, data)
    data.extra_data = data.extra_data or {}
    data.extra_data.skip_reward_punish = true
    data.damage.from:drawCards(3, gentle.name)
  end
})

return gentle