local yinzhui = fk.CreateSkill {
  name = "pang_yinzhui",
  tags = {Skill.Switch},
}

local yinzhui_spec = {
anim_type = "switch",
    can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yinzhui.name)
    end,
    on_cost = function(self, event, target, player, data)
        if player:getSwitchSkillState(yinzhui.name, true) ~= fk.SwitchYang then
        if player.room:askToSkillInvoke(player, {
            skill_name = yinzhui.name,
            prompt = "#yinzhui1",})
        then 
            return true
        end
        else
            if player.room:askToSkillInvoke(player, {
            skill_name = yinzhui.name,
            prompt = "#yinzhui2",})
        then 
            return true
        end
        end
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
    local to = room.current
    if player:getSwitchSkillState(yinzhui.name, true) == fk.SwitchYang then
        local choices = {"max_card_buff", "yinzhui_drawcard"}
        local choice = room:askToChoice(player, {
            choices = choices,
            skill_name = yinzhui.name,
        })
        if choice == "max_card_buff" then
            room:addPlayerMark(to, "yinzhui_cardbuff-turn", 1)
        else
            to:drawCards(2)
        end
    else
        local choices = {"max_card_nerf", "yinzhui_discard"}
        local choice = room:askToChoice(player, {
            choices = choices,
            skill_name = yinzhui.name,
        })
        if choice == "max_card_nerf" then
            room:addPlayerMark(to, "yinzhui_cardnerf-turn", 1)
        else
            if #player:getCardIds("he") > 1 then
            local card_discard = room:askToDiscard(to, {
            skill_name = yinzhui.name,
            prompt = "#yinzhui_discard",
            cancelable = false,
            min_num = 2,
            max_num = 2,
            include_equip = true,
            })
            elseif #player:getCardIds("he") == 1 then
                local card_discard = player:getCardIds("he")
                room:throwCard(card_discard, yinzhui.name, to, to)
            end
        end
    end
  end,
}
yinzhui:addEffect(fk.CardUseFinished, yinzhui_spec)
yinzhui:addEffect(fk.CardRespondFinished, yinzhui_spec)

yinzhui:addEffect("maxcards", {
  correct_func = function(self, player)
    return -player:getMark("yinzhui_cardnerf-turn")
  end,
})

yinzhui:addEffect("maxcards", {
  correct_func = function(self, player)
    return player:getMark("yinzhui_cardbuff-turn")
  end,
})

Fk:loadTranslationTable {["pang_yinzhui"] = "音缀",
[":pang_yinzhui"] = "转换技，当你使用或打出一张牌后，你可以令当前回合角色①摸两张牌或本回合手牌上限+1②弃置两张牌或本回合手牌上限-1。",
["#yinzhui1"] = "你可以令当前回合角色执行一项增益",
["#yinzhui2"] = "你可以令当前回合角色执行一项减益",
["#yinzhui_discard"] = "弃置两张牌",
["max_card_buff"] = "当前回合角色手牌上限+1",
["yinzhui_drawcard"] = "当前回合角色摸两张牌",
["max_card_nerf"] = "当前回合角色手牌上限-1",
["yinzhui_discard"] = "当前回合角色弃置两张牌",
}

return yinzhui