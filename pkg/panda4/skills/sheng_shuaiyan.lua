Fk:loadTranslationTable{
  ["sheng_shuaiyan"] = "率言",
  [":sheng_shuaiyan"] = "准备阶段，你可以与一名其他角色拼点，若你赢，你摸两张牌并对其发动“急盟”，否则你可以受到1点火焰伤害，然后对其发动“率言”。",
  ["#shuaiyan-choose"] = "率言：你可以和一名其他角色拼点",
  ["shuaiyan_invoke"] = "你可以受到火焰伤害并再次对其“率言”",
  ["jimeng_invoke"] = "你可以对其发动“急盟”",
  ["jimeng_recover"] = "你可以和邓芝各回复1点体力",

}

local shuaiyan = fk.CreateSkill{
  name = "sheng_shuaiyan",
}

shuaiyan:addEffect(fk.EventPhaseStart, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(shuaiyan.name) and player.phase == Player.Start
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
            skill_name = shuaiyan.name,
            prompt = "#shuaiyan-choose",
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
        while true do
            local pindian = player:pindian({to}, shuaiyan.name)
            if player.dead then return end
            if pindian.results[to].winner == player then
                player:drawCards(2, shuaiyan.name)
                local choices2 = {"jimeng_invoke", "Cancel"}
                local choice2 = room:askToChoice(to, {
                choices = choices2,
                skill_name = shuaiyan.name,
                })
                if choice2 == "Cancel" then
                    break
                else
                    player:setChainState(true)
                    to:setChainState(true)
                    local choices3 = {"jimeng_recover", "Cancel"}
                    local choice3 = room:askToChoice(to, {
                    choices = choices3,
                    skill_name = shuaiyan.name,
                    })
                    if choice3 == "jimeng_recover" then
                        room:recover({
                        who = player,
                        num = 1,
                        recoverBy = player,
                        skillName = shuaiyan.name
                        })
                        room:recover({
                        who = to,
                        num = 1,
                        recoverBy = player,
                        skillName = shuaiyan.name
                        })
                        break
                    end
                end
            end
            local choices1 = {"shuaiyan_invoke", "Cancel"}
            local choice1 = room:askToChoice(to, {
                choices = choices1,
                skill_name = shuaiyan.name,
                })
            if choice1 == "Cancel" then
                break
            else
                room:damage{
                    from = player,
                    to = player,
                    damage = 1,
                    damageType = fk.FireDamage,
                    skillName = shuaiyan.name,
                }
            end
            if player.dead or player:isKongcheng() then
                break
            end
        end
    end,
})



return shuaiyan