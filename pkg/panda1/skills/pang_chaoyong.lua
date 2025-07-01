local chaoyong = fk.CreateSkill({
  name = "pang_chaoyong", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

chaoyong:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  prompt = "#pang_chaoyong",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(chaoyong.name)
  end,
  on_use = function(self, event, target, player, data)
    if data.extra_data.chaoyongCheck then player:drawCards(1, chaoyong.name)
    else room:loseHp(player, 1, chaoyong.name)
  end
  end,
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(chaoyong.name, true)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local suit, type = data.card:getSuitString(true), data.card.getTypeString(true)
    local mark1 = player:getTableMark("@chaoyong-turn")
    if #mark1 > 6 then return false end
    local suits = {}
    local types = {}
    if suit ~= "log_nosuit" and not table.contains(mark1, suit) then 
        table.insertIfNeed(suits, suit)
        data.extra_data.jianyingCheck = true
    elseif not table.contains(mark1, type) then
        table.insertIfNeed(types, type)
        data.extra_data.jianyingCheck = true
    end
     room:setPlayerMark(player, "@chaoyong-turn", {suit, type})
  end,
})

Fk:loadTranslationTable {["pang_chaoyong"] = "潮涌",
[":pang_chaoyong"] = "当你使用一张牌后，若你本回合未使用过和此牌类型或花色相同的牌，你摸一张牌，否则你失去1点体力。",
["#pang_chaoyong"] = "根据使用牌的条件摸牌",
["@chaoyong_suit-turn"] = "潮涌花色",
["@chaoyong_type-turn"] = "潮涌类型",
}
return chaoyong  --不要忘记返回做好的技能对象哦