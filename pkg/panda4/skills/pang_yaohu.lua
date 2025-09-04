local yaohu = fk.CreateSkill({
  name = "pang_yaohu", 
  tags = {}, 
})


Fk:loadTranslationTable{
  ["pang_yaohu"] = "邀虎",
  [":pang_yaohu"] = "当你使用一张【杀】或【闪】后，你可以令一名有牌的其他角色选择一项：交给你一张牌；使用一张【杀】（无距离限制）。",

  ["#yaohu-choose"] = "邀虎：你可以令一名角色交给你一张牌或使用一张【杀】",
  ["#yaohu_choose"] = "邀虎：你需使用一张【杀】（无距离限制），否则交给%src一张牌",
  ["#yaohu_give"] = "邀虎：你需交给%src一张牌",

  ["$pang_yaohu1"] = "益州疲敝，还望贤兄相助。",
  ["$pang_yaohu2"] = "内讨米贼，外拒强曹，璋无宗兄万万不可啊。",
}

yaohu:addEffect(fk.CardUseFinished, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yaohu.name) and (data.card.trueName == "slash" or data.card.trueName == "jink")
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local targets = {}
    for _, p in ipairs(room:getOtherPlayers(player, false)) do
        if not p:isNude() then
          table.insert(targets, 1, p)
        end
    end
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = yaohu.name,
      prompt = "#yaohu-choose",
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local use = room:askToUseCard(to, {
        skill_name = yaohu.name,
        pattern = "slash",
        prompt = "#yaohu_choose:"..player.id,
        extra_data = {
        bypass_times = true,
        bypass_distances = true,
        }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
    else
        local card = room:askToCards(to, {
          skill_name = yaohu.name,
          prompt = "#yaohu_give:"..player.id,
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = true,
        })
        room:obtainCard(player, card, false, fk.ReasonGive)
    end
  end,
})





return yaohu