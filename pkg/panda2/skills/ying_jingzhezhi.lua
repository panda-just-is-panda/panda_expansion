Fk:loadTranslationTable{
    ["ying_jingzhezhi"] = "惊蛰至",
    [":ying_jingzhezhi"] = "转换技，出牌阶段限一次，你可以选择一名角色，然后你弃置所有手牌（无牌则不弃）并视为使用一张【万箭齐发】；当此牌造成伤害时，其防止此伤害并①重铸②摸一张牌。",

    [":ying_jingzhezhi_yang"] = "转换技，出牌阶段限一次，你可以选择一名角色，然后你弃置所有手牌并视为使用一张【万箭齐发】；当此牌造成伤害时，其防止此伤害并<font color=\"#E0DB2F\">①重铸</font>②摸一张牌",
    [":ying_jingzhezhi_yin"] = "转换技，出牌阶段限一次，你可以选择一名角色，然后你弃置所有手牌并视为使用一张【万箭齐发】；当此牌造成伤害时，其防止此伤害并①重铸<font color=\"#E0DB2F\">②摸</font>一张牌",

  ["#jingzhezhi"] = "惊蛰至：选择一名角色并弃置所有手牌，视为使用一张效果特殊的【万箭齐发】。",
  ["#jingzhezhi-ask"] = "重铸一张牌",
  ["@@jingzhezhi"] = "惊蛰至",

    ["$ying_jingzhezhi1"] = "新的未来不需要你们，化为灰烬吧！",
    ["$ying_jingzhezhi2"] = "让开，别挡着孩子们的路。",
}

local jingzhezhi = fk.CreateSkill{
  name = "ying_jingzhezhi",
  tags = {Skill.Switch},
}

jingzhezhi:addEffect("active", {
  anim_type = "control",
  card_num = 0,
  target_num = 1,
  prompt = "#jingzhezhi",
  can_use = function(self, player)
    return player:usedSkillTimes(jingzhezhi.name, Player.HistoryPhase) == 0 and not player:isKongcheng()
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    if not player:isKongcheng() then
        player:throwAllCards("h", jingzhezhi.name)
    end
    room:addPlayerMark(target, "jingzhezhi-turn", 1)
    if player:getMark("ying_guyusheng") == 0 then
      room:setPlayerMark(player, "ying_guyusheng", target.id)
      room:setPlayerMark(target, "@@jingzhezhi", 1)
    end
    local archery_attack = Fk:cloneCard("archery_attack")
      local tos = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(archery_attack, p)
      end)
      local targets = tos
      room:sortByAction(targets)
      local card_use = room:useVirtualCard("archery_attack", nil, player, targets, jingzhezhi.name, true)
      card_use.skillName = jingzhezhi.name
  end,
})

jingzhezhi:addEffect(fk.CardUsing, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jingzhezhi.name)
    and table.contains(data.card.skillNames, jingzhezhi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
  end,
})

jingzhezhi:addEffect(fk.DamageCaused, {
  can_trigger = function (self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, jingzhezhi.name)
    and player:hasSkill(jingzhezhi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(-1)
    if player:getSwitchSkillState(jingzhezhi.name, true) == fk.SwitchYang then
        for _, p in ipairs(Fk:currentRoom().alive_players) do
            if p:getMark("jingzhezhi-turn") > 0 and not p:isNude() then
                local cards = room:askToCards(p, {
                min_num = 1,
                max_num = 1,
                include_equip = true,
                skill_name = jingzhezhi.name,
                prompt = "#jingzhezhi-ask",
                cancelable = false,
                })
                room:recastCard(cards, p, jingzhezhi.name)
            end
        end
    elseif player:getSwitchSkillState(jingzhezhi.name, true) ~= fk.SwitchYang then
        for _, p in ipairs(Fk:currentRoom().alive_players) do
            if p:getMark("jingzhezhi-turn") > 0 then
                 p:drawCards(1, jingzhezhi.name)
            end
        end
    end
  end,
})

return jingzhezhi