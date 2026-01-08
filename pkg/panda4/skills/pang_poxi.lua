local poxi = fk.CreateSkill({
  name = "pang_poxi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

poxi:addEffect("active", {
  anim_type = "control",
  prompt = "#pang_poxi",
  min_card_num = 1,
  target_num = 1,
  max_phase_use_time = 1,
  card_filter = function(self, player, to_select)
    return not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and not to_select:isNude()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local to = effect.tos[1]
    local number_player = 0
    local number_to = 0
    for _, id in ipairs(effect.cards) do
      number_player = number_player + Fk:getCardById(id).number
    end
    room:throwCard(effect.cards, poxi.name, player, player)
    local discarding 
    discarding = room:askToChooseCards(player, {
          target = to,
          min = 1,
          max = 5,
          flag = "he",
          skill_name = poxi.name,
          prompt = "#poxi_discard:"..to.id,
        })
    if #discarding > 0 then
        local cards = discarding
        room:throwCard(cards, poxi.name, to, player) 
        for _, id in ipairs(cards) do
            number_to = number_to + Fk:getCardById(id).number
        end
    end
    if number_player < number_to and not player.dead then
        room:damage{
              from = to,
              to = player,
              damage = 2,
              skillName = poxi.name,
            }
    end
end
})


Fk:loadTranslationTable {["pang_poxi"] = "魄袭",
[":pang_poxi"] = "出牌阶段限一次，你可以弃置任意张牌，然后弃置一名其他角色至多五张牌；若你弃置的牌点数之和小于其，其对你造成2点伤害。",
["#pang_poxi"] = "你可以弃置任意张牌，然后弃置一名其他角色任意张牌；若你弃置的牌点数之和小于其，其对你造成2点伤害",
["#poxi_discard"] = "魄袭：弃置 %src 至多四张牌",

  ["$pang_poxi1"] = "击敌不备，奇袭拔寨！",
  ["$pang_poxi2"] = "轻羽透重铠，奇袭溃坚城！",
}
return poxi