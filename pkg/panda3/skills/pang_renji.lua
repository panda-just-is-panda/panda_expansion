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
      local cards
      local cards2
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
      if #cards2 > 0 then
        room:throwCard(cards2, renji.name, to, player)
      end
      if #cards > 0 then
        room:throwCard(cards, renji.name, to, player)
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
end)

renji:addEffect(fk.AskForPeachesDone, {
  can_refresh = function(self, event, target, player, data)
    return data.who == player and player:hasSkill(renji.name, true, true) and player.hp <= 0
  end,
  on_refresh = function(self, event, target, player, data)
    player:chat("你过关。")
  end
})

Fk:loadTranslationTable {["pang_renji"] = "人机",
[":pang_renji"] = "锁定技，准备阶段，你随机执行一项：视为使用一张无距离限制的【杀】；摸两张牌；回复1点体力并摸一张牌；弃置一名其他角色两张牌。",
["#renji_prompt"] = "如果你能看到这条信息，那我问你：为什么不ban质检员？",


}

return renji