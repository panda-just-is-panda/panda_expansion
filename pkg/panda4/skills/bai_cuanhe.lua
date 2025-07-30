local cuanhe = fk.CreateSkill{
  name = "bai_cuanhe",
}

Fk:loadTranslationTable{
  ["bai_cuanhe"] = "攒和",
  [":bai_cuanhe"] = "当你需要使用基本牌时，你可以依次与手牌数相差一、二、三的其他角色交换手牌，若因此交换了三次，你视为使用之；若你手牌数未减少，此技能本轮失效。",

  ["#bai_cuanhe1"] = "你可以和一名手牌数相差一的其他角色交换手牌",
  ["#bai_cuanhe2"] = "你可以和一名手牌数相差二的其他角色交换手牌",
  ["#bai_cuanhe3"] = "你可以和一名手牌数相差三的其他角色交换手牌",
  ["@@cuanhe"] = "攒和失效"

}

cuanhe:addEffect("viewas", {
  pattern = ".|.|.|.|.|basic",
  interaction = function(self, player)
    local all_names = Fk:getAllCardNames("b")
    local names = player:getViewAsCardNames(cuanhe.name, all_names, nil)
    if #names == 0 then return end
    return UI.CardNameBox {choices = names, all_names = all_names}
  end,
  view_as = function(self, player, cards)
    if self.interaction.data == nil or self.interaction.data == "" then return end
    local card = Fk:cloneCard(self.interaction.data)
    card.skillName = cuanhe.name
    return card
  end,
  before_use = function (self, player, use)
    local room = player.room
    local card_preuse_num = #player:getCardIds("h")
    local valid_targets1 = table.filter(room:getOtherPlayers(player, false), function (p)
      return #player:getCardIds("h") - #p:getCardIds("h") == 1 or #p:getCardIds("h") - #player:getCardIds("h") == 1
    end)
    if #valid_targets1 > 0 then
        local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = valid_targets1,
            skill_name = cuanhe.name,
            prompt ="#bai_cuanhe1",
            cancelable = true,
        })
        if #tos > 0 then
            local victim1 = {player, tos[1]}
            room:addPlayerMark(player, "cuanhe_used-turn", 1)
            room:swapAllCards(player, victim1, cuanhe.name)
            local valid_targets2 = table.filter(room:getOtherPlayers(player, false), function (p)
            return #player:getCardIds("h") - #p:getCardIds("h") == 2 or #p:getCardIds("h") - #player:getCardIds("h") == 2
            end)
            if #valid_targets2 > 0 then
                local tos2 = room:askToChoosePlayers(player, {
                min_num = 1,
                max_num = 1,
                targets = valid_targets2,
                skill_name = cuanhe.name,
                prompt ="#bai_cuanhe2",
                cancelable = true,
                })
                if #tos2 > 0 then
                    local victim2 = {player, tos2[1]}
                    room:addPlayerMark(player, "cuanhe_used-turn", 1)
                    room:swapAllCards(player, victim2, cuanhe.name)
                    local valid_targets3 = table.filter(room:getOtherPlayers(player, false), function (p)
                    return #player:getCardIds("h") - #p:getCardIds("h") == 3 or #p:getCardIds("h") - #player:getCardIds("h") == 3
                    end)
                    if #valid_targets3 > 0 then
                        local tos3 = room:askToChoosePlayers(player, {
                        min_num = 1,
                        max_num = 1,
                        targets = valid_targets3,
                        skill_name = cuanhe.name,
                        prompt ="#bai_cuanhe3",
                        cancelable = true,
                        })
                        if #tos3 > 0 then
                            local victim3 = {player, tos3[1]}
                            room:addPlayerMark(player, "cuanhe_used-turn", 1)
                            room:swapAllCards(player, victim3, cuanhe.name)
                        else
                            player.room:setPlayerMark(player, "cuanhe_used-turn", 0)
                        end
                    end
                else
                    player.room:setPlayerMark(player, "cuanhe_used-turn", 0)
                end
            end
        else
            player.room:setPlayerMark(player, "cuanhe_used-turn", 0)
        end
    end
    if player:getMark("cuanhe_used-turn") < 3 then
        return cuanhe.name
    else
        player:drawCards(1)
    end 
    if not #player:getCardIds("h") < card_preuse_num then
        room:invalidateSkill(player, cuanhe.name, "-round")
    end
  end,
  enabled_at_play = function(self, player)
    return true
  end,
  enabled_at_response = function(self, player, response)
    return not response
  end,
})



return cuanhe