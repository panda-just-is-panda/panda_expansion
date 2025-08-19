local U = require "packages/utility/utility"

Fk:loadTranslationTable{
  ["pang_rende"] = "仁德",
  [":pang_rende"] = "出牌阶段每名角色限一次，你可以将任意张手牌交给一名其他角色；每阶段你以此法给出至少两张牌后，你可以令一名角色视为使用一张基本牌。",
  ["#pang_rende"] = "仁德：将任意张手牌交给一名角色，若此阶段交出达到两张，你可以令一名角色视为使用一张基本牌",

  ["#pang_rende-ask"] = "仁德：你可视为使用一张基本牌",
  ["#rende-choose"] = "仁德：令一名角色可以视为使用一张基本牌",

  ["$pang_rende1"] = "仁德为政，自得民心！",
  ["$pang_rende2"] = "民心所望，乃吾政所向！",
}

local rende = fk.CreateSkill{
  name = "pang_rende",
}

rende:addEffect("active", {
  anim_type = "support",
  min_card_num = 1,
  target_num = 1,
  prompt = "#pang_rende",
  card_filter = function(self, player, to_select, selected)
    return table.contains(player:getCardIds("h"), to_select)
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not table.contains(player:getTableMark("ex__rende-phase"), to_select.id)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local cards = effect.cards
    room:addTableMark(player, "ex__rende-phase", target.id)
    local n = player:getMark("ex__rende_num-phase")
    room:moveCardTo(cards, Player.Hand, target, fk.ReasonGive, rende.name, nil, false, player)
    room:addPlayerMark(player, "ex__rende_num-phase", #cards)
    if n < 2 and n + #cards >= 2 then
      cards = U.getUniversalCards(room, "b")
      local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room.alive_players,
      skill_name = rende.name,
      prompt = "#rende-choose",
      cancelable = true,
    })
      local use = room:askToUseRealCard(tos[1], {
        pattern = cards,
        skill_name = rende.name,
        prompt = "#pang_rende-ask",
        extra_data = {
          bypass_times = true,
          extraUse = true,
          expand_pile = cards,
        },
        cancelable = true,
        skip = true,
      })
      if use then
        local card = Fk:cloneCard(use.card.name)
        card.skillName = rende.name
        room:useCard{
          from = player,
          tos = use.tos,
          card = card,
        }
      end
    end
  end,
})

return rende