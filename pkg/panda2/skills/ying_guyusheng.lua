local guyusheng = fk.CreateSkill{
  name = "ying_guyusheng",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["ying_guyusheng"] = "谷雨声",
  [":ying_guyusheng"] = "锁定技，当首名被〖惊蛰至〗指定的角色失去所有手牌后，你回复1点体力。",

}

guyusheng:addEffect(fk.AfterCardsMove, {
  anim_type = "defensive",
  can_refresh = function(self, event, target, player, data)
    if player:isWounded() and player:getMark("@@jingzhezhi") > 0 then
      for _, move in ipairs(data) do
        if move.from and player:getMark("@@jingzhezhi") == move.from.id and move.from:isKongcheng() then
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerHand then
              return true
            end
          end
        end
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:recover({
      who = player,
      num = 1,
      recoverBy = player,
      skillName = guyusheng.name,
    })
  end,
})

return guyusheng