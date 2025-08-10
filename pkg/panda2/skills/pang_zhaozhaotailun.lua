local zhaohan = fk.CreateSkill {
  name = "pang_zhaozhaotailun",
  tags = { Skill.Lord, Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_zhaozhaotailun"] = "昭昭泰伦",
  [":pang_zhaozhaotailun"] = "主公技，锁定技，游戏开始后的前X个准备阶段，你加1点体力上限并回复1点体力；之后的X个准备阶段，你减2点体力上限（X为场上蜀势力角色数）。",

  ["$pang_zhaozhaotailun1"] = "我已经驯服了异虫，荡平了星灵。如今他们的创造者想要夺走我们应有的一切。永远记住，谁才是最能保护你们的人。",
  ["$pang_zhaozhaotailun2"] = "激进分子和异见者希望你们一听见枪声就背弃多年的和平与繁荣。他们没有勇气和能力带领人类穿越一个充满危险的星系。",
  ["$pang_zhaozhaotailun3"] = "凯莫瑞安联合体的经济崩溃迫在眉睫。对于所有想要离开那片废土去寻找更美好生活的人来说，克哈是你们所有人安全的港湾。",
  ["$pang_zhaozhaotailun4"] = ".为了保护尤摩杨人民不受异虫的残害，我所做的比他们自己的领导委员会都多。无论他们如何诽谤我，我将继续为所有泰伦人的最大利益而努力奋斗。",
  ["$pang_zhaozhaotailun5"] = "身为你们的元首，我带领泰伦人实现了人类统治领地和经济的扩张。我们将继续成长，用行动回击那些只会说风凉话，不愿意和我们相向而行的害群之马。",
  ["$pang_zhaozhaotailun6"] = "帝国武装力量，无数的优秀儿女，正时刻守卫着我们的家园大门，但是他们孤木难支。凡是今天应征入伍者，所获的所有刑罚罪责，减半。",
  ["$pang_zhaozhaotailun7"] = "法治，是我们的命脉，然而它却受到前所未有的挑战。我将恢复我们帝国的荣光，绝不会向任何外星势力低头。",
  ["$pang_zhaozhaotailun8"] = "不要听信别人的谗言，我不是什么克隆人。",
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