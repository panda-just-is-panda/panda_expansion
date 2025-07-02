local jielve = fk.CreateSkill({
  name = "pang_jielve", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

jielve:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jielve.name) and
      player.phase == Player.Start
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room.alive_players,
      skill_name = jielve.name,
      prompt = "#pang_jielve",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local user = event:getCostData(self).tos[1]
    local use = room:askToPlayCard(player, {
      skill_name = jielve.name,
      prompt = "jielve_use",
      cancelable = true,
      extra_data = {
        bypass_times = true,
        extraUse = true,
        skillName = jielve.name
      },
      skip = true,
    })
    if use then
      use.extraUse = true
      room:useCard(use)
    else
        user:drawCards(1, jielve.name)
    end
  end,
})

jielve:addEffect(fk.Damage, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jielve.name) and data.card and
        table.contains(data.card.skillNames, jielve.name)
        and not data.to:isNude() and not player.dead and not data.to.dead
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local card = room:askToChooseCard(player, {
      target = data.to,
      flag = "he",
      skill_name = jielve.name,
    })
    room:obtainCard(player, card, false, fk.ReasonPrey, player.id, jielve.name)
  end,
})

Fk:loadTranslationTable {["pang_jielve"] = "劫掠",
[":pang_jielve"] = "准备阶段，你可以令一名角色选择摸一张牌或使用一张牌；当一名角色受到因此使用的牌造成的伤害后，你获得其一张牌。",
["#pang_jielve"] = "你可以令一名角色选择摸牌或使用牌",
["jielve_use"] = "你可以使用一张牌，或点取消摸一张牌",
}
return jielve