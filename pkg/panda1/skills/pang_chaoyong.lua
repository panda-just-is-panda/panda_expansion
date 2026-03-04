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
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local use_events1 = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
      local use1 = e.data
      return use1.from == player and use1.card.type == data.card.type
    end, Player.HistoryTurn)
    local use_events2 = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
      local use2 = e.data
      return use2.from == player and use2.card.suit == data.card.suit
    end, Player.HistoryTurn)
    if #use_events1 == 1 and use_events1[1].data == data or #use_events2 == 1 and use_events2[1].data == data then
         player:drawCards(1, chaoyong.name)
         if not table.contains(player:getTableMark("@chaoyong_suit-turn"), "log_" .. data.card:getSuitString()) then
            local typesRecorded = player:getTableMark("@chaoyong_suit-turn")
            table.insert(typesRecorded, "log_" .. data.card:getSuitString())
            room:setPlayerMark(player, "@chaoyong_suit-turn", typesRecorded)
         end
         if not table.contains(player:getTableMark("@chaoyong_type-turn"), "log_" .. data.card:getTypeString()) then
            local typesRecorded = player:getTableMark("@chaoyong_type-turn")
            table.insert(typesRecorded, "log_" .. data.card:getTypeString())
            room:setPlayerMark(player, "@chaoyong_type-turn", typesRecorded)
         end
    else room:loseHp(player, 1, chaoyong.name)
  end
end
})

Fk:loadTranslationTable {["pang_chaoyong"] = "潮涌",
[":pang_chaoyong"] = "锁定技，当你使用一张牌后，若你本回合未使用过和此牌类型或花色相同的牌，你摸一张牌，否则你失去1点体力。",
["#pang_chaoyong"] = "根据使用牌的条件摸牌",
["@chaoyong-turn"] = "潮涌",

["$pang_chaoyong1"] = "溺尸低吼",
["$pang_chaoyong2"] = "溺尸嘶吼",
}
return chaoyong  --不要忘记返回做好的技能对象哦