local moyi = fk.CreateSkill({
  name = "pang_moyi", 
  tags = {}, 
})


Fk:loadTranslationTable{
  ["pang_moyi"] = "末移",
  [":pang_moyi"] = "每轮限一次，当其他角色使用的指定了你为目标的牌结算结束后，你可以对其使用一张牌（无距离限制）并摸一张牌，且你于当前回合结束时和本轮结束时也可以如此做；每轮结束时，若你本轮未发动此技能，你可以移动场上的一张牌。",

  ["#pang_moyi"] = "末移：你可以对 %src 使用一张牌并摸一张牌",
  ["@moyi_record-round"] = "末移目标",
  ["#pang_moyi_move"] = "末移：你可以移动场上的一张牌",


  ["$pang_moyi1"] = "末影人生气",
  ["$pang_moyi2"] = "末影人怒吼",
  ["$pang_moyi3"] = "末影人嘶吼",
  ["$pang_moyi4"] = "末影人低吟",
}

moyi:addEffect(fk.CardUseFinished, {
    mute = true,
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(moyi.name) and table.contains(data.tos, player)
    and player:usedSkillTimes(moyi.name, Player.HistoryRound) < 1
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local use = room:askToUseCard(player, {
      skill_name = moyi.name,
      prompt = "#pang_moyi:"..target.id,
      extra_data = {
        exclusive_targets = {target.id},
        bypass_times = true,
        bypass_distances = true,
      }
    })
    if use then
    player:broadcastSkillInvoke(moyi.name, 1)
      use.extraUse = true
      room:useCard(use)
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, moyi.name)
    room:setPlayerMark(player, "@moyi_record-round", target)
    room:setPlayerMark(target, "moyi_target-round", 1)
    room:setPlayerMark(player, "moyi_use-turn", 1)
  end,
})

moyi:addEffect(fk.TurnEnd, { 
    mute = true,
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(moyi.name) and player:getMark("moyi_use-turn") == 1
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to
    for _, p in ipairs(room:getOtherPlayers(player, false)) do
        if p:getMark("moyi_target-round") == 1 then
            to = p
        end
    end
    local use = room:askToUseCard(player, {
      skill_name = moyi.name,
      prompt = "#pang_moyi:"..to.id,
      extra_data = {
        exclusive_targets = {to.id},
        bypass_times = true,
        bypass_distances = true,
      }
    })
    if use then
        player:broadcastSkillInvoke(moyi.name, 2)
      use.extraUse = true
      room:useCard(use)
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, moyi.name)
end,
})

moyi:addEffect(fk.RoundEnd, { 
    mute = true,
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(moyi.name) and player:usedSkillTimes(moyi.name, Player.HistoryRound) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to
    for _, p in ipairs(room:getOtherPlayers(player, false)) do
        if p:getMark("moyi_target-round") == 1 then
            to = p
        end
    end
    local use = room:askToUseCard(player, {
      skill_name = moyi.name,
      prompt = "#pang_moyi:"..to.id,
      extra_data = {
        exclusive_targets = {to.id},
        bypass_times = true,
        bypass_distances = true,
      }
    })
    if use then
        player:broadcastSkillInvoke(moyi.name, 3)
      use.extraUse = true
      room:useCard(use)
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, moyi.name)
end,
})

moyi:addEffect(fk.RoundEnd, { 
    mute = true,
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(moyi.name) and player:usedSkillTimes(moyi.name, Player.HistoryRound) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = room:askToChooseToMoveCardInBoard(player, {
        prompt = "#pang_moyi_move",
        skill_name = moyi.name,
        cancelable = true,
      })
    if #targets == 2 then
        event:setCostData(self, {tos = targets})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player:broadcastSkillInvoke(moyi.name, 4)
    local room = player.room
    local targets = event:getCostData(self).tos
        room:askToMoveCardInBoard(player, {
          target_one = targets[1],
          target_two = targets[2],
          skill_name = moyi.name,
        })
end,
})



return moyi