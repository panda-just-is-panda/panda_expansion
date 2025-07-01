local chaoyong = fk.CreateSkill({
  name = "pang_chaoyong", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

chaoyong:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  prompt = "#pang_chaoyong",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(chaoyong.name) then
    local mark1 = player:getTableMark("@chaoyong_suit-turn")
    if #mark1 > 3 then return false end
    local suits = {}
    local suit = data.card:getSuitString(true)
    if suit ~= "log_nosuit" and not table.contains(mark1, suit) then table.insertIfNeed(suits, suit)
    end
    if #suits > 0 then
        event:setCostData(self, {choice1 = suits})
        return true
    end
    end
        if target == player and player:hasSkill(chaoyong.name) then
    local mark2 = player:getTableMark("@chaoyong_type-turn")
    if #mark2 > 2 then return false end
    local types = {}
    local type = data.card:getTypeString(true)
    if not table2.contains(mark2, type) then table2.insertIfNeed(types, type)
    end
        if #types > 0 then
        event:setCostData(self, {choice2 = types})
        return true
    end
  end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local suits = event:getCostData(self).choice1
    local mark1 = player:getTableMark("@chaoyong_suit-turn")
    table.insertTable(mark1, suits)
    player.room:setPlayerMark(player, "@chaoyong_suit-turn", mark1)
    local cards = player:drawCards(1, chaoyong.name)
    if #cards == 0 then return false end
    local types = event:getCostData(self).choice2
    local mark2 = player:getTableMark("@chaoyong_type-turn")
    table2.insertTable(mark2, types)
    player.room:setPlayerMark(player, "@chaoyong_type-turn", mark2)
    local cards = player:drawCards(1, chaoyong.name)
    if #cards == 0 then return false end
  end
})

Fk:loadTranslationTable {["pang_chaoyong"] = "潮涌",
[":pang_chaoyong"] = "当你使用一张牌后，你每满足以下一项则摸一张牌：你本回合未使用过类型相同的牌；你本回合未使用过花色相同的牌。若均不满足，你失去1点体力。",
["#pang_chaoyong"] = "根据使用牌的条件摸牌",
["@chaoyong_suit-turn"] = "潮涌花色",
["@chaoyong_type-turn"] = "潮涌类型",
}
return chaoyong  --不要忘记返回做好的技能对象哦