local danding = fk.CreateSkill({
  name = "ying_danding", 
  tags = {}, 
})

Fk:loadTranslationTable {["ying_danding"] = "胆定",
[":ying_danding"] = "出牌阶段开始时，你可以令你本回合对一名其他角色使用的牌无次数限制且不可响应，然后其可以观看你的手牌并重铸其中两张。",
["#danding-choose"] = "胆定：你可以令你本回合对一名其他角色使用的牌无次数限制且不可响应",
["#danding-view"] = "胆定：重铸其中两张牌",
["#danding-invoke2"] = "胆定：你可以观看%dest的手牌并重铸其中两张"

}

danding:addEffect(fk.EventPhaseStart, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(danding.name) and
      player.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      targets = room:getOtherPlayers(player, false),
      min_num = 1,
      max_num = 1,
      prompt = "#danding-choose",
      skill_name = danding.name,
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, { to = to })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).to[1]
    room:addPlayerMark(to, "been_danding-turn", 1)
     if player.room:askToSkillInvoke(to, {
      skill_name = danding.name,
      prompt = "#danding-invoke2::"..player.id,
    }) then
        local card_data = {}
        table.insert(card_data, { "$Hand", player:getCardIds("h") })
        local cards = room:askToChooseCards(to, {
            target = player,
            min = 2,
            max = 2,
            flag = { card_data = card_data },
          skill_name = danding.name,
        })
        room:recastCard(cards, player, danding.name)
    end
  end,
})

danding:addEffect("targetmod", {
    bypass_times = function(self, player, skill, scope, card, to)
    return card and to and to:getMark("been_danding-turn") > 0
  end,
})

danding:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_refresh = function(self, event, target, player, data)
    return target == player and data.to:getMark("been_danding-turn") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    data.disresponsive = true
  end,
})



return danding