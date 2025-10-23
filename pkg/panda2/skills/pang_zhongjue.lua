local zhongjue = fk.CreateSkill {
  name = "pang_zhongjue",
  tags = {  },
}

Fk:loadTranslationTable {
  ["pang_zhongjue"] = "终决",
  [":pang_zhongjue"] = "你失去过【杀】的阶段结束时或你即将死亡时，你可以视为使用一张无距离限制的火【杀】。",
  ["#zhongjue_choose"] = "终决：视为对一名角色使用一张火【杀】",
  ["#zhongjue-invoke"] = "终决：你可以视为对一名角色使用一张火【杀】",
  ["@@zhongjue"] = "终决-已失去【杀】",
}

zhongjue:addEffect(fk.AskForPeachesDone, {
  can_trigger = function(self, event, target, player, data)
    return data.who == player and player:hasSkill("yy__pilang") and player.hp <= 0
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = zhongjue.name,
      prompt = "#zhongjue-invoke",
    }) then
    return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local slash = Fk:cloneCard("slash")
    local max_num = slash.skill:getMaxTargetNum(player, slash)
    local targets = room:getOtherPlayers(player, false)
    if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = max_num,
        targets = targets,
        skill_name = zhongjue.name,
        prompt = "#zhongjue_choose",
        cancelable = false,
        })
        if #tos > 0 then
            local targets = tos
            room:sortByAction(targets)
            room:useVirtualCard("fire__slash", nil, player, targets, zhongjue.name, true)
        end
    end
  end,
})

zhongjue:addEffect(fk.AfterCardsMove, {
  can_refresh = function(self, event, target, player, data)
    local test = 0
    if player:hasSkill(zhongjue.name) then
      for _, move in ipairs(data) do
        if move.from == player then
            for _, info in ipairs(move.moveInfo) do
              if Fk:getCardById(info.cardId).trueName == "slash" then
                test = 1
              end
            end
          end
        end
      if test == 1 then
        return true
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "zhongjue-phase", 1)
    room:addPlayerMark(player, "@@zhongjue")
  end,
})

zhongjue:addEffect(fk.EventPhaseEnd, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zhongjue.name, false, true) and
    player:getMark("zhongjue-phase") > 0
  end,
  on_cost = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@zhongjue", 0)
    if player.room:askToSkillInvoke(player, {
      skill_name = zhongjue.name,
      prompt = "#zhongjue-invoke",
    }) then
    return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local slash = Fk:cloneCard("slash")
    local max_num = slash.skill:getMaxTargetNum(player, slash)
    local targets = room:getOtherPlayers(player, false)
    if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = max_num,
        targets = targets,
        skill_name = zhongjue.name,
        prompt = "#zhongjue_choose",
        cancelable = false,
        })
        if #tos > 0 then
            local targets = tos
            room:sortByAction(targets)
            room:useVirtualCard("fire__slash", nil, player, targets, zhongjue.name, true)
        end
    end
  end,
})

return zhongjue