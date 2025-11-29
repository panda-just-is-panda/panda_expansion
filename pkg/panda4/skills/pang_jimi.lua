local jimi = fk.CreateSkill{
  name = "pang_jimi",
  tags = { },
}

Fk:loadTranslationTable{
  ["pang_jimi"] = "讥谀",
  [":pang_jimi"] = "当一名角色使用装备牌后，若你没有“寸目”，你可以获得“寸目”并移动此牌；当你受到伤害后，若伤害来源没有“寸目”，你可以回复1点体力并令其获得“寸目”。",
  ["#jimi-move"] = "讥谀：你可以移动此装备牌",
  ["#jimi_damage"] = "讥谀：你可以回复1点体力并令%dest获得“寸目”",

  ["$pang_jimi1"] = "陛下，此人不堪大用。",
  ["$pang_jimi2"] = "尔等玩忽职守，依诏降职处置。",
}

jimi:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jimi.name) and not player:hasSkill("cunmu") and data.card.type == Card.TypeEquip
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local cid
    local to = table.find(room:getAlivePlayers(), function (p)
      ---@diagnostic disable-next-line: return-type-mismatch
        return table.find(p:getCardIds("e"), function (id)
          if Fk:getCardById(id) == data.card then
            cid = id
            return true
          end
        end)
    end)
    local targets = table.filter(room.alive_players, function(p)
        return target:canMoveCardInBoardTo(p, cid)
      end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = jimi.name,
      prompt = "#jimi-move",
      cancelable = true,
    })
    if #to > 0 then
        event:setCostData(self, {tos = to})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to_move = data.card
    local to = event:getCostData(self).tos[1]
    room:moveCardIntoEquip(to, to_move, jimi.name, false, player)
    room:handleAddLoseSkills(player, "cunmu")
  end,
})

jimi:addEffect(fk.Damaged, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jimi.name) and
      data.from and not data.from.dead and not data.from:hasSkill("cunmu")
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = jimi.name,
      prompt = "#jimi_damage::"..data.from.id,
    }) then
      event:setCostData(self, {tos = {data.from}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = jimi.name
      })
    room:handleAddLoseSkills(to, "cunmu")
  end,
})

return jimi