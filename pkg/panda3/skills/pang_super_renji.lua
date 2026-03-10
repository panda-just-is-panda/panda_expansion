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
    local random = math.random(1, 5)
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
      room:drawCards(player, 5, renji.name)
    elseif random == 3 then
      room:recover{
        who = player,
        num = 2,
        recoverBy = player,
        skillName = renji.name
      }
      room:drawCards(player, 2, renji.name)
    elseif random == 4 then
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = renji.name,
        prompt = "#super_renji_prompt",
        cancelable = false,
      })
      local cards
      local cards2
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
      if #cards2 > 0 then
        room:throwCard(cards2, renji.name, to, player)
      end
      if #cards > 0 then
        room:throwCard(cards, renji.name, to, player)
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

Fk:loadTranslationTable {["pang_super_renji"] = "人机",
[":pang_super_renji"] = "持恒技，锁定技，准备阶段，你随机执行一项：依次视为使用两张无距离限制的【杀】；摸五张牌；回复2点体力并摸两张牌；弃置一名其他角色四张牌。",
["#super_renji_prompt"] = "如果你能看到这条信息，那我问你：为什么不ban质检员？",



}

return renji