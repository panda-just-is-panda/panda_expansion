local tongchu_active = fk.CreateSkill({
  name = "pang_tongchu_active&",
})

Fk:loadTranslationTable{
  ["pang_tongchu_active&"] = "铜储",
  [":pang_tongchu_active&"] = "出牌阶段限一次，你可以将一张牌扣置于铜傀儡的武将牌上，称为“货”。",

  ["#pang_tongchu_use"] = "铜储：将一张牌扣置于铜傀儡的武将牌上，称为“货”",
  ["#pang_tongchu_select"] = "铜储：将一张牌扣置于铜傀儡的武将牌上，称为“货”",
}

tongchu_active:addEffect("active", {
  prompt = "#pang_tongchu_use",
  card_num = 1,
  target_num = 0,
  can_use = function(self, player)
    local targetRecorded = player:getTableMark("tongchu_targets-phase")
    return table.find(Fk:currentRoom().alive_players, function(p)
      return p:hasSkill("pang_tongchu", true) and not table.contains(targetRecorded, p.id) 
      and #p:getPile("$copper_golem_huo") < 5
    end)
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local targets = table.filter(room.alive_players, function(p)
      return p:hasSkill("pang_tongchu") and
      not table.contains(player:getTableMark("tongchu_targets-phase"), p)
    end)
    local target
    if #targets == 1 then
      target = targets[1]
    else
      target = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = "pang_tongchu",
        prompt = "#pang_tongchu_select",
        cancelable = false,
      })[1]
    end
    if not target then return end
    room:addTableMarkIfNeed(player, "tongchu_targets-phase", target.id)
    room:notifySkillInvoked(target, "pang_tongchu")
    room:doIndicate(player.id, { target.id })
    target:addToPile("$copper_golem_huo", effect.cards[1], false, "pang_tongchu")
  end,
})

return tongchu_active