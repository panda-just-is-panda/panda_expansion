local juansha = fk.CreateSkill({
  name = "yu_juansha",
})

Fk:loadTranslationTable{
  ["yu_juansha"] = "卷沙",
  [":yu_juansha"] = "你可以跳过出牌阶段，重铸任意张黑色牌，然后依次使用等量张红色牌，若末消耗完使用次数，你下一次受到的伤害值增加此次剩余次数。",

  ["#juansha_invoke"] = "卷沙：你可以跳过出牌阶段，重铸任意张黑色牌，然后使用至多等量张红色牌",
  ["#juansha_use"] = "卷沙：使用红色牌（剩余%arg张）",
  ["#juansha_chongzhu"] = "卷沙：重铸任意张黑色牌",
  ["@juansha"] = "伤害增加",


}

juansha:addEffect(fk.EventPhaseChanging, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(juansha.name) and not data.skipped and data.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = juansha.name,
      prompt = "#juansha_invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data.skipped = true
    if player.dead then return end
    local cards = table.filter(player:getCardIds("he"), function(id)
        local c = Fk:getCardById(id)
        return c and c.color == c.Black
    end)
    local X = 0
    if #cards > 0 then
        local chongzhu = room:askToCards(player, {
            target = target,
            min_num = 0,
            max_num = 999,
            include_equip = true,
            prompt = "#juansha_chongzhu",
            pattern = tostring(Exppattern{ id = cards }),
            skill_name = juansha.name,
        })
        if #chongzhu > 0 then
            room:recastCard(chongzhu, player, juansha.name)
            X = #chongzhu
            local cards2 = table.filter(player:getCardIds("h"), function(id)
                local c = Fk:getCardById(id)
                return c and c.color == c.Red
            end)
            while true do
                cards2 = table.filter(player:getCardIds("h"), function(id)
                  local c = Fk:getCardById(id)
                  return c and c.color == c.Red
                end)
                local use = room:askToUseRealCard(player, {
                    pattern = tostring(Exppattern{ id = cards2 }),
                    skill_name = juansha.name,
                    prompt = "#juansha_use:::"..X,
                    extra_data = {
                        bypass_times = true,
                        extraUse = true,
                    }
                })
                if use then
                    X = X - 1
                else
                    break
                end
                if X == 0 then
                    break
                end
            end
        end
        if X > 0 then
            room:addPlayerMark(player, "@juansha", X)
        end
    end
  end,
})

juansha:addEffect(fk.DamageInflicted, {
anim_type = "negative",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@juansha") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(player:getMark("@juansha"))
    room:setPlayerMark(player, "@juansha", 0)
  end,
})

return juansha