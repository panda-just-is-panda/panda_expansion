local pingshi = fk.CreateSkill {
  name = "mo_pingshi",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["mo_pingshi"] = "平师",
  [":mo_pingshi"] = "主公技，吴势力角色的回合开始时，你可以调整X为其体力值并对其发动“秤衡”。",

}

pingshi:addEffect(fk.TurnStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(pingshi.name) and player.room.current.kingdom == "wu" and player.room.current.hp ~= player:getMark("@mo_chengheng") then
        return true
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local to = player.room.current
    local X = player.room.current.hp
    room:setPlayerMark(player, "@mo_chengheng", X)
    if X > to:getHandcardNum() then
      to:drawCards(1, "mo_chengheng")
      room:addPlayerMark(player, "@mo_chengheng_mo", 1)
    elseif X < to:getHandcardNum() then
      room:askToDiscard(to, {
          skill_name = "mo_chengheng",
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = false,
        })
      room:addPlayerMark(player, "@mo_chengheng_qi", 1)
    end
  end,
})

return pingshi