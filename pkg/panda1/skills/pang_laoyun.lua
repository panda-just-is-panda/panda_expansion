local laoyun = fk.CreateSkill {
  name = "pang_laoyun",
}

Fk:loadTranslationTable {["pang_laoyun"] = "劳运",
[":pang_laoyun"] = "每回合限一次，当你使用或打出牌后，你可以观看一名其他角色的手牌，然后你交给其一张牌并摸一张牌。",

["#laoyun-choose"] = "劳运：你可以观看一名其他角色的手牌，然后交给其一张牌并摸一张牌",
["#laoyun_ask"] = "劳运：交给 %src 一张牌并摸一张牌",


["$pang_laoyun1"] = "",
["$pang_laoyun2"] = "",
}

local laoyun_spec = {
anim_type = "support",
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(laoyun.name) and not not player:isNude()
        and player:usedSkillTimes(laoyun.name, Player.HistoryTurn) == 0
    end,
    on_cost = function(self, event, target, player, data)
        local tos = player.room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = player.room:getOtherPlayers(player, false),
            skill_name = laoyun.name,
            prompt = "#laoyun-choose",
            cancelable = true,
        })
        if #tos > 0 then
            event:setCostData(self, {tos = tos})
            return true
        end
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:viewCards(player, { cards = to:getCardIds("h"), skill_name = laoyun.name, prompt = "$ViewCardsFrom:" .. to.id })
    local cards = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = laoyun.name,
        prompt = "#laoyun_ask:"..to.id,
        cancelable = false,
    })
    if #cards > 0 then
        room:obtainCard(to, cards, false, fk.ReasonGive)
        player:drawCards(1, laoyun.name)
    end
  end,
}
laoyun:addEffect(fk.CardUseFinished, laoyun_spec)
laoyun:addEffect(fk.CardRespondFinished, laoyun_spec)




return laoyun