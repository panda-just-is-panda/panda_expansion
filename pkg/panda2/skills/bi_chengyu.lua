local chengyu = fk.CreateSkill({
  name = "bi_chengyu", 
  tags = {}, 
})

chengyu:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#chengyu-active",
  can_use = function(self, player)
    return player:usedSkillTimes(chengyu.name, Player.HistoryPhase) < 2 and not player:isKongcheng()
  end,
  target_num = 0,
  card_num = 0,
  card_filter = Util.FalseFunc,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local cards = table.simpleClone(player:getCardIds("h"))
    local suits, types = {}, {}
    for _, id in ipairs(cards) do
        table.insertIfNeed(suits, Fk:getCardById(id).suit)
        table.insertIfNeed(types, Fk:getCardById(id).type)
    end
    table.removeOne(suits, Card.NoSuit)
    room:recastCard(cards, player, chengyu.name)
    if #suits == 4 or #types == 3 then
        room:addPlayerMark(player, "@@chengyu")
    end
end,
})

chengyu:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@@chengyu") > 0 
  end,
  on_use = function(self, event, target, player, data)
    if not data.extraUse then
      data.extraUse = true
      player:addCardUseHistory(data.card.trueName, -1)
    end
    data.disresponsiveList = table.simpleClone(player.room.players)
  end,
})

chengyu:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and player:getMark("@@chengyu") > 0
  end,
})


Fk:loadTranslationTable {["bi_chengyu"] = "成玉",
[":bi_chengyu"] = "出牌阶段限两次，你可以重铸所有手牌，若其中包含三种类别或四种花色，本阶段你使用下一张牌无次数限制且不可响应。",
["#chengyu-active"] = "成玉：你可以重铸所有手牌，若包含三种类别或四种花色则本阶段你使用下一张牌无次数限制且不可响应",
["@@chengyu"] = "成玉",

}
return chengyu