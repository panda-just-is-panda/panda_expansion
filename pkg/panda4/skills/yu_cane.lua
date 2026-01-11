local cane = fk.CreateSkill{
  name = "yu_cane",
tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["yu_cane"] = "残厄",
  [":yu_cane"] = "锁定技，你造成/受到伤害时，摸两张牌并将本技能交给上家/下家：本技能每来回途经一名角色后,“神徐荣”对其造成1点火焰伤害。",

  ["@@cane_gain"] = "残厄 获得过",
  ["@@cane_lost"] = "残厄 失去过",
}

cane:addEffect(fk.DamageInflicted, {
anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(cane.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = player:getNextAlive()
    player:drawCards(2, cane.name)
    room:handleAddLoseSkills(player, "-yu_cane", nil, false, true)
    room:addPlayerMark(player, "@@cane_lost")
    room:handleAddLoseSkills(to, "yu_cane", nil, false, true)
    room:addPlayerMark(to, "@@cane_gain")
    for _, q in ipairs(room:getAlivePlayers()) do
        if q:getMark("@@cane_lost") > 0 and q:getMark("@@cane_gain") > 0 then
            for _, p in ipairs(room.players) do
                if p.general == "yu_xurong" or p.deputyGeneral == "yu_xurong" then
                    room:damage{
                        from = p,
                        to = q,
                        damage = 1,
                        damageType = fk.FireDamage,
                        skillName = cane.name,
                    }
                    if not q.dead then 
                        room:setPlayerMark(q, "@@cane_gain", 0)
                        room:setPlayerMark(q, "@@cane_lost", 0)
                    end
                end
            end
        end
    end
  end,
})

cane:addEffect(fk.DamageCaused, {
anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(cane.name)
    
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = player:getLastAlive()
    player:drawCards(2, cane.name)
    room:handleAddLoseSkills(player, "-yu_cane", nil, false, true)
    room:addPlayerMark(player, "@@cane_lost")
    room:handleAddLoseSkills(to, "yu_cane", nil, false, true)
    room:addPlayerMark(to, "@@cane_gain")
    for _, q in ipairs(room:getAlivePlayers()) do
        if q:getMark("@@cane_lost") > 0 and q:getMark("@@cane_gain") > 0 then
            for _, p in ipairs(room.players) do
                if p.general == "yu_xurong" or p.deputyGeneral == "yu_xurong" then
                    room:damage{
                        from = p,
                        to = q,
                        damage = 1,
                        damageType = fk.FireDamage,
                        skillName = cane.name,
                    }
                    if not q.dead then 
                        room:setPlayerMark(q, "@@cane_gain", 0)
                        room:setPlayerMark(q, "@@cane_lost", 0)
                    end
                end
            end
        end
    end
  end,
})

return cane