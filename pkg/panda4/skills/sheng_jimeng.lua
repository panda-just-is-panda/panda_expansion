Fk:loadTranslationTable{
  ["sheng_jimeng"] = "急盟",
  [":sheng_jimeng"] = "结束阶段，你可以与一名其他角色调整为横置状态，然后其可令双方各回复1点体力，若其拒绝，你可以对其发动“率言”。",
  ["jimeng_recover"] = "你可以和邓芝各回复1点体力",
    ["#shuaiyan-choose"] = "率言：你可以和一名其他角色拼点",
    ["#jimeng-choose"] = "急盟：你可以和一名其他角色横置并使其抉择",
  ["shuaiyan_invoke"] = "你可以受到火焰伤害并再次对其“率言”",
  ["jimeng_invoke"] = "你可以对其发动“急盟”",
  ["shuaiyan_start"] = "你可以对其发动“率言”",

}

local jimeng = fk.CreateSkill{
  name = "sheng_jimeng",
}

jimeng:addEffect(fk.EventPhaseStart, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(jimeng.name) and player.phase == Player.Finish
    end,
    on_cost = function(self, event, target, player, data)
        local room = player.room
        local targets = table.filter(room:getOtherPlayers(player, false), function(p)
            return not p:isKongcheng()
        end)
        local to = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = jimeng.name,
            prompt = "#jimeng-choose",
            cancelable = true,
        })
        if #to > 0 then
            event:setCostData(self, {tos = to})
            return true
        end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local to = event:getCostData(self).tos[1]
            player:setChainState(true)
            to:setChainState(true)
            local choices3 = {"jimeng_recover", "Cancel"}
            local choice3 = room:askToChoice(to, {
                choices = choices3,
                skill_name = jimeng.name,
                })
            if choice3 == "Cancel" then
                local choices1 = {"shuaiyan_start", "Cancel"}
                local choice1 = room:askToChoice(player, {
                    choices = choices1,
                    skill_name = jimeng.name,
                    })
                if choice1 == "shuaiyan_start" then
                    while true do
                        local pindian = player:pindian({to}, jimeng.name)
                        if player.dead then return end
                        if pindian.results[to].winner == player then
                            player:drawCards(2, jimeng.name)
                            local choices2 = {"jimeng_invoke", "Cancel"}
                            local choice2 = room:askToChoice(player, {
                            choices = choices2,
                            skill_name = jimeng.name,
                            })
                            if choice2 == "Cancel" then
                                break
                            else
                                player:setChainState(true)
                                to:setChainState(true)
                                local choices3 = {"jimeng_recover", "Cancel"}
                                local choice3 = room:askToChoice(to, {
                                    choices = choices3,
                                    skill_name = jimeng.name,
                                })
                                if choice3 == "jimeng_recover" then
                                    room:recover({
                                        who = player,
                                        num = 1,
                                        recoverBy = player,
                                        skillName = jimeng.name
                                })
                                    room:recover({
                                        who = to,
                                        num = 1,
                                        recoverBy = player,
                                        skillName = jimeng.name
                                })
                                    break
                                else
                                    local choices4 = {"shuaiyan_start", "Cancel"}
                                    local choice4 = room:askToChoice(player, {
                                    choices = choices4,
                                    skill_name = jimeng.name,
                                    })
                                    if choice4 == "Cancel" then
                                        break
                                    end
                                end
                            end
                        else
                            local choices1 = {"shuaiyan_invoke", "Cancel"}
                            local choice1 = room:askToChoice(player, {
                                choices = choices1,
                                skill_name = jimeng.name,
                            })
                            if choice1 == "Cancel" then
                                break
                            else
                                room:damage{
                                from = player,
                                to = player,
                                damage = 1,
                                damageType = fk.FireDamage,
                                skillName = jimeng.name,
                                }
                            end
                        end
                        if player.dead or player:isKongcheng() or to:isKongcheng() then
                            break
                        end
                    end
                end
            else
                room:recover({
                    who = player,
                    num = 1,
                    recoverBy = player,
                    skillName = jimeng.name
                })
                room:recover({
                    who = to,
                    num = 1,
                    recoverBy = player,
                    skillName = jimeng.name
                })
            end
    end,
})



return jimeng