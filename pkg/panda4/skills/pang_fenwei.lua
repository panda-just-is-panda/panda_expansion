local fenwei = fk.CreateSkill({
  name = "pang_fenwei",
  tags = { Skill.Limited },
})

fenwei:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if not (player:hasSkill(fenwei.name) and player:isKongcheng()) or player:usedSkillTimes(fenwei.name, Player.HistoryGame) > 0 then return end
    for _, move in ipairs(data) do
      if move.from == player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerHand then
            return true
          end
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
        skill_name = fenwei.name,
        prompt = "#fenwei-invoke",
      }) then
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(4, fenwei.name)
    room:endTurn()
    player:gainAnExtraTurn(true, fenwei.name)
  end,
})

Fk:loadTranslationTable {["pang_fenwei"] = "奋威",
[":pang_fenwei"] = "限定技，当你失去最后一张手牌后，你可以摸四张牌并结束当前回合，然后你执行一个额外的回合。",
["#fenwei-invoke"] = "奋威：你可以摸四张牌并结束当前回合，然后执行一个额外的回合。",

  ["$pang_fenwei1"] = "舍身护主，扬吴将之风！",
  ["$pang_fenwei2"] = "袭军挫阵，奋江东之威！",
}

return fenwei