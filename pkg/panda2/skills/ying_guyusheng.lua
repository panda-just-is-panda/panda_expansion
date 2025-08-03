local guyusheng = fk.CreateSkill{
  name = "ying_guyusheng",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["ying_guyusheng"] = "谷雨声",
  [":ying_guyusheng"] = "锁定技，当首名被〖惊蛰至〗指定的角色失去所有手牌后，你回复1点体力。",

}

guyusheng:addLoseEffect(function (self, player)
  local room = player.room
  if player:getMark(guyusheng.name) ~= 0 then
    local to = room:getPlayerById(player:getMark(guyusheng.name))
    if not table.find(room:getOtherPlayers(player, false), function (p)
      return p:getMark(guyusheng.name) == to.id
    end) then
      room:setPlayerMark(to, "@@jingzhezhi", 0)
    end
  end
end)

guyusheng:addEffect(fk.AfterCardsMove, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(guyusheng.name) and player:isWounded() and player:getMark(guyusheng.name) ~= 0 then
      for _, move in ipairs(data) do
        if move.from and player:getMark(guyusheng.name) == move.from.id and move.from:isKongcheng() then
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