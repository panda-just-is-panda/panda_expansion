local kuizhu = fk.CreateSkill {
  name = "pang_kuizhu",
}

Fk:loadTranslationTable{
  ["pang_kuizhu"] = "溃诛",
  [":pang_kuizhu"] = "结束阶段，你可以弃置至多X名其他角色各一张牌，或对一名体力值为X的其他角色造成1点伤害（X为你此回合失去的牌数）。",

  ["#kuizhu-invoke"] = "溃诛：你可以选择一项",
  ["kuizhu_choice1"] = "弃置至多%arg名角色各摸一张牌",
  ["kuizhu_choice2"] = "对一名体力值为%arg的角色造成1点伤害",
  ["kuizhu_discard"] = "弃置%src一张牌",

  ["$pang_kuizhu1"] = "子通专恣，必谋而诛之！",
  ["$pang_kuizhu2"] = "孙綝久专，不可久忍，必溃诛！",
}

kuizhu:addEffect(fk.EventPhaseStart, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(kuizhu.name) and player.room.current == player and player.phase == Player.Finish and
      #player.room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
        for _, move in ipairs(e.data) do
          if move.from == player then
            return true
          end
        end
      end, Player.HistoryTurn) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local n = 0
    room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function(e)
      for _, move in ipairs(e.data) do
        if move.from == player then
          n = n + #move.moveInfo
        end
      end
    end, Player.HistoryTurn)
    local success, dat = room:askToUseActiveSkill(player, {
      skill_name = "kuizhu_active",
      prompt = "#kuizhu-invoke",
      cancelable = true,
      extra_data = {
        num = n,
      }
    })
    if success and dat then
      local tos = dat.targets
      room:sortByAction(tos)
      event:setCostData(self, {tos = tos, choice = dat.interaction})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(kuizhu.name)
    local targets = event:getCostData(self).tos
    local choice = event:getCostData(self).choice
    room:doIndicate(player, targets)
    if choice:startsWith("kuizhu_choice1") then
      room:notifySkillInvoked(player, kuizhu.name, "support")
      for _, p in ipairs(targets) do
        if not p.dead and not p:isNude() then
            local card1 = room:askToChooseCard(player, {
          target = p,
          skill_name = kuizhu.name,
          prompt = "kuizhu_discard:"..p.id,
          flag = "he",
            })
            room:throwCard(card1, kuizhu.name, p, player)
        end
      end
    else
      room:notifySkillInvoked(player, kuizhu.name, "offensive")
      for _, p in ipairs(targets) do
        if not p.dead then
          room:damage {
            from = player,
            to = p,
            damage = 1,
            skillName = kuizhu.name,
          }
        end
      end
    end
  end,
})

return kuizhu