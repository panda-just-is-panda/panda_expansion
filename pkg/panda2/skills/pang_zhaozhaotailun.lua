local zhaohan = fk.CreateSkill {
  name = "pang_zhaozhaotailun",
  tags = { Skill.Lord, Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_zhaozhaotailun"] = "昭昭泰伦",
  [":pang_zhaozhaotailun"] = "主公技，锁定技，游戏开始后的前X个准备阶段，你加1点体力上限并回复1点体力；之后的X个准备阶段，你减2点体力上限（X为场上蜀势力角色数）。",

  ["$pang_zhaozhaotailun1"] = "",
  ["$pang_zhaozhaotailun2"] = "",
}

zhaohan:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    local num = 0
    for _, p in ipairs(player.room:getAlivePlayers()) do
            if p.kingdom == "shu" then
                num = num + 1
            end
        end
    return
      target == player and
      player:hasSkill(zhaohan.name) and
      player.phase == Player.Start and
      player:usedSkillTimes(zhaohan.name, Player.HistoryGame) < num + num
  end,
  on_use = function(self, event, target, player, data)
    local skillName = zhaohan.name
    local room = player.room
    local num = 1
    for _, p in ipairs(player.room:getAlivePlayers()) do
            if p.kingdom == "shu" then
                num = num + 1
            end
    end
      room:notifySkillInvoked(player, skillName, "support")
      if player:usedSkillTimes(zhaohan.name, Player.HistoryGame) < num then
        room:changeMaxHp(player, 1)
        room:recover{
          who = player,
          num = 1,
          recoverBy = player,
          skillName = skillName,
        }
      else
        player.room:changeMaxHp(player, -2)
      end
  end,
})


return zhaohan