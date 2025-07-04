local qietian = fk.CreateSkill {
  name = "pang_qietian",
  tags = {},
}

qietian:addEffect(fk.EventPhaseStart, {
anim_type = "switch",
prompt = "#qietian_invoke",
  can_trigger = function(self, event, target, player, data)
    local card = table.filter(player:getCardIds("he"), function(id)
    local card_pick = Fk:getCardById(id)
        return card_pick and card_pick.color == card_pick.Black and not player:prohibitDiscard(id)
        end)
    return target ~= player and player:hasSkill(qietian.name) and target.phase == Player.Finish and #card > 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local tian = Fk:cloneCard("ex_nihilo")
    local cards = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = qietian.name,
        pattern = ".|.|spade,club",
        prompt = "qietian_asking",
        cancelable = false,
      })
        tian:addSubcards(cards)
        room:useVirtualCard("ex_nihilo", tian, player, player, qietian.name, true)
    if not player.dead and not target.dead then
        local cards = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = qietian.name,
        prompt = "qietian_2",
        cancelable = false,
      })
      room:obtainCard(target, cards, false, fk.ReasonGive)
      if data.card.from:hasSkill(qietian.name) and not target:hasSkill("pang_qieshou") then
        local choices = {"give_skill", "Cancel"}
            local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = qietian.name,
    })
        if choice ~= "Cancel" then
        room:handleAddLoseSkills(player, "-pang_qietian")
        room:handleAddLoseSkills(target, "pang_qieshou", nil, true, false)
        end
      end
    end
    end,
})

Fk:loadTranslationTable {["pang_qietian"] = "且佃",
[":pang_qietian"] = "其他角色的结束阶段，你可将一张黑色牌作为【无中生有】使用并交给其一张牌，然后若其没有“且守”，你可以失去此技能并令其获得“且守”。",
["qietian_asking"] = "将一张黑色牌作为【无中生有】使用",
["qietian_2"] = "你需交给当前回合角色一张牌",
["give_skill"] = "你可以失去“且佃”并令其获得“且守”"
}
return qietian  --不要忘记返回做好的技能对象哦