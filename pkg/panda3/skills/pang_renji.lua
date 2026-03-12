local renji = fk.CreateSkill {
  name = "pang_renji",
    tags = {Skill.Compulsory},
}

renji:addEffect(fk.EventPhaseStart, {
anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(renji.name) and target.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local random = math.random(1, 4)
    local subrandom = math.random(1, 4)
    local to = player.next
    if not player:canUseTo(Fk:cloneCard("slash"), to, {bypass_times = true}) and #to:getCardIds("e") > 0 and subrandom ~= 4
    or #to:getCardIds("e") > 2 and to:getEquipment(Card.SubtypeArmor) and subrandom ~= 4 then
      random = 4
    elseif #player:getCardIds("h") < 2 and subrandom ~= 2 then
      random = 2
    end
    if to.hp < 2 and subrandom ~= 1 then
      random = 1
    elseif player.hp < 2 and subrandom ~= 3 or random == 2 and player.hp < 3 and subrandom ~= 3 then
      random = 3
    end
    if random == 1 then
      room:askToUseVirtualCard(player, 
        {
          name = "slash", 
          skill_name = renji.name,
          cancelable = false, 
          skip = false, 
          extra_data = {bypass_distances = true, bypass_times = true, extraUse = true}
        }
      )
    elseif random == 2 then
      room:drawCards(player, 2, renji.name)
    elseif random == 3 then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = renji.name
      }
      room:drawCards(player, 1, renji.name)
    else
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = renji.name,
        prompt = "#renji_prompt",
        cancelable = false,
      })
      to = to[1]
      local cards = {}
      local cards2 = {}
      if not to:isNude() then
        cards2 = room:askToChooseCards(player, {
          target = to,
          min = 1,
          max = 1,
          flag = "e",
          skill_name = renji.name,
          prompt = "#renji_prompt",
          cancelable = false,
        })
        if #cards2 > 0 then
          room:throwCard(cards2, renji.name, to, player)
        end
        if not to:isNude() then
        cards = room:askToChooseCards(player, {
          target = to,
          min = #cards2 > 0 and 1 or 2,
          max = #cards2 > 0 and 1 or 2,
          flag = "he",
          skill_name = renji.name,
          prompt = "#super_renji_prompt",
          cancelable = false,
        })
      end
      if #cards > 0 then
        room:throwCard(cards, renji.name, to, player)
      end
    end
    end
  end,
})

renji:addAcquireEffect(function (self, player)
  local room = player.room
  if player.maxHp < 6 then
    local n = 6 - player.maxHp
    room:changeMaxHp(player, n)
    room:recover{
      who = player,
      num = 6,
      recoverBy = player,
      skillName = renji.name
    }
  end
  local test = player.next
  local X = 0 - test.shield
  if X ~= 0 then
   room:changeShield(test, X, {cancelable = false})
  end
  room:changeMaxHp(test, 10)
    room:recover{
      who = test,
      num = 10,
      recoverBy = player,
      skillName = renji.name
    }
  test = player
  X = 0 - test.shield
  if X ~= 0 then
   room:changeShield(test, X, {cancelable = false})
  end
end)

renji:addEffect(fk.AskForPeachesDone, {
  can_refresh = function(self, event, target, player, data)
    return data.who == player and player:hasSkill(renji.name, true, true) and player.hp <= 0
  end,
  on_refresh = function(self, event, target, player, data)
    player:chat("你过关。")
  end
})
renji:addEffect(fk.TurnEnd, { --
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(renji.name, true, true) and player:getMark("renji_qishou") == 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = player.next
    room:setPlayerMark(player, "renji_qishou", 1)
    room:throwCard(to:getCardIds("he"), renji.name, to, player)
    to:drawCards(4, renji.name)
    room:throwCard(player:getCardIds("he"), renji.name, player, player)
    player:drawCards(4, renji.name)
    local general = Fk.generals[to.general]
    local skills = table.filter(general:getSkillNameList(true), function (s)
      return to:hasSkill(s, true)
    end)
    local startSkills = {}---@type TriggerSkill[]
    local start_events = {fk.GamePrepared, fk.GameStart}
    for _, sname in ipairs(skills) do
      local s = Fk.skills[sname]
      local slist = {s}
      table.insertTable(slist, s.related_skills)
      for _, skill in ipairs(slist) do
        if skill:isInstanceOf(TriggerSkill) and skill.event and table.contains(start_events, skill.event) then
          table.insertIfNeed(startSkills, skill)
        end
      end
    end
    if #startSkills == 0 then return end
    for _, event in ipairs(start_events) do
      local event_data = {}
      local event_obj = event:new(room, target, event_data)
      for _, skill in ipairs(startSkills) do
        if skill.event == event then
          if not skill.late_refresh and skill:canRefresh(event_obj, to, to, event_data) then
            skill:refresh(event_obj, to, to, event_data)
          end
          if skill:triggerable(event_obj, to, to, event_data) then
            skill:trigger(event_obj, to, to, event_data)
          end
          if skill.late_refresh and skill:canRefresh(event_obj, to, to, event_data) then
            skill:refresh(event_obj, to, to, event_data)
          end
        end
      end
    end
end,
})

Fk:loadTranslationTable {["pang_renji"] = "人机",
[":pang_renji"] = "锁定技，准备阶段，你随机执行一项：视为使用一张无距离限制的【杀】；摸两张牌；回复1点体力并摸一张牌；弃置一名其他角色两张牌。",
["#renji_prompt"] = "如果你能看到这条信息，那我问你：为什么不ban质检员？",


}

return renji