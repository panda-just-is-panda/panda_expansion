local tushe = fk.CreateSkill {
  name = "pang_tushe",
}

Fk:loadTranslationTable{
  ["pang_tushe"] = "图射",
  [":pang_tushe"] = "你可以跳过摸牌阶段并亮出牌堆顶的五张牌，然后你获得其中的基本牌；若其中没有【闪】，你可于下个阶段如此做。",

  ["get_cards"] = "获得其中的基本牌",
  ["get_cards2"] = "获得其中的非基本牌",
  ["#tushe-ask"] = "图射：你可以跳过此阶段并亮出牌堆顶的五张牌",
  ["@@tushe"] = "可继续图射",

  ["$pang_tushe1"] = "据险以图进，备策而施为！",
  ["$pang_tushe2"] = "夫战者，可时以奇险之策而图常谋！",
}



tushe:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(tushe.name) and (player.phase == Player.Draw or player:getMark("@@tushe") > 0) and not data.phase_end
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
        skill_name = tushe.name,
        prompt = "#tushe-ask",
      }) then
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    data.phase_end = true
    local room = player.room
    local get_cards2 = true
    local cids = room:getNCards(5)
    room:turnOverCardsFromDrawPile(player, cids, tushe.name)
    room:delay(200)
    local cards = table.filter(cids, function(id)
        local card = Fk:getCardById(id)
        return card.type == Card.TypeBasic
    end)
    local cards2 = table.filter(cids, function(id)
        local card = Fk:getCardById(id)
        return card.type ~= Card.TypeBasic
    end)
    for _, id in ipairs(cids) do
        local name = Fk:getCardById(id).name
        if name == "jink" then
            get_cards2 = false
        end
    end
    room:obtainCard(player, cards2, true, fk.ReasonJustMove, player)
    if get_cards2 == true then
      room:addPlayerMark(player, "@@tushe")
    end
    room:cleanProcessingArea(cids)
  end,
})

return tushe