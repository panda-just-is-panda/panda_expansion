local fangquan = fk.CreateSkill {
  name = "pang_fangquan",
}

Fk:loadTranslationTable{
  ["pang_fangquan"] = "放权",
  [":pang_fangquan"] = "回合开始时，你可以将一张牌作为【乐不思蜀】对自己使用，然后此回合结束时，你可以令一名其他角色执行一个额外的回合。",
  ["#fangquan-le"] = "你可以将一张牌作为【乐不思蜀】对自己使用",
  ["#fangquan-choose"] = "放权：你可以令一名其他角色获得一个额外回合",

  ["$pang_fangquan1"] = "唉，这可如何是好啊！",
  ["$pang_fangquan2"] = "哎，你办事儿，我放心~",
}

fangquan:addEffect(fk.TurnStart, {
  anim_type = "support",
  audio_index = 1,
  can_trigger = function(self, event, target, player, data)
    local card = table.filter(player:getCardIds("he"), function(id)
        local card_pick = Fk:getCardById(id)
        return card_pick
        end)
    if player.room.current == player and target == player and player:hasSkill(fangquan.name)
    and not player:hasDelayedTrick("indulgence") 
    and not table.contains(player.sealedSlots, player.JudgeSlot)
    and #card > 0 then
        return true
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local to_select = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = fangquan.name,
      pattern = "he",
      prompt = "#fangquan-le",
      cancelable = true,
    })
        if #to_select > 0 then
            local card2 = Fk:cloneCard("indulgence")
      card2:addSubcards(to_select)
      if not player:prohibitUse(card2) and not player:isProhibited(player, card2) then
        room:useVirtualCard("indulgence", card2, player, player, fangquan.name)

      end
    end
  end,
})

fangquan:addEffect(fk.TurnEnd, {
  anim_type = "support",
  audio_index = 2,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:usedSkillTimes(fangquan.name, Player.HistoryTurn) > 0 and
      not player.dead and not player:isKongcheng() and
      #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room:getOtherPlayers(player, false),
      skill_name = fangquan.name,
      prompt = "#fangquan-choose",
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
    if not to.dead then
      to:gainAnExtraTurn(true, fangquan.name)
    end
  end,
})

return fangquan