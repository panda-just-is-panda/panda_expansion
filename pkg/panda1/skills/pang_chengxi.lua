
local chengxi = fk.CreateSkill({
  name = "pang_chengxi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

chengxi:addEffect(fk.TargetConfirming, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(chengxi.name) and data:isOnlyTarget(target) and not target:isNude() and
      data.from == player and player:usedSkillTimes(chengxi.name, Player.HistoryTurn) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = chengxi.name,
      prompt = "#pang_chengxi",
    })
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local from = data.player
    if not target:isNude() then
      local id = room:askToChooseCard(player, {
    min_num = 1,
    max_num = 1,      
    target = target,
    flag = "he",
    prompt = "#chengxi_chai",
    skill_name = chengxi.name,
  })
      room:throwCard(id, chengxi.name, target, player) 
      if player.dead or player:isNude() or target.dead then return end
      if #player:getPile("meilanni_qiao") > 0 and not target:isNude() then
        local id2 = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = chengxi.name,
      pattern = ".|.|.|meilanni_qiao",
      prompt = "#chengxi_obtain",
      cancelable = true,
      expand_pile = "meilanni_qiao",
    })
      room:moveCardTo(id2, Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, chengxi.name, nil, true, player)
      if player.dead or player:isNude() or target.dead then return end
      local cards2 = room:askToCards(target, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = chengxi.name,
        prompt = "#chengxi_obtain",
        cancelable = false,
      })
      room:obtainCard(player, cards2, false, fk.ReasonPrey)
end

    end
  end,
})

Fk:loadTranslationTable{["pang_chengxi"] = "乘隙",
  [":pang_chengxi"] = "每回合限一次，当你使用牌指定其他角色为唯一目标后，你可以弃置其一张牌，然后你可以移除一张“巧”并获得其一张牌。",
  ["#pang_chengxi"] = "乘隙：你可以弃置其一张牌,然后可移除巧并获得其一张牌",
  ["#chengxi_chai"] = "你可以弃置其一张牌",
  ["meilanni_qiao"] = "巧",
  ["#chengxi_obtain"] = "你可以移除一张”巧“并获得其一张牌",
}

return chengxi