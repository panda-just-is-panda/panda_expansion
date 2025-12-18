local fenwu = fk.CreateSkill{
  name = "pang_fenwu",
}

Fk:loadTranslationTable{
  ["pang_fenwu"] = "焚舞",
  [":pang_fenwu"] = "出牌阶段限一次，你可以依次视为使用三张【火攻】；因此展示的牌本回合视为无距离限制的火【杀】。",

  ["#pang_fenwu"] = "焚舞：你可以依次视为使用三张【火攻】",
  ["#fire_choose1"] = "焚舞：视为使用一张【火攻】（第一张）",
  ["#fire_choose2"] = "焚舞：视为使用一张【火攻】（第二张）",
  ["#fire_choose3"] = "焚舞：视为使用一张【火攻】（第三张）",

  ["$pang_fenwu1"] = "！",
  ["$pang_fenwu2"] = "！",
}

fenwu:addEffect("active", {
  anim_type = "offensive",
  card_num = 0,
  target_num = 0,
  prompt = "#pang_fenwu",
  max_phase_use_time = 1,
  on_use = function(self, room, effect)
    local player = effect.from
    local room = player.room
    local fire = Fk:cloneCard("fire_attack")
    local targets = table.filter(Fk:currentRoom().alive_players, function (p)
        return player:canUseTo(fire, p, {bypass_times = true})
    end)
    if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = fenwu.name,
        prompt = "#fire_choose1",
        cancelable = false,
        })
        if #tos > 0 then
            local target2 = tos
            room:sortByAction(target2)
            room:useVirtualCard("fire_attack", nil, player, target2, fenwu.name, true)
        end
        local tos2 = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = fenwu.name,
        prompt = "#fire_choose2",
        cancelable = false,
        })
        if #tos2 > 0 then
            local target2 = tos2
            room:sortByAction(target2)
            room:useVirtualCard("fire_attack", nil, player, target2, fenwu.name, true)
        end
        local tos2 = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = fenwu.name,
        prompt = "#fire_choose3",
        cancelable = false,
        })
        if #tos2 > 0 then
            local target2 = tos2
            room:sortByAction(target2)
            room:useVirtualCard("fire_attack", nil, player, target2, fenwu.name, true)
        end
    end
  end,
})

fenwu:addEffect(fk.CardShown, {
  can_refresh = function(self, event, target, player, data)
    if target == player then
      local e = player.room.logic:getCurrentEvent():findParent(GameEvent.UseCard)
      if e then
        return table.contains(e.data.card.skillNames, fenwu.name)
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    for _, id in ipairs(data.cardIds) do
      if table.contains(player:getCardIds("h"), id) then
        room:setCardMark(Fk:getCardById(id), "pang_fenwu-turn", 1)
      end
    end
  end,
})

fenwu:addEffect("filter", {
  card_filter = function(self, to_select, player)
    return to_select and to_select:getMark("pang_fenwu-turn") > 0
  end,
  view_as = function(self, player, to_select)
    local card = Fk:cloneCard("fire__slash", to_select.suit, to_select.number)
    card.skillName = fenwu.name
    return card
  end,
})

fenwu:addEffect("targetmod", {
  bypass_distances =  function(self, player, skill, card, to)
    return card and card:getMark("pang_fenwu-turn") > 0
  end,
})




return fenwu