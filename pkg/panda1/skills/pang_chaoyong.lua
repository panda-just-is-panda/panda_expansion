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
    local room = player.room
    local use_events1 = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from == player and use.card.type == data.card.type
      end, Player.HistoryTurn)
      local use_events2 = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from == player and use.card.type == data.card.suit
      end, Player.HistoryTurn)
    if #use_events1 == 1 and use_events1[1].data or #use_events2 == 1 and use_events2[1].data == data then
         player:drawCards(1, chaoyong.name)
    else room:loseHp(player, 1, chaoyong.name)
  end
end
})

Fk:loadTranslationTable {["pang_chaoyong"] = "潮涌",
[":pang_chaoyong"] = "锁定技，当你使用一张牌后，若你本回合未使用过和此牌类型或花色相同的牌，你摸一张牌，否则你失去1点体力。",
["#pang_chaoyong"] = "根据使用牌的条件摸牌",
["@chaoyong-turn"] = "潮涌",
}
return chaoyong  --不要忘记返回做好的技能对象哦