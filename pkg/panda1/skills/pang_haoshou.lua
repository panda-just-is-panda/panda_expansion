local haoshou = fk.CreateSkill({
  name = "pang_haoshou", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory},
})

haoshou:addEffect(fk.EventPhaseStart, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local slash = Fk:cloneCard("slash")
    local choices = {"useduel", "Cancel"}
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return p:canUseTo(slash, player, {bypass_times = true}) and not p:isNude()
    end)
    if #targets > 0 then
      for _, tos in ipairs(targets) do
        local choice_made = room:askToChoice(tos, {
        choices = choices,
        prompt = "duel_question",
        skill_name = haoshou.name,
        })
        if choice_made ~= "Cancel" then
          local duel = Fk:cloneCard("duel")
          local cards = room:askToCards(tos, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            skill_name = haoshou.name,
            prompt = "duel_asking",
            cancelable = false,
          })
          duel:addSubcards(cards)
        room:useVirtualCard("duel", duel, tos, player, haoshou.name, true)
        if player:getMark("haoshou-turn") == 0 then
        room:addPlayerMark(player, "haoshou-turn", 1)
        end
    end
    end
  end
    if player:getMark("haoshou-turn") == 0 then
      local duel = Fk:cloneCard("duel")
      local targets2 = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(duel, p)
    end)
    local tos2 = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets2,
      skill_name = haoshou.name,
      prompt = "#haoshou2",
      cancelable = true,
    })
    if #tos2 > 0 then
        local targets = tos2
        room:sortByAction(targets)
    room:useVirtualCard("duel", nil, player, targets, haoshou.name, true)
    end
    end

end
})


Fk:loadTranslationTable {["pang_haoshou"] = "浩兽",
[":pang_haoshou"] = "准备阶段，攻击范围内包含你的其他角色依次可以将一张牌作为【决斗】对你使用；若没有角色如此做，你可以视为使用一张【决斗】。",
["useduel"] = "使用决斗",
["duel_asking"] = "将一张牌作为【决斗】对劫掠兽使用",
["duel_question"] = "你可以将一张牌作为【决斗】对劫掠兽使用",
["#haoshou2"] = "你可以视为使用一张【决斗】"
}
return haoshou  --不要忘记返回做好的技能对象哦