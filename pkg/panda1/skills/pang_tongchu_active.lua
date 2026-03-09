local tongchu_active = fk.CreateSkill({
  name = "pang_tongchu_active&",
})

Fk:loadTranslationTable{
  ["pang_tongchu_active&"] = "铜储",
  [":pang_tongchu_active&"] = "出牌阶段限一次，你可以将一张手牌扣置于铜傀儡的武将牌上，称为“货”。",

  ["#pang_tongchu_use"] = "铜储：将一张手牌扣置于铜傀儡的武将牌上，称为“货”",
}

tongchu_active:addEffect("active", {
  prompt = "#pang_tongchu_use",
  card_num = 1,
  target_num = 1,
  can_use = function(self, player)
    local targetRecorded = player:getTableMark("tongchu_targets-phase")
    return table.find(Fk:currentRoom().alive_players, function(p)
      return p:hasSkill("pang_tongchu", true) and not table.contains(targetRecorded, p.id) 
      and #p:getPile("copper_golem_huo") < 5
    end)
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select:hasSkill("pang_tongchu") and
      not table.contains(player:getTableMark("tongchu_targets-phase"), to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:addTableMarkIfNeed(player, "tongchu_targets-phase", target.id)
    target:addToPile("copper_golem_huo", effect.cards[1], false, "pang_tongchu")
  end,
})

return tongchu_active