local anzuo = fk.CreateSkill{
  name = "bai_anzuo",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["bai_anzuo"] = "按祚",
  [":bai_anzuo"] = "限定技，出牌阶段，你可令一名角色加1点体力上限，其每回合首次：失去所有手牌后，回复1点体力；回满体力后，减1点体力上限。",

  ["#anzuo"] = "你可以令一名角色加1点体力上限",
  ["@@anzuo"] = "被按祚"

}

anzuo:addEffect("active", {
  anim_type = "support",
  prompt = "#anzuo",
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(anzuo.name, Player.HistoryGame) == 0
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:changeMaxHp(target, 1)
    room:addPlayerMark(target, "@@anzuo", 1)
  end,
})

anzuo:addEffect(fk.AfterCardsMove, {
  anim_type = "control",
  can_refresh = function(self, event, target, player, data)
    if player:getMark("@@anzuo") < 1 or player:getMark("anzuo_buff-turn") > 0 or not player:isKongcheng() then return end
    local ret = false
    for _, move in ipairs(data) do
      if move.from == player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerHand then
            ret = true
            break
          end
        end
      end
    end
    if ret then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    if player:isWounded() then
        player.room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = anzuo.name
      })
      player.room:addPlayerMark(target, "anzuo_buff-turn", 1)
    end
  end,
})

anzuo:addEffect(fk.HpRecover, {
  anim_type = "negative",
  can_refresh = function(self, event, target, player, data)
    return target:getMark("@@anzuo") > 0 and target:getMark("anzuo_negative-turn") < 1 and not target:isWounded()
  end,
  on_refresh = function(self, event, target, player, data)
    local to = target
    local room = player.room
    room:changeMaxHp(target, -1)
    room:addPlayerMark(target, "anzuo_negative-turn", 1)
  end,
})

return anzuo