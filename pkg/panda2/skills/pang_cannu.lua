local cannu = fk.CreateSkill {
  name = "pang_cannu",
  tags = {Skill.Compulsory},
}

cannu:addEffect(fk.EventPhaseStart, {
mute = true,
  can_trigger = function(self, event, target, player, data)
    local x = math.random(0, 2)
    return target == player and player:hasSkill(cannu.name) and (player.phase == Player.Start or player.phase == Player.Judge and x == 2)
  end,
  on_use = function(self, event, target, player, data)
    if data.phase == Player.Judge then
        data.phase_end = true
    end
    local room = player.room
    local random = math.random(1, 10)
    local slash = Fk:cloneCard("slash")
    local duel = Fk:cloneCard("duel")
    local max_num = duel.skill:getMaxTargetNum(player, duel)
    if random == 4 or random == 5 then
        local targets = table.filter(room:getOtherPlayers(player, false), function (p)
            return player:canUseTo(duel, p)
        end)
        if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
                min_num = 1,
                max_num = max_num,
                targets = targets,
                skill_name = cannu.name,
                prompt = "#cannu2",
                cancelable = false,
            })
            if #tos > 0 then
                local targets = tos
                room:sortByAction(targets)
                room:useVirtualCard("duel", nil, player, targets, cannu.name, true)
            end
        end
    elseif random < 4 then
        local targets = table.filter(room:getOtherPlayers(player, false), function (p)
            return player:canUseTo(slash, p)
        end)
        if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
                min_num = 1,
                max_num = max_num,
                targets = targets,
                skill_name = cannu.name,
                prompt = "#cannu1",
                cancelable = false,
            })
            if #tos > 0 then
                local targets = tos
                room:sortByAction(targets)
                room:useVirtualCard("slash", nil, player, targets, cannu.name, true)
            end
        end
    elseif random == 7 then
        local cards = player.room:getCardsFromPileByRule("duel", 1, "discardPile")
        if #cards > 0 then
            player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, cannu.name)
        else
            cards = player.room:getCardsFromPileByRule("duel", 1)
            if #cards > 0 then
                player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, cannu.name)
            end
        end
    else
        local cards = player.room:getCardsFromPileByRule("savage_assault", 1, "discardPile")
        if #cards > 0 then
            player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, cannu.name)
        else
            cards = player.room:getCardsFromPileByRule("savage_assault", 1)
            if #cards > 0 then
                player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, cannu.name)
            end
        end
    end
  end,
})



Fk:loadTranslationTable {["pang_cannu"] = "残怒",
[":pang_cannu"] = "锁定技，准备阶段，你可能随机视为使用一张【杀】或【决斗】，也可能随机获得一张伤害牌，且你可能跳过判定阶段并发动此技能。",
["#cannu1"] = "视为使用一张【杀】",
["#cannu2"] = "视为使用一张【决斗】",

}
return cannu  --不要忘记返回做好的技能对象哦