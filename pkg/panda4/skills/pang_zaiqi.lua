local zaiqi = fk.CreateSkill{
  name = "pang_zaiqi",
}

Fk:loadTranslationTable {
  ["pang_zaiqi"] = "再起",
  [":pang_zaiqi"] = "弃牌阶段结束时，若本回合进入弃牌堆的牌数不小于你的体力值，你可以视为使用一张【南蛮入侵】；当你使用【南蛮入侵】对其他角色造成伤害时，你可以防止此伤害并选择一项：和其各摸一张牌；你回复1点体力。",

  ["#zaiqi_prevent-invoke"] = "你可以防止对%dest造成的伤害并选择一项",
  ["zaiqi_recover"] = "回复1点体力",
  ["zaiqi_draw"] = "和%dest各摸一张牌",

  ["$pang_zaiqi1"] = "丞相助我！",
  ["$pang_zaiqi2"] = "起！",
}

zaiqi:addEffect(fk.EventPhaseEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(zaiqi.name) and player.phase == Player.Discard then
      local ids = {}
      local room = player.room
      room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function (e)
        for _, move in ipairs(e.data) do
          if move.toArea == Card.DiscardPile then
            for _, info in ipairs(move.moveInfo) do
              table.insertIfNeed(ids, info.cardId)
            end
          end
        end
      end, Player.HistoryTurn)
      local x = #ids
      if x > player.hp or x == player.hp then
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local savage_assault = Fk:cloneCard("savage_assault")
      local tos = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(savage_assault, p)
      end)
      local targets = tos
      room:sortByAction(targets)
      room:useVirtualCard("savage_assault", nil, player, targets, zaiqi.name, true)
  end,
})

zaiqi:addEffect(fk.DamageCaused, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zaiqi.name) and
      data.card and data.card.trueName == "savage_assault" and
      data.to ~= player
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = zaiqi.name,
      prompt = "#zaiqi_prevent-invoke::"..data.to.id,
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:preventDamage()
    local target = data.to
    local choices = {"zaiqi_draw::"..target.id}
    if player:isWounded() then
      table.insert(choices, 2, "zaiqi_recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = zaiqi.name,
    })
    if choice == "zaiqi_recover" then
      room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = zaiqi.name
      })
    else
        player:drawCards(1, zaiqi.name)
        target:drawCards(1, zaiqi.name)
    end
  end,
})

return zaiqi