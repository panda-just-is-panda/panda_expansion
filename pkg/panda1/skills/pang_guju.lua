local guju = fk.CreateSkill({
  name = "pang_guju", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

guju:addEffect(fk.EventPhaseStart, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if player.room:askToSkillInvoke(player, {
      skill_name = guju.name,
      prompt = "#pang_guju",
    }) then
    local choices = {"guju_beng", "Cancel"}
    local cards_player = player:getCardIds("he")
    if #cards_player > 1 then
      table.insert(choices, 1, "guju_qizhi")
    end
        local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = guju.name,
    })
    if choice == "guju_qizhi" then
        local card = room:askToDiscard(player, {
          skill_name = guju.name,
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = true,
        })
        if not player.dead then
        return true
        end
    elseif choice == "guju_beng" then
        room:loseHp(player, 1, guju.name)
        if not player.dead then
        return true
        end
    end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choices_pick = {}
    local choices2 = {"guju_qiangming","guju_juli", "draw1"}
     local choice2 = room:askToChoice(player, {
      choices = choices2,
      skill_name = guju.name,
    })
    table.insert(choices_pick, choice2)
    table.removeOne(choices2, choice2)
    choice3 = room:askToChoice(player, {
      choices = choices2,
      skill_name = guju.name,
    })
    table.insert(choices_pick, choice3)
     if table.contains(choices_pick, "guju_qiangming") then
        room:addPlayerMark(player, "guju_qiangming-turn", 1)
     end
     if table.contains(choices_pick, "guju_juli") then
        room:addPlayerMark(player, "guju_juli-turn", 1)
     end
     if table.contains(choices_pick, "draw1") then
        player:drawCards(1, guju.name)
     end
  end
})

guju:addEffect("targetmod", {
  bypass_distances =  function(self, player, skill)
    return player:getMark("guju_juli-turn") > 0
  end,
})

guju:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  cancelable = false,
  prompt = "qiangming_trigger",
  can_trigger = function(self, event, target, player, data)
    return target == player and
    (data.card.trueName == "slash" or data.card:isCommonTrick()) and 
    player:getMark("guju_qiangming-turn") > 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data.disresponsiveList = room:getOtherPlayers(player, false)
  end,
})


Fk:loadTranslationTable {["pang_guju"] = "骨狙",
[":pang_guju"] = "出牌阶段开始时，你可以失去1点体力或弃置一张牌，然后你依次选择两项：本回合使用牌无距离限制；本回合使用牌时可令此牌不能被响应；摸一张牌。",
["#pang_guju"] = "你可以发动“骨狙”",
["guju_beng"] = "失去体力",
["guju_qizhi"] = "弃牌",
["guju_qiangming"] = "使用牌不能被响应",
["guju_juli"] = "使用牌无距离限制",
["draw1"] = "摸一张牌",
["qiangming_trigger"] = "你可以令此牌不能被响应",
}
return guju  --不要忘记返回做好的技能对象哦