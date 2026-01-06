local mouHujia = fk.CreateSkill({
  name = "mo_hujia",
  tags = { Skill.Lord },
})

Fk:loadTranslationTable{
  ["mo_hujia"] = "护驾",
  [":mo_hujia"] = "主公技，每名其他魏势力角色限一次，当你受到伤害时，可以令其代替之。",

  ["#mou__hujia-choose"] = "护驾：你可以将伤害转移给一名魏势力角色",


}

mouHujia:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    local targets = table.filter(player.room:getOtherPlayers(player, false), function(p) return p.kingdom == "wei" and p:getMark("mo_hujia") == 0  end)
    return #targets > 0 and player:hasSkill(mouHujia.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local targets = table.filter(player.room:getOtherPlayers(player, false), function(p) return p.kingdom == "wei" and p:getMark("mo_hujia") == 0 end)
    if #targets > 0 then
      local to = player.room:askToChoosePlayers(
        player,
        {
          targets = targets,
          min_num = 1,
          max_num = 1,
          prompt = "#mou__hujia-choose",
          skill_name = mouHujia.name
        }
      )
      if #to > 0 then
        event:setCostData(self, { tos = to })
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]

    local damage = data.damage
    data:preventDamage()
    room:damage{
      from = data.from,
      to = to,
      damage = damage,
      damageType = data.damageType,
      skillName = data.skillName,
      chain = data.chain,
      card = data.card,
    }

    room:setPlayerMark(to, "mo_hujia", 1)
  end,
})

return mouHujia