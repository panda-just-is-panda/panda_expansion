local yaoxi = fk.CreateSkill{
  name = "ye_yaoxi",
  tags = {},
}

yaoxi:addEffect(fk.GameStart, {
    can_trigger = function(self, event, target, player, data)
        return player:hasSkill(yaoxi.name)
    end,
    on_cost = function(self, event, target, player, data)
        local room = player.room
        local to_distribute = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = room.alive_players,
            skill_name = "ye_yaoxi",
            prompt = "#yaoxi_select",
            cancelable = false,
        })
        event:setCostData(self, {tos = to_distribute})
        return true
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local to = event:getCostData(self).tos[1]
        room:handleAddLoseSkills(to, "ye_jizu", nil, false, true)
  end,
})

yaoxi:addEffect(fk.TurnStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yaoxi.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    for _, to in ipairs(room.alive_players) do
        if to:hasSkill("ye_jizu") and player:hasSkill(yaoxi.name) then
            local to_move = room:askToChoosePlayers(player, {
                min_num = 1,
                max_num = 1,
                targets = room:getOtherPlayers(to, false),
                skill_name = "ye_yaoxi",
                prompt = to == player and "#yaoxi_move2" or "#yaoxi_move:"..to.id,
                cancelable = true,
            })
            if #to_move > 0 then
                event:setCostData(self, {tos = {to, to_move[1]}})
                return true
            end
        end
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local to_lose = event:getCostData(self).tos[1]
    local to_get = event:getCostData(self).tos[2]
    room:handleAddLoseSkills(to_lose, "-ye_jizu", nil, false, true)
    room:handleAddLoseSkills(to_get, "ye_jizu", nil, false, true)
    if #to_lose:getCardIds("hej") > 0 and to_lose ~= player
    or #to_lose:getCardIds("ej") > 0 then
        local card = room:askToChooseCard(player, {
            target = to_lose,
            flag = to_lose ~= player and "hej" or "ej",
            skill_name = "ye_yaoxi",
        })
        room:obtainCard(player, card, true, fk.ReasonPrey)
        local to_distribute = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = room:getOtherPlayers(player, false),
            skill_name = "ye_yaoxi",
            prompt = "#yaoxi_distribute",
            cancelable = true,
        })
        if #to_distribute > 0 then
            room:obtainCard(to_distribute[1], card, false, fk.ReasonGive)
        end
    end
  end,
})



Fk:loadTranslationTable {["ye_yaoxi"] = "谣隙",
[":ye_yaoxi"] = "游戏开始时，你令一名角色获得“急阻”。你回合开始时或“急阻”发动后，你可移动“急阻”，然后你获得并分配因此失去技能的角色区域内一张牌。",
["#yaoxi_select"] = "谣隙：令一名角色获得“急阻",
["#yaoxi_move"] = "谣隙：你可移动“急阻”，然后获得并分配 %src 区域内的一张牌",
["#yaoxi_move2"] = "谣隙：你可移动“急阻”，然后获得并分配自己场上的一张牌",
["#yaoxi_distribute"] = "谣隙：你可以将此牌交给一名其他角色，或点取消保留此牌",
}

return yaoxi