local niliu = fk.CreateSkill({
  name = "pang_niliu", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

niliu:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  mute = true,
  can_refresh = function(self, event, target, player, data)
    if player:hasSkill(niliu.name) then
      for _, move in ipairs(data) do
        if move.moveReason == fk.ReasonDiscard and move.from then
            for _, info in ipairs(move.moveInfo) do
                if (info.fromArea == Card.PlayerHand or info.fromArea == Card.PlayerEquip) and
                move.from:getMark("@@niliu") == 0 then
                    player.room:addPlayerMark(move.from, "@@niliu")
                    return true
                end
            end
            end
          end
      end
  end,
    on_refresh = function(self, event, target, player, data)
  end,
})

niliu:addEffect(fk.TurnEnd, {
  anim_type = "special",
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(niliu.name)
  end,
  on_refresh = function(self, event, target, player, data)
    for _, p in ipairs(player.room.alive_players) do
      player.room:setPlayerMark(p, "@@niliu", 0)
    end
  end,
})

niliu:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and data.from == player and data.to:getMark("@@niliu") > 0
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

niliu:addEffect(fk.DamageInflicted, {
  anim_type = "defensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and data.to == player and data.from:getMark("@@niliu") > 0
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(-1)
  end,
})

Fk:loadTranslationTable {["pang_niliu"] = "逆流",
[":pang_niliu"] = "锁定技，本回合因弃置失去过牌的角色：对你造成的伤害-1；受到你造成的伤害+1。",
["@@niliu"] = "逆流"
}
return niliu