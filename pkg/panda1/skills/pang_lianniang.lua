local lianniang = fk.CreateSkill({
  name = "pang_lianniang", ---技能内部名称，要求唯一性
  tags = {},
})

lianniang:addEffect("active", {
  anim_type = "offensive",
  prompt = "#lianniang",
  max_phase_use_time = 1,
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(lianniang.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and not to_select:isNude()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local card1 = room:askToChooseCard(player, {
          target = target,
          skill_name = lianniang.name,
          prompt = "lian_ask",
          flag = "he",
        })
    room:throwCard(card1, lianniang.name, target, player)
    if not target:isNude() and Fk:getCardById(card1).color == Fk:getCardById(card1).Black then
        local card2 = room:askToCards(target, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = lianniang.name,
        pattern = ".|.|spade,club",
        prompt = "niang_ask",
        cancelable = true,
      })
        if #card2 > 0 then
            room:throwCard(card2, lianniang.name, target, target)
            target:drawCards(3)
        end
    elseif not target:isNude() and Fk:getCardById(card1).color == Fk:getCardById(card1).Red then
        local card2 = room:askToCards(target, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = lianniang.name,
        pattern = ".|.|heart,diamond",
        prompt = "niang_ask",
        cancelable = true,
      })
        if #card2 > 0 then
            room:throwCard(card2, lianniang.name, target, target)
            target:drawCards(3)
        end
    end
  end,
})

Fk:loadTranslationTable {["pang_lianniang"] = "炼酿",
[":pang_lianniang"] = "出牌阶段限一次，你可以弃置一名角色一张牌，然后其可以弃置一张和此牌颜色相同的牌并摸三张牌。",
["#lianniang"] = "你可弃置一名角色一张牌，然后其可弃置一张颜色相同的牌并摸牌",
["lian_ask"] = "弃置其一张牌",
["niang_ask"] = "你可以弃置一张和被弃置的牌颜色相同的牌并摸三张牌",
}
return lianniang