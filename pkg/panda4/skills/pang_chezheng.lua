local chezheng = fk.CreateSkill {
  name = "pang_chezheng",
  tags = { },
}

Fk:loadTranslationTable{
  ["pang_chezheng"] = "掣政",
  [":pang_chezheng"] = "当你造成或受到伤害时，手牌数为全场唯一最大的角色可以交给你一张牌并防止此伤害。",

  ["#chezheng-throw"] = "掣政：你可以交给%src一张牌并防止此伤害。",

  ["$pang_chezheng1"] = "风驰电掣，政权不怠！",
  ["$pang_chezheng2"] = "廉平掣政，实为艰事。",
}

chezheng:addEffect(fk.DamageCaused, {
    mute = true,
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    local num = 0
    local highestplayer
    for hc, p in ipairs(player.room.alive_players) do
        hc = p:getHandcardNum()
        if hc > num then
            num = hc
            highestplayer = p
        end
      end
    return target == player and player:hasSkill(chezheng.name) and highestplayer ~= player and table.every(player.room.alive_players, function(p)
        return highestplayer:getHandcardNum() > p:getHandcardNum()
      end)
  end,
  on_cost = function (self, event, target, player, data)
        local room = player.room
        local highestplayer
        local num
    for hc, p in ipairs(player.room.alive_players) do
        hc = p:getHandcardNum()
        if hc > num then
            num = hc
            highestplayer = p
        end
      end
        local cards = room:askToCards(highestplayer, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            skill_name = chezheng.name,
            prompt = "#chezheng-throw:"..player.id,
            cancelable = true,
            })
        if #cards > 0 then
            room:obtainCard(player, cards, false, fk.ReasonGive)
            return true
        end
      end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(chezheng.name, 2)
    data:preventDamage()
  end,
})

chezheng:addEffect(fk.DamageInflicted, {
    mute = true,
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    local num = 0
    local highestplayer
    for hc, p in ipairs(player.room.alive_players) do
        hc = p:getHandcardNum()
        if hc > num then
            num = hc
            highestplayer = p
        end
      end
    return target == player and player:hasSkill(chezheng.name) and highestplayer ~= player and table.every(player.room.alive_players, function(p)
        return highestplayer:getHandcardNum() > p:getHandcardNum()
      end)
  end,
  on_cost = function (self, event, target, player, data)
        local room = player.room
        local highestplayer
        local num
    for hc, p in ipairs(player.room.alive_players) do
        hc = p:getHandcardNum()
        if hc > num then
            num = hc
            highestplayer = p
        end
      end
        local cards = room:askToCards(highestplayer, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            skill_name = chezheng.name,
            prompt = "#chezheng-throw:"..player.id,
            cancelable = true,
            })
        if #cards > 0 then
            room:obtainCard(player, cards, false, fk.ReasonGive)
            return true
        end
      end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(chezheng.name, 1)
    data:preventDamage()
  end,
})



return chezheng