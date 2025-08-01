local cuijin = fk.CreateSkill{
  name = "hua_cuijin",
}

Fk:loadTranslationTable{
  ["hua_cuijin"] = "催进",
  [":hua_cuijin"] = "出牌阶段各限一次，你可以明置一名角色至多四张手牌，并令其使用这些牌时无次数限制或伤害基数+1。其回合结束时，弃置这些牌。",

  ["#hua_cuijin"] = "催进：你可以明置一名角色至多四张手牌并令这些牌获得你选择的一项效果",
  ["#cuijin-show"] = "催进：明置%dest的至多四张手牌",
  ["wucishu"] = "令这些牌无次数限制",
  ["damageplus"] = "令这些牌伤害基数+1",
  ["@@shanghai-inhand"] = "伤害+1",
  ["@@cishu-inhand"] = "无次数限制",

}

local DIY = require "packages/diy_utility/diy_utility"

cuijin:addEffect("active", {
  anim_type = "control",
  card_num = 0,
  target_num = 1,
  prompt = "#hua_cuijin",
  can_use = function(self, player)
    return player:getMark("cuijin_cishu-phase") == 0 
    or player:getMark("cuijin_shanghai-phase") == 0
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    local cards = table.filter(to_select:getCardIds("h"), function (id)
        return not table.contains(DIY.getShownCards(to_select), id)
      end)
    return #selected == 0 and #cards > 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local to = target
    local card_chosen
    local cards = table.filter(to:getCardIds("h"), function (id)
        return not table.contains(DIY.getShownCards(to), id)
      end)
    if target == player then
      card_chosen = room:askToCards(player, {
        target = target,
        min_num = 1,
        max_num = 4,
        include_equip = false,
        pattern = tostring(Exppattern{ id = cards }),
        kill_name = cuijin.name,
      })
      DIY.showCards(target, card_chosen)
    else
        local card_data, extra_data, visible_data = {}, {}, {}
        table.insert(card_data, {"$Hand", cards})
        for _, id in ipairs(cards) do
          if not player:cardVisible(id) then
            visible_data[tostring(id)] = false
          end
        end
        if next(visible_data) == nil then visible_data = nil end
        extra_data.visible_data = visible_data
        extra_data.min = 1
        extra_data.max = 4
        extra_data.prompt = "#cuijin-show::"..to.id
        local result = room:askToPoxi(player, {
          poxi_type = "AskForCardsChosen",
          data = card_data,
          extra_data = extra_data,
          cancelable = false,
        })
        DIY.showCards(to, result)
        card_chosen = result
    end
    local choices = {}
    if player:getMark("cuijin_shanghai-phase") == 0 then
        table.insert(choices, 1, "damageplus")
    end
    if player:getMark("cuijin_cishu-phase") == 0 then
        table.insert(choices, 1, "wucishu")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = cuijin.name,
    })
    if choice == "damageplus" then
        room:addPlayerMark(player, "cuijin_shanghai-phase", 1)
        for _, id in ipairs(card_chosen) do
            room:setCardMark(Fk:getCardById(id), "@@shanghai-inhand", 1)
        end
    else
        room:addPlayerMark(player, "cuijin_cishu-phase", 1)
        for _, id in ipairs(card_chosen) do
            room:setCardMark(Fk:getCardById(id), "@@cishu-inhand", 1)
        end
    end
  end,
})

cuijin:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  global = true,
  can_refresh = function(self, event, target, player, data)
    return target == player and (data.extra_data or {}).usingcuijin
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    data.additionalDamage = (data.additionalDamage or 0) + 1
  end,
})
cuijin:addEffect(fk.PreCardUse, {
    global = true,
    can_refresh = function (self, event, target, player, data)
        return target == player and data.card:getMark("@@shanghai-inhand") > 0
    end,
    on_refresh = function (self, event, target, player, data)
        data.extra_data = data.extra_data or {}
        data.extra_data.usingcuijin = true
    end,
})

cuijin:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and card:getMark("@@cishu-inhand") > 0
  end,
})

cuijin:addEffect(fk.TurnEnd, {
  mute = true,
  is_delay_effect = true,
  can_refresh = function(self, event, target, player, data)
    return table.find(target:getCardIds("h"), function(id)
        return Fk:getCardById(id):getMark("@@cishu-inhand") > 0 and not player:prohibitDiscard(id)
        or Fk:getCardById(id):getMark("@@shanghai-inhand") > 0 and not player:prohibitDiscard(id)
      end)
  end,
  on_refresh = function (self, event, target, player, data)
    local room = player.room
    local ids = table.filter(player:getCardIds("h"), function(id)
      return Fk:getCardById(id):getMark("@@cishu-inhand") > 0 and not player:prohibitDiscard(id)
        or Fk:getCardById(id):getMark("@@shanghai-inhand") > 0 and not player:prohibitDiscard(id)
    end)
    room:throwCard(ids, cuijin.name, target, target)
  end,
})

return cuijin