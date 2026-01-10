local moyu = fk.CreateSkill {
  name = "bi_moyu",
  tags = { Skill.Compulsory, Skill.Switch },
}

Fk:loadTranslationTable{
  ["bi_moyu"] = "摸鱼",
  [":bi_moyu"] = "转换技，锁定技，以你为①唯一目标②使用者的牌结算后，使用者和唯一的目标角色弃置所有手牌（无牌则不弃）并摸X张牌（X为各自弃牌中缺失花色数+1）。",
}

moyu:addEffect(fk.CardUseFinished, {
anim_type = "switch",
    can_trigger = function(self, event, target, player, data)
        if not player:hasSkill(moyu.name) then return false end
        if player:getSwitchSkillState(moyu.name, true) ~= fk.SwitchYang then
            return data.tos and #data.tos == 1 and data.tos[1] == player
        else
            return target == player
        end
    end,
    on_cost = Util.TrueFunc,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local from = target
        local cards = table.filter(from:getCardIds("h"), function(id)
            return not from:prohibitDiscard(id)
        end)
        local X = 5
        if #cards > 0 then
            local suits = {}
            for _, id in ipairs(cards) do
                table.insertIfNeed(suits, Fk:getCardById(id).suit)
            end
            table.removeOne(suits, Card.NoSuit)
            X = 5 - #suits
            room:throwCard(cards, moyu.name, from, from)
        end
        from:drawCards(X, moyu.name)
        if data.tos and #data.tos == 1 and not from == data.tos[1] then
            local to = data.tos[1]
            local cards = table.filter(to:getCardIds("h"), function(id)
                return not to:prohibitDiscard(id)
            end)
            local X = 5
            if #cards > 0 then
                local suits = {}
                for _, id in ipairs(cards) do
                    table.insertIfNeed(suits, Fk:getCardById(id).suit)
                end
                table.removeOne(suits, Card.NoSuit)
                X = 5 - #suits
                room:throwCard(cards, moyu.name, to, to)
            end
            to:drawCards(X, moyu.name)
        end
    end,
})

return moyu