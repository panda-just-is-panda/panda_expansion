local renji = fk.CreateSkill {
  name = "pang_super_renji",
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
    local lock = 0
    local to = player.next
    if #player:getCardIds("h") < 4 and player.hp > 4 and subrandom ~= 2 then
      random = 2
    elseif not player:canUseTo(Fk:cloneCard("slash"), to, {bypass_times = true}) and subrandom ~= 4
    or to:getEquipment(Card.SubtypeArmor) and subrandom ~= 4 and random ~= 1
    or #to:getCardIds("e") > 2 and subrandom ~= 4 then
      random = 4
      if to:getEquipment(Card.SubtypeArmor) then
        lock = 1
      end
    end
    if to.hp < 2 and subrandom ~= 1 and lock ~= 1 
    or #player:getCardIds("h") > 8 and subrandom ~= 1 and lock ~= 1
    or #to:getCardIds("he") < 4 and random == 4 and lock ~= 1
    or player.hp > 5 and random == 3 and lock ~= 1 then
      random = 1
    elseif player.hp < 3 and subrandom ~= 3 
    or player.hp < 4 and (subrandom == 3 or subrandom == 4) and lock ~= 1 then
      random = 3
    end
    if (random == 2 or random == 3) and player:getMark("ai_have_draw") > 1 then
      if subrandom == 1 or subrandom == 2 then
        random = 1
      elseif subrandom == 3 or subrandom == 4 then
        random = 4
      end
    end
    if (random == 1 or random == 4) and player:getMark("ai_have_attack") > 1 then
      if subrandom == 1 or subrandom == 2 then
        random = 2
      elseif subrandom == 3 or subrandom == 4 then
        random = 3
      end
    end
    if random == 1 then
      room:askToUseVirtualCard(player, 
        {
          name = "thunder__slash", 
          skill_name = renji.name,
          cancelable = false, 
          skip = false, 
          extra_data = {bypass_distances = true, bypass_times = true, extraUse = true}
        }
      )
      room:askToUseVirtualCard(player, 
        {
          name = "thunder__slash", 
          skill_name = renji.name,
          cancelable = false, 
          skip = false, 
          extra_data = {bypass_distances = true, bypass_times = true, extraUse = true}
        }
      )
      room:setPlayerMark(player, "ai_have_draw", 0)
      room:addPlayerMark(player, "ai_have_attack", 1)
    elseif random == 2 then
      room:drawCards(player, 5, renji.name)
      room:addPlayerMark(player, "ai_have_draw", 1)
      room:setPlayerMark(player, "ai_have_attack", 0)
    elseif random == 3 then
      room:recover{
        who = player,
        num = 2,
        recoverBy = player,
        skillName = renji.name
      }
      room:drawCards(player, 2, renji.name)
      room:addPlayerMark(player, "ai_have_draw", 1)
      room:setPlayerMark(player, "ai_have_attack", 0)
    elseif random == 4 then
      room:setPlayerMark(player, "ai_have_draw", 0)
      room:addPlayerMark(player, "ai_have_attack", 1)
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = renji.name,
        prompt = "#super_renji_prompt",
        cancelable = false,
      })
      local cards = {}
      local cards2 = {}
      to = to[1]
      if not to:isNude() then
        cards2 = room:askToChooseCards(player, {
          target = to,
          min = 1,
          max = 1,
          flag = "e",
          skill_name = renji.name,
          prompt = "#super_renji_prompt",
          cancelable = false,
        })
        if #cards2 > 0 then
          room:throwCard(cards2, renji.name, to, player)
        end
        if not to:isNude() then
        cards = room:askToChooseCards(player, {
          target = to,
          min = #cards2 > 0 and 3 or 4,
          max = #cards2 > 0 and 3 or 4,
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

renji:addEffect(fk.AskForPeachesDone, {
  can_refresh = function(self, event, target, player, data)
    return data.who == player and player:hasSkill(renji.name, true, true) and player.hp <= 0
  end,
  on_refresh = function(self, event, target, player, data)
    player:chat("吓哭了，玩这么阴间的武将你的良心不会痛吗？")
  end
})

renji:addAcquireEffect(function (self, player)
  local room = player.room
  if player.maxHp < 12 then
    local n = 12 - player.maxHp
    room:changeMaxHp(player, n)
    room:recover{
      who = player,
      num = 12,
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
  local X = 0 - test.shield
  if X ~= 0 then
   room:changeShield(test, X, {cancelable = false})
  end
end)

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

Fk:loadTranslationTable {["pang_super_renji"] = "人机",
[":pang_super_renji"] = "持恒技，锁定技，准备阶段，你随机执行一项：依次视为使用两张无距离限制的雷【杀】；摸五张牌；回复2点体力并摸两张牌；弃置一名其他角色四张牌。",
["#super_renji_prompt"] = "如果你能看到这条信息，那我问你：为什么不ban质检员？",



}

return renji