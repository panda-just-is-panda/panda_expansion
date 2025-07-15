local jianmi = fk.CreateSkill {
  name = "pang_jianmi",
}

jianmi:addEffect("active", {
  anim_type = "control",
  prompt = "#jianmi",
  min_target_num = 1,
  max_target_num = 2,
  card_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(jianmi.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected < 2 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target1 = effect.tos[1]
    local cards1 = target1:getCardIds("h")
    local ids, choice = room:askToChooseCardsAndChoice(player, {
      cards = cards1,
      choices = {"jianmi_discard"},
      skill_name = jianmi.name,
      prompt = "#jianmi-view::" .. target1.id,
      cancel_choices = {"jianmi_Cancel1" and #effect.tos > 1 or "Cancel"},
      min_num = 1,
      max_num = 1,
      all_cards = cards1
    })
    if choice == "jianmi_discard" then
        local discard1 = table.filter(cards1, function (id)
        return Fk:getCardById(id).trueName == Fk:getCardById(ids[1]).trueName
        end)
        room:throwCard(discard1, jianmi.name, target1, player)
        if #effect.tos > 1 then
        local target2 = effect.tos[2]
        local cards2 = target2:getCardIds("h")
        local discard2 = table.filter(cards2, function (id2)
        return Fk:getCardById(id2).trueName == Fk:getCardById(ids[1]).trueName
        end)
        room:throwCard(discard2, jianmi.name, target2, player)
        end
    elseif choice == "jianmi_Cancel1" and #effect.tos > 1 then
        local target2 = effect.tos[2]
        local cards2 = target2:getCardIds("h")
        local ids2, choice2 = room:askToChooseCardsAndChoice(player, {
        cards = cards2,
        choices = {"jianmi_discard"},
        skill_name = jianmi.name,
        prompt = "#jianmi-view::" .. target2.id,
        cancel_choices = {"jianmi_Cancel2"},
        min_num = 1,
        max_num = 1,
        all_cards = cards2
        })
        if choice2 == "jianmi_discard" then
            local discard1 = table.filter(cards1, function (id)
            return Fk:getCardById(id).trueName == Fk:getCardById(ids2[1]).trueName
            end)
            room:throwCard(discard1, jianmi.name, target1, player)
            local target2 = effect.tos[2]
            local cards2 = target2:getCardIds("h")
            local discard2 = table.filter(cards2, function (id2)
            return Fk:getCardById(id2).trueName == Fk:getCardById(ids2[1]).trueName
            end)
            room:throwCard(discard2, jianmi.name, target2, player)
        else
            local ids3, choice = room:askToChooseCardsAndChoice(player, {
            cards = cards1,
            choices = {"jianmi_discard"},
            skill_name = jianmi.name,
            prompt = "#jianmi-view::" .. target1.id,
            cancel_choices = {"Cancel"},
            min_num = 1,
            max_num = 1,
            all_cards = cards1
            })
            local discard1 = table.filter(cards1, function (id)
            return Fk:getCardById(id).trueName == Fk:getCardById(ids3[1]).trueName
            end)
            room:throwCard(discard1, jianmi.name, target1, player)
            local target2 = effect.tos[2]
            local cards2 = target2:getCardIds("h")
            local discard2 = table.filter(cards2, function (id2)
            return Fk:getCardById(id2).trueName == Fk:getCardById(ids3[1]).trueName
            end)
            room:throwCard(discard2, jianmi.name, target2, player)
    end
    end
  end,
})

Fk:loadTranslationTable{
  ["pang_jianmi"] = "监秘",
  [":pang_jianmi"] = "出牌阶段限一次，你可以观看至多两名其他角色的所有手牌，然后你可以选择其中一张牌并弃置这些角色手牌中所有此牌名的牌。",
  ["#jianmi"] = "选择至多两名角色",
  ["jianmi_Cancel1"] = "继续观看下一名角色的手牌",
  ["jianmi_discard"] = "弃置此牌",
  ["jianmi_Cancel2"] = "返回上一名角色的手牌",
  ["#jianmi-view::"] = "监秘：观看%dest的手牌",
}

return jianmi