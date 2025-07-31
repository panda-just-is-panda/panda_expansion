local huoshou = fk.CreateSkill {
  name = "pang_huoshou",
  tags = { Skill.Lord, Skill.Compulsory },
}

huoshou:addEffect(fk.TargetSpecifying, {
anim_type = "offensive",
can_trigger = function(self, event, target, player, data)
    return target ~= player and target.kingdom ~= "shu" and player:hasSkill(huoshou.name) 
    and data.firstTarget and data.card.name == "savage_assault"
  end,
on_use = function(self, event, target, player, data)
    local room = player.room
    data:cancelAllTarget()
    local savage_assault = Fk:cloneCard("savage_assault")
      local tos = table.filter(room:getOtherPlayers(player, false), function (ids)
      return player:canUseTo(savage_assault, ids)
      end)
      local targets = tos
      room:sortByAction(targets)
      room:useVirtualCard("savage_assault", nil, player, targets, huoshou.name, true)
  end,
})

Fk:loadTranslationTable{
  ["pang_huoshou"] = "祸首",
  [":pang_huoshou"] = "主公技，锁定技，当非蜀势力的其他角色使用【南蛮入侵】指定目标时，取消之，然后你视为使用一张【南蛮入侵】。",

  ["$pang_huoshou1"] = "背黑锅我来，送死？你去！",
  ["$pang_huoshou2"] = "统统算我的！",
}



    return huoshou