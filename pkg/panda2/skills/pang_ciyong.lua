local ciyong = fk.CreateSkill({
  name = "pang_ciyong", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
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
        player.room.current:setChainState(true)
    end,
    after_use = function(self, player, use)
        if not player.chained then
            player:drawCards(1, ciyong.name)
        elseif player.chained and #player:getCardIds("he") > 1 then
            local discards = player.room:askToDiscard(player, {
                min_num = 2,
                max_num = 2,
                include_equip = true,
                skill_name = ciyong.name,
                prompt = "#ciyong_discard",
                cancelable = true,
            })
            if #discards > 0 then
                player:setChainState(false)
            end
        end
    end,
    enabled_at_play = function(self, player)
        return not Fk:currentRoom().current.chained
    end,
    enabled_at_response = function(self, player, response)
        return not Fk:currentRoom().current.chained
    end,
})




Fk:loadTranslationTable {["pang_ciyong"] = "磁涌",
[":pang_ciyong"] = "你可以横置当前回合角色并视为使用或打出一张雷【杀】或【闪】，然后若你：未横置，你摸一张牌；已横置，你可以弃置两张牌并重置。",
["#ciyong"] = "磁涌：你可以视为使用或打出雷【杀】或【闪】",
["#ciyong_discard"] = "你可以弃置两张牌并重置",

["$pang_ciyong1"] = "Extermination commencing.",
["$pang_ciyong2"] = "I will take great pleasure in seeing them in pieces.",
}
return ciyong