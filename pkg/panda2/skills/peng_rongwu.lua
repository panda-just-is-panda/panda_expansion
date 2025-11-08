local rongwu = fk.CreateSkill {
  name = "peng_rongwu",
}

Fk:loadTranslationTable{
  ["peng_rongwu"] = "戎舞",
  [":peng_rongwu"] = "你可以将两张于本回合内获得的牌当【決斗】使用，然后重置 “绽歌”。",

  ["@@rongwu-inhand-turn"] = "戎舞",
  ["#shuangxiong"] = "戎舞：你可以将两张于本回合获得的牌当【決斗】使用",
}

rongwu:addEffect(fk.AfterCardsMove, {
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(rongwu.name, true)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    for _, move in ipairs(data) do
      if move.to == player and move.toArea == Player.Hand then
        for _, info in ipairs(move.moveInfo) do
          if table.contains(player:getCardIds("h"), info.cardId) then
            room:setCardMark(Fk:getCardById(info.cardId), "@@rongwu-inhand-turn", 1)
          end
        end
      end
    end
  end,
})

rongwu:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "duel",
  prompt = "#shuangxiong",
  handly_pile = true,
  filter_pattern = function (self, player, to_select, selected)
    local ids = {}
    for _, id in ipairs(player:getCardIds("h")) do
        if Fk:getCardById(id):getMark("@@rongwu-inhand-turn") > 0 then
            table.insert(ids, id)
        end
    end
    if #ids == 0 then
        player:chat(
          "table错误！")
    end
    return #selected < 2 and table.contains(ids, to_select)
  end,
  view_as = function(self, player, cards)
    if #cards ~= 2 then return end
    local c = Fk:cloneCard("duel")
    c:addSubcard(cards)
    c.skillName = rongwu.name
    return c
  end,
  enabled_at_play = function(self, player)
    return true
  end,
  enabled_at_response = function(self, player, response)
    if not response then return true end
  end,
  after_use = function(self, player, use)
    player.room:setPlayerMark(player, "@@zhange_red_used-turn", 0)
    player.room:setPlayerMark(player, "@@zhange_black_used-turn", 0)
  end,
})


return rongwu