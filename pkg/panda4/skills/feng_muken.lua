
Fk:loadTranslationTable{
  ["feng_muken"] = "募垦",
  [":feng_muken"] = "出牌阶段限一次，你可以正面向上将至多两张花色不同的牌交给任意名其他角色。直至你下回合开始时，这些角色使用与以获得牌花色相同的牌时你摸一张牌。",
  ["#feng_muken"] = "募垦：将至多两张花色不同的牌交给任意名其他角色",
  ["#muken_fenpei"] = "募垦：选择一名角色",
  ["#mufen_jiaochu::"] = "募垦：交给%dest任意张牌",
  ["@feng_muken"] = "募垦",

}

local muken = fk.CreateSkill{
  name = "feng_muken",
}

muken:addEffect("active", {
  anim_type = "support",
  min_card_num = 1,
  max_card_num = 2,
  target_num = 0,
  prompt = "#feng_muken",
  card_filter = function(self, player, to_select, selected)
    if #selected >= 2 then return false end
    local card = Fk:getCardById(to_select)
    return table.every(selected, function (id)
      return card.suit ~= Fk:getCardById(id).suit
    end)
    end,
  on_use = function(self, room, effect)
    local player = effect.from
    local cards = effect.cards
    local num = #cards
    local to1 = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = muken.name,
        prompt = "#muken_fenpei",
        cancelable = false,
    })
    local mark1 = to1[1]:getTableMark("@feng_muken")
    local suits = {}
    local suit = ""
    local card1 = room:askToYiji(player, {
      cards = cards,
      targets = to1[1],
      skill_name = muken.name,
      min_num = 1,
      max_num = num,
    })
    for _, info in ipairs(card1) do
            suit = Fk:getCardById(info.cardId):getSuitString(true)
            if suit ~= "log_nosuit" and not table.contains(mark1, suit) then
              table.insertIfNeed(suits, suit)
            end
    end
    num = num - #card1
    if num > 0 then
        local to2 = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getOtherPlayers(player, false),
        skill_name = muken.name,
        prompt = "#muken_fenpei",
        cancelable = false,
    })
    local mark2 = to2[1]:getTableMark("@feng_muken")
    local suits = {}
    local suit = ""
    local card2 = room:askToYiji(player, {
      cards = cards,
      targets = to2[1],
      skill_name = muken.name,
      min_num = 1,
      max_num = 1,
    })
    for _, info in ipairs(card2) do
            suit = Fk:getCardById(info.cardId):getSuitString(true)
            if suit ~= "log_nosuit" and not table.contains(mark2, suit) then
              table.insertIfNeed(suits, suit)
            end
    end
    end
  end,
})

muken:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(muken.name) and data.extra_data and data.extra_data.mukenCheck
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, muken.name)
  end,

  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(muken.name, true)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local suit = data.card:getSuitString(true)
    if suit == target:getTableMark("@feng_muken")[1] or suit == target:getTableMark("@feng_muken")[2] then
      data.extra_data = data.extra_data or {}
      data.extra_data.mukenCheck = true
    end
  end,
})
muken:addEffect(fk.TurnStart, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(muken.name)
  end,
  on_refresh = function(self, event, target, player, data)
    for _, p in ipairs(player.room.alive_players) do
      player.room:setPlayerMark(p, "@feng_muken", 0)

    end
  end,
})

return muken