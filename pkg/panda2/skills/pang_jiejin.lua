local jiejin = fk.CreateSkill {
  name = "pang_jiejin",
  tags = {Skill.Compulsory},
}

jiejin:addEffect(fk.Death, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jiejin.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local slash = Fk:cloneCard("slash")
    local max_num = #room:getOtherPlayers(player, false)
  local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(slash, p, {bypass_distances = true, bypass_times = true})
    end)
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = max_num,
      targets = targets,
      skill_name = jiejin.name,
      prompt = "#jiejin-choose",
      cancelable = false,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local targets = event:getCostData(self).tos
    room:sortByAction(targets)
    room:useVirtualCard("thunder__slash", nil, player, targets, jiejin.name, true)
  end,
})

Fk:loadTranslationTable {["pang_jiejin"] = "阶进",
[":pang_jiejin"] = "锁定技，当一名其他角色死亡时，你视为使用一张无距离限制且可以额外指定任意名角色为目标的雷【杀】。",
["#jiejin-choose"] = "你可以视为对任意名角色使用一张雷【杀】",

["$pang_jiejin1"] = "Aim and shoot.",
["$pang_jiejin2"] = "Faraday's miracle.",
}

return jiejin