local jili = fk.CreateSkill{
  name = "yu_jili",
}

Fk:loadTranslationTable{
  ["yu_jili"] = "蒺藜",
  [":yu_jili"] = "出牌阶段限一次，你可以交换你的攻击范围和手牌数，若你不因此摸牌，可以令一名其他角色也如此做。",

  ["#yu_jili"] = "蒺藜：交换你的攻击范围和手牌数，若不因此摸牌则可以令一名其他角色也如此做",
  ["#jili-choose"] = "蒺藜：你可以令一名其他角色交换攻击范围和手牌数",
  ["#jili_discard"] = "蒺藜：弃置%arg张牌",
  ["@yu_jili"] = "攻击范围",

  ["$yu_jili1"] = "蒺藜骨朵，威震慑敌！",
  ["$yu_jili2"] = "看我一招，铁蒺藜骨朵！",
}

jili:addEffect("active", {
  anim_type = "control",
  card_num = 0,
  target_num = 0,
  prompt = "#yu_jili",
  max_phase_use_time = 1,
  on_use = function(self, room, effect)
    local player = effect.from
    local room = player.room
    local hand_num = player:getHandcardNum()
    local atk_range = player:getAttackRange()
    local difference
    if hand_num > atk_range then
        difference = hand_num - atk_range
        local discard = room:askToDiscard(player, {
          skill_name = jili.name,
          prompt = "#jili_discard:::"..difference,
          cancelable = false,
          min_num = difference,
          max_num = difference,
          include_equip = false,
        })
        room:setPlayerMark(player, "@yu_jili", hand_num)
    end
    if hand_num < atk_range then
        difference = atk_range - hand_num
        room:setPlayerMark(player, "@yu_jili", hand_num)
        player:drawCards(difference, jili.name)
    end
    if hand_num >= atk_range then
        local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = room:getOtherPlayers(player, false),
            skill_name = jili.name,
            prompt = "#jili-choose",
            cancelable = true,
        })
        if #tos > 0 then
            local to = tos[1]
            local to_hand_num = to:getHandcardNum()
            local to_atk_range = to:getAttackRange()
            if to_hand_num > to_atk_range then
                difference = to_hand_num - to_atk_range
                local to_discard = room:askToDiscard(to, {
                    skill_name = jili.name,
                    prompt = "#jili_discard:::"..difference,
                    cancelable = false,
                    min_num = difference,
                    max_num = difference,
                    include_equip = false,
                })
                room:setPlayerMark(to, "@yu_jili", to_hand_num)
            end
            if to_hand_num < to_atk_range then
                difference = to_atk_range - to_hand_num
                room:setPlayerMark(to, "@yu_jili", to_hand_num)
                to:drawCards(difference, jili.name)
            end
        end
    end
  end,
})

jili:addEffect("atkrange", {
  final_func = function (self, player)
    if player:getMark("@yu_jili") > 0 then
      return player:getMark("@yu_jili")
    end
  end
})

jili:addEffect(fk.AfterCardsMove, {
  can_refresh = function(self, event, target, player, data)
    if not player:hasSkill(jili.name) then return false end
    for _, move in ipairs(data) do
      if move.to and move.to:getMark("@yu_jili") > 0 and (move.toArea == Card.PlayerEquip) then
        for _, info in ipairs(move.moveInfo) do
          if Fk:getCardById(info.cardId).sub_type == Card.SubtypeWeapon then
            return true
          end
        end
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    for _, move in ipairs(data) do
        if move.to and move.to:getMark("@yu_jili") > 0 and (move.toArea == Card.PlayerEquip) then
            for _, info in ipairs(move.moveInfo) do
                if Fk:getCardById(info.cardId).sub_type == Card.SubtypeWeapon then
                    player.room:setPlayerMark(move.to, "@yu_jili", 0)
                end
            end
        end
    end
  end,
})


return jili