local tiewan = fk.CreateSkill({
  name = "pang_tiewantongzhi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

tiewan:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"wuzhongshengyou", "Cancel"}
    if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
      if player:canUseTo(Fk:cloneCard("dismantlement"), data.to) then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_attack2::"..data.to.id,
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    else
      local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
      if #targets > 0 then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_attack1",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    end
    end,
    on_use = function(self, event, target, player, data)
      local room = player.room
      local choice = event:getCostData(self).choice
      if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
        local target = data.to
        if choice == "wuzhongshengyou" then
          room:useVirtualCard("ex_nihilo", nil, player, target, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 3)
        elseif choice == "guohechaiqiao" then
          room:useVirtualCard("dismantlement", nil, player, target, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 4)
        end
      else
        if choice == "wuzhongshengyou" then
          room:useVirtualCard("ex_nihilo", nil, player, player, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 1)
        elseif choice == "wuzhongshengyou" then
          local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
          if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = tiewan.name,
            prompt = "#tiewan_chai",
            cancelable = false,
            })
            if #tos > 0 then
              local targets = tos
              room:sortByAction(targets)
              room:useVirtualCard("dismantlement", nil, player, targets, tiewan.name, true)
              player:broadcastSkillInvoke(tiewan.name, 2)
            end
          end
        end
      end
     end
})

tiewan:addEffect(fk.Damaged, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"wuzhongshengyou", "Cancel"}
    if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
      if not player:isAllNude() then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_defense2",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    else
      local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
      if #targets > 0 then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_defense1",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    end
    end,
    on_use = function(self, event, target, player, data)
      local room = player.room
      local choice = event:getCostData(self).choice
      if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
        local target = player
        if choice == "wuzhongshengyou" then
          room:useVirtualCard("ex_nihilo", nil, player, target, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 7)
        elseif choice == "guohechaiqiao" then
          room:useVirtualCard("dismantlement", nil, player, target, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 8)
        end
      else
        if choice == "wuzhongshengyou" then
          room:useVirtualCard("ex_nihilo", nil, player, player, tiewan.name, true)
          player:broadcastSkillInvoke(tiewan.name, 5)
        elseif choice == "wuzhongshengyou" then
          local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
          if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = tiewan.name,
            prompt = "#tiewan_chai",
            cancelable = false,
            })
            if #tos > 0 then
              local targets = tos
              room:sortByAction(targets)
              room:useVirtualCard("dismantlement", nil, player, targets, tiewan.name, true)
              player:broadcastSkillInvoke(tiewan.name, 6)
            end
          end
        end
      end
     end
})

Fk:loadTranslationTable{["pang_tiewantongzhi"] = "铁腕统治",
  [":pang_tiewantongzhi"] = "当你造成或受到伤害后，你可以视为使用一张【无中生有】或【过河拆桥】；若你本回合发动过此技能，此牌的目标角色需为受到伤害的角色。",
  ["wuzhongshengyou"] = "无中生有",
  ["guohechaiqiao"] = "过河拆桥",
  ["tiewan_attack1"] = "你可以视为使用一张无中生有或过河拆桥",
  ["tiewan_attack2"] = "你可以视为对 %dest 使用一张无中生有或过河拆桥",
  ["tiewan_defense1"] = "你可以视为使用一张无中生有或过河拆桥",
  ["tiewan_defense2"] = "你可以视为对自己使用一张无中生有或过河拆桥",
}

return tiewan