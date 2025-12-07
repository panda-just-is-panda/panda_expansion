local ciyong = fk.CreateSkill({
  name = "pang_ciyong", 
  tags = {}, 
})

ciyong:addEffect("viewas", {
    mute_card = false,
    pattern = "slash,jink",
    prompt = "#ciyong",
    interaction = function(self, player)
        local names = player:getViewAsCardNames(ciyong.name, {"thunder__slash", "jink"})
        return UI.CardNameBox {choices = names, all_choices = {"thunder__slash", "jink"}}
    end,
    card_filter = Util.FalseFunc,
    view_as = function(self)
        if not self.interaction.data then return end
        local card = Fk:cloneCard(self.interaction.data)
        card.skillName = ciyong.name
        return card
    end,
    before_use = function (self, player, use)
        local room = player.room
        local x = player:usedSkillTimes(ciyong.name, Player.HistoryGame)
        local not_chained = {}
        for _, p in ipairs(Fk:currentRoom().alive_players) do
            if not p.chained then
            table.insert(not_chained, p.id)
            end
        end
        local to_chain = room:askToChoosePlayers(player, {
            min_num = x,
            max_num = x,
            targets = not_chained,
            skill_name = ciyong.name,
            prompt = "#ciyong_chain",
            cancelable = false,
        })
        for _, pid in ipairs(to_chain) do
            local target_player = room:getPlayerById(pid)  -- 先获取玩家对象
            if target_player then
                target_player:setChainState(true)
            end
    end
    end,
    after_use = function(self, player, use)
        local x = player:usedSkillTimes(ciyong.name, Player.HistoryGame) + 1
        player.room:setPlayerMark(player, "@pang_ciyong", x)
    end,
    enabled_at_play = function(self, player)
        local available = 0
        local room = player.room
        for _, p in ipairs(Fk:currentRoom().alive_players) do
            if not p.chained then
                available = available + 1
            end
        end
        if player:usedSkillTimes(ciyong.name, Player.HistoryGame) < available then
            return true
        end
    end,
    enabled_at_response = function(self, player, response)
        local available = 0
        local room = player.room
        for _, p in ipairs(Fk:currentRoom().alive_players) do
            if not p.chained then
                available = available + 1
            end
        end
        if player:usedSkillTimes(ciyong.name, Player.HistoryGame) < available then
            return true
        end
    end,
})

ciyong:addEffect(fk.BeforeChainStateChange, {
  anim_type = "negative",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(ciyong.name) and player.chained
  end,
  on_refresh = function (self, event, target, player, data)
    local room = player.room
    local choices = {"draw2", "reset_ciyong"}
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = ciyong.name,
    })
    if choice == "draw2" then
        player:drawCards(2, ciyong.name)
    else
        room:setPlayerMark(player, "@pang_ciyong", 0)
        player:setSkillUseHistory("pang_ciyong", 0, Player.HistoryGame)
    end
  end,
})



Fk:loadTranslationTable {["pang_ciyong"] = "磁涌",
[":pang_ciyong"] = "你可以横置X名角色并视为使用或打出一张雷【杀】或【闪】（X为此技能发动次数）；当你重置时，你摸两张牌或令此技能视为未发动过。",
["#ciyong"] = "磁涌：你可以横置X名角色，视为使用或打出雷【杀】或【闪】",
["#ciyong_chain"] = "磁涌：选择X名角色横置", 
["#ciyong_choose"] = "磁涌：你可以摸两张牌或令“磁涌”视为未发动过",
["@pang_ciyong"] = "磁涌",
["draw2"] = "摸两张牌",
["reset_ciyong"] = "重置“磁涌”",

["$pang_ciyong1"] = "Extermination commencing.",
["$pang_ciyong2"] = "I will take great pleasure in seeing them in pieces.",
}
return ciyong