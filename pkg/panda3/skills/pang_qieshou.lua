local qieshou = fk.CreateSkill {
  name = "pang_qieshou",
  tags = {},
}

qieshou:addEffect("viewas", {
  anim_type = "defensive",
  pattern = "jink",
  prompt = "#qieshou",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).type == Card.TypeEquip
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return nil end
    local card = Fk:cloneCard("jink")
    card:addSubcard(cards[1])
    card.skillName = qieshou.name
    return card
  end,
})

qieshou:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return data.card.from:hasSkill(qieshou.name) and data.card and table.contains(data.card.skillNames, qieshou.name) and
        player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return not p.dead
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = qieshou.name,
      prompt = "qieshou_2",
      cancelable = true,
    })
      player.room:obtainCard(player, data.card, true, fk.ReasonJustMove, to, qieshou.name)
      if player:hasSkill(qieshou.name) and not to:hasSkill("pang_qietian") then
        local choices = {"give_skill", "Cancel"}
            local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = qieshou.name,
    })
        if choice ~= "Cancel" then
        room:handleAddLoseSkills(player, "-pang_qieshou")
        room:handleAddLoseSkills(target, "pang_qietian", nil, true, false)
        end
      end
    end,
})

Fk:loadTranslationTable {["pang_qieshou"] = "且守",
[":pang_qieshou"] = "你可以将一张装备牌作为【闪】使用或打出并可以令一名其他角色获得此装备牌，然后若其没有“且佃”，你可以失去此技能并令其获得“且佃”。",
["#qieshou"] = "你可以将一张装备牌作为【闪】使用",
["qieshou_2"] = "你可以令一名其他角色获得此装备牌",
["give_skill"] = "你可以失去“且守”并令其获得“且佃”"
}
return qieshou --不要忘记返回做好的技能对象哦