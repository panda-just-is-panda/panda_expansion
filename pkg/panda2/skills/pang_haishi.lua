local haishi = fk.CreateSkill {
  name = "pang_haishi",
  tags = {},
}

haishi:addEffect(fk.EventPhaseStart, {
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(haishi.name) and player.phase == Player.Discard
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local card = player:drawCards(3)
        if #player:getCardIds("h") < player:getMaxCards() then
            local num = player:getMaxCards() - #player:getCardIds("h")
            for i = 1, num do
            if player.dead or not room:askToUseVirtualCard(player, {
            name = "slash",
            skill_name = haishi.name,
            prompt = "#haishi-slash",
            cancelable = true,
            extra_data = {
            bypass_times = true,
            extraUse = true,
            },
            }) then
                break
            end
            end
        end
    end,
    })

Fk:loadTranslationTable {["pang_haishi"] = "海诗",
[":pang_haishi"] = "弃牌阶段开始时，你可以摸三张牌，然后若你的手牌数小于你的手牌上限，你可以依次视为使用至多X张【杀】（X为你的手牌数和手牌上限之差）。",
["#haishi-slash"] = "你可以视为使用一张【杀】",
}

return haishi