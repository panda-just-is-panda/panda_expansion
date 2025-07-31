local ciyong = fk.CreateSkill({
  name = "pang_ciyong", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

ciyong:addEffect("viewas", {
    mute_card = false,
    pattern = "thunder__slash,jink",
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
        end
    end,
    enabled_at_play = function(self, player)
        return not Fk:currentRoom().current.chained
    end,
    enabled_at_response = function(self, player, response)
        return response and not Fk:currentRoom().current.chained or not response and not Fk:currentRoom().current.chained
    end,
})




Fk:loadTranslationTable {["pang_ciyong"] = "磁涌",
[":pang_ciyong"] = "你可以横置当前回合角色并视为使用或打出一张雷【杀】或【闪】，然后若你未横置，你摸一张牌。",
["#ciyong"] = "磁涌：你可以视为使用或打出雷【杀】或【闪】",
}
return ciyong