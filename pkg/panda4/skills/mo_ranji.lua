local ranji = fk.CreateSkill{
  name = "mo_ranji",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["mo_ranji"] = "燃己",
  [":mo_ranji"] = "限定技，当你失去所有手牌后，可以将手牌摸至“逐日”已记录点数量的牌。",

  ["#ranji"] = "燃己：你可以将手牌摸至%arg张",

}


ranji:addEffect(fk.AfterCardsMove, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(ranji.name) or not player:isKongcheng() or player:usedSkillTimes(ranji.name, Player.HistoryGame) > 0 then return end
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
  on_cost = function(self, event, target, player, data)
    local num = player:getMark("ranji_count")
    return player.room:askToSkillInvoke(player, {
      skill_name = ranji.name,
      prompt = "#ranji:::"..num,
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local num = player:getMark("ranji_count")
    local to_draw = num - player:getHandcardNum()
    if to_draw > 0 then
        player:drawCards(to_draw, ranji.name)
    end
  end,
})



return ranji