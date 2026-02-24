local jizu = fk.CreateSkill {
  name = "ye_jizu",
}

jizu:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        local room = player.room
        if data.card and target:getMark("@jizu_block-turn") then
            for _, to in ipairs(room.alive_players) do
                room:setPlayerMark(to,"@jizu_block-turn", 0)
            end
        end
        if data.card and table.contains(data.card.skillNames, jizu.name) then
            for _, to in ipairs(room.alive_players) do
                room:setPlayerMark(to,"@jizu_block-turn", data.card:getColorString())
            end
        end
        if data.card and target == room.current and player:hasSkill(jizu.name) then
            room:setPlayerMark(player,"jizu_color_record-turn", data.card:getColorString())
        end
        return player:hasSkill(jizu.name) and data.card:getColorString() == player:getMark("jizu_color_record-turn")
        and player:usedSkillTimes(jizu.name, Player.HistoryTurn) == 0
    end,
    on_cost = function(self, event, target, player, data)
        local room = player.room
        local color = data.card:getColorString()
        room:setPlayerMark(player,"unique_jizu_block",color)
        local use = room:askToUseRealCard(player, {
            pattern = ".",
            skill_name = jizu.name,
            prompt = "#jizu_use",
            extra_data = {
                bypass_times = true,
                extraUse = true,
            }
        })
        room:setPlayerMark(player,"unique_jizu_block",0)
        if use then
            return true
        end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        player:drawCards(1, jizu.name)
        for _, to in ipairs(room.alive_players) do
            if to:hasSkill("ye_yaoxi") and player:hasSkill(jizu.name) then
                local to_move = room:askToChoosePlayers(to, {
                    min_num = 1,
                    max_num = 1,
                    targets = room:getOtherPlayers(player, false),
                    skill_name = "ye_yaoxi",
                    prompt = "#jizu_move:"..player.id,
                    cancelable = true,
                })
                if #to_move > 0 then
                    room:handleAddLoseSkills(player, "-ye_jizu", nil, true, false)
                    room:handleAddLoseSkills(to_move, "ye_jizu", nil, true, false)
                    if #player:getCardIds("hej") > 0 and to ~= player then
                        local card = room:askToChooseCard(to, {
                            target = player,
                            flag = "hej",
                            skill_name = "ye_yaoxi",
                        })
                        room:obtainCard(to, card, true, fk.ReasonPrey)
                        local to_distribute = room:askToChoosePlayers(to, {
                            min_num = 1,
                            max_num = 1,
                            targets = room:getOtherPlayers(to, false),
                            skill_name = "ye_yaoxi",
                            prompt = "#yaoxi_distribute",
                            cancelable = true,
                        })
                        if #to_distribute > 0 then
                            room:obtainCard(to_distribute, card, true, fk.ReasonGive)
                        end
                    end
                end
            end
        end
    end,
})

jizu:addEffect("prohibit",{
  prohibit_use = function (self, player, card)
    if player:getMark("@jizu_block-turn") then
      return card:getColorString() == player:getMark("@jizu_block-turn")
    end
    if player:getMark("unique_jizu_block") then
      return card:getColorString() == player:getMark("unique_jizu_block")
    end
  end,
})



Fk:loadTranslationTable {["ye_jizu"] = "急阻",
[":ye_jizu"] = "每回合限一次，当前回合角色连续使用同色的牌结算后，你可使用一张不同色的牌并摸一张牌，此牌结算后本回合下一张使用的牌须与此牌颜色不同。",
["@jizu_block-turn"] = "急阻",
["#jizu_use"] = "急阻：你可以使用一张不同色的牌",
["#jizu_move"] = "谣隙：你可移动“急阻”，然后获得并分配 %src 区域内的一张牌",
["cancel_choose"] = "取消",
["#yaoxi_distribute"] = "谣隙：你可以将此牌交给一名其他角色，或点取消保留此牌",

}

return jizu