local renji = fk.CreateSkill {
  name = "pang_super_renji",
    tags = {Skill.Compulsory},
}

renji:addEffect(fk.EventPhaseStart, {
anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(renji.name) and (target.phase == Player.Start or target.phase == Player.Finish)
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
      room:drawCards(player, 10, renji.name)
    elseif random == 3 then
      room:recover{
        who = player,
        num = 3,
        recoverBy = player,
        skillName = renji.name
      }
      room:drawCards(player, 5, renji.name)
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
      to = to[1]
      if not to:isNude() then
        cards = room:askToChooseCards(player, {
          target = to,
          min = 5,
          max = 5,
          flag = "he",
          skill_name = renji.name,
          prompt = "#super_renji_prompt",
          cancelable = false,
        })
      end
      if #cards > 0 then
        room:throwCard(cards, renji.name, to, player)
      end
    else
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = renji.name,
        prompt = "#super_renji_prompt",
        cancelable = false,
      })
      to = to[1]
    room:damage{
        from = player,
        to = to,
        damage = 2,
        skillName = renji.name,
    }
    end
  end,
})

renji:addEffect(fk.Death, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(renji.name, true, true)
  end,
  on_refresh = function(self, event, target, player, data)
    player:chat("吓哭了，什么仙界设计")
  end
})

Fk:loadTranslationTable {["pang_super_renji"] = "人机",
[":pang_super_renji"] = "持恒技，锁定技，准备阶段和结束阶段，你随机执行一项：依次视为使用四张无距离限制的【杀】；摸十张牌；回复3点体力并摸五张牌；弃置一名其他角色五张牌；对一名其他角色造成2点伤害。",
["#super_renji_prompt"] = "如果你能看到这条信息，那我问你：为什么不ban质检员？",



}

return renji