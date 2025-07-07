local chuangzao = fk.CreateSkill({
  name = "pang_chuangzao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

chuangzao:addEffect("active", {
  anim_type = "control",
  prompt = "#chuangzao1",
    target_num = 0,
  min_card_num = 2,
  max_card_num = 3,
  can_use = function(self, player)
    return player:usedSkillTimes(chuangzao.name, Player.HistoryPhase) < 2
  end,
  card_filter = function(self, player, to_select, selected)
    if #selected < 3 and not player:prohibitDiscard(to_select) then
      if #selected == 0 then
        return true
      elseif #selected == 1 and
       Fk:getCardById(to_select).type ~= Fk:getCardById(selected[1]).type then
          return true
       elseif #selected == 2 and
       Fk:getCardById(to_select).type ~= Fk:getCardById(selected[1]).type and
       Fk:getCardById(to_select).type ~= Fk:getCardById(selected[2]).type then
        return true
        end
    end
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local x = #effect.cards
    local ids = room:getCardsFromPileByRule(".|.|.|.|.|equip|", x, "allPiles")
    local get = ids
    room:moveCardTo(get, Player.Hand, player, fk.ReasonJustMove, chuangzao.name, nil, true, player)
    room:cleanProcessingArea(ids)
end
})


Fk:loadTranslationTable {["pang_chuangzao"] = "创造",
[":pang_chuangzao"] = "出牌阶段限两次，你可以弃置至少两张类型不同的牌，然后你亮出牌堆或弃牌堆中的等量张装备牌并获得其中一张。",
["#chuangzao1"] = "弃置任意张类型均不同的牌并获得一张装备牌",
["#chuangzao2"] = "获得其中一张牌",
}
return chuangzao