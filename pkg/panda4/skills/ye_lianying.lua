local lianying = fk.CreateSkill {
  name = "ye_lianying",
  tags = {Skill.Switch},
}

lianying:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        if not player:hasSkill(lianying.name) then return false end
        local X = player:getHandcardNum()
        local x_current = 0
        for _, p in ipairs(data.tos) do
            if player:getSwitchSkillState(lianying.name, true) == fk.SwitchYang then
                x_current = x_current + 1
            elseif data.damageDealt and player:getSwitchSkillState(lianying.name, true) ~= fk.SwitchYang and data.damageDealt[p] and data.damageDealt[p] > 0 then
                x_current = x_current + 1
            end
        end
        if x_current == X then 
            return true 
        end
    end,
    on_cost = Util.TrueFunc,
    on_use = function(self, event, target, player, data)
        local room = player.room
        player:drawCards(1, lianying.name)
        if table.every(Fk:currentRoom().alive_players, function(p)
            return not p.dying
        end) then
            local choices = {"pang_chain", "pang_fire", "cancel_choose"}
                local choice = room:askToChoice(player, {
                    choices = choices,
                    skill_name = lianying.name,
                })
            if choice == "pang_chain" then
                local slash = Fk:cloneCard("iron_chain")
                local targets = table.filter(Fk:currentRoom().alive_players, function (p)
                    return player:canUseTo(slash, p, {bypass_times = true})
                end)
                if #targets > 0 then
                    local tos = room:askToChoosePlayers(player, {
                        min_num = 1,
                        max_num = 2,
                        targets = targets,
                        skill_name = lianying.name,
                        prompt = "#chain_choose",
                        cancelable = true,
                    })
                    if #tos > 0 then
                        local targets = tos
                        room:sortByAction(targets)
                        room:useVirtualCard("iron_chain", nil, player, targets, lianying.name, true)
                    end
                end
            elseif choice == "pang_fire" then
                local slash = Fk:cloneCard("fire_attack")
                local targets = table.filter(Fk:currentRoom().alive_players, function (p)
                    return player:canUseTo(slash, p, {bypass_times = true})
                end)
                if #targets > 0 then
                    local tos = room:askToChoosePlayers(player, {
                        min_num = 1,
                        max_num = 1,
                        targets = targets,
                        skill_name = lianying.name,
                        prompt = "#fire_choose",
                        cancelable = true,
                    })
                    if #tos > 0 then
                        local targets = tos
                        room:sortByAction(targets)
                        room:useVirtualCard("fire_attack", nil, player, targets, lianying.name, true)
                    end
                end
            end
        end
    end,
})

Fk:loadTranslationTable {["ye_lianying"] = "连营",
[":ye_lianying"] = "转换技，你使用牌结算后，若此牌①造成了X点伤害②指定了X名目标（X为你的手牌数），你摸一张牌，然后若没有角色处于濒死状态，你可以视为使用①【铁索连环】②【火攻】。",
["pang_chain"] = "视为使用【铁锁连环】",
["pang_fire"] = "视为使用【火攻】",
["#fire_choose"] = "连营：视为使用一张【火攻】",
["#chain_choose"] = "连营：视为使用一张【铁锁连环】",
["cancel_choose"] = "取消",

["$ye_lianying1"] = "今提墨笔绘乾坤，湖海添色山永春。",
["$ye_lianying2"] = "手提玉剑斥千军，昔日锦鲤化金龙。",
}
return lianying