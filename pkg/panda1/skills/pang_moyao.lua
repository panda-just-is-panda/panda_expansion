local moyao = fk.CreateSkill({
  name = "pang_moyao", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

moyao:addEffect(fk.AfterCardsMove, {
  can_refresh = function (self, event, target, player, data)
    local room = player.room
    if player:hasSkill(moyao.name) then
      for _, move in ipairs(data) do
        if move.toArea == Card.DiscardPile then
          if move.moveReason == fk.ReasonDiscard and move.from and move.from == player then
            for _, info in ipairs(move.moveInfo) do
              if (info.fromArea == Card.PlayerHand or info.fromArea == Card.PlayerEquip) then
                return true
              end
            end
        end
    end
end
end
end,
    on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "moyao_losehp-turn", 1)
    end,
        })

moyao:addEffect(fk.TurnEnd, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(moyao.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if player:getMark("moyao_losehp-turn") > 0 then
        local card = room:askToDiscard(player, {
          skill_name = moyao.name,
          prompt = "#moyao_discard",
          cancelable = true,
          min_num = 1,
          max_num = 1,
          include_equip = true,
        })
        if #card > 0 then return true
        end
    else
       if room:askToSkillInvoke(player, {
      skill_name = moyao.name,
      prompt = "#moyao_ask",
      }) then
      return true
    end
    end
  end,
   on_use = function(self, event, target, player, data)
    local room = player.room
    if player:getMark("moyao_losehp-turn") > 0 then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room.alive_players,
        skill_name = moyao.name,
        prompt = "#moyao1",
        cancelable = false,
        })
        if #tos > 0 then
        room:loseHp(tos[1], 1, moyao.name)
        end
    else
        local targets = table.filter(room.alive_players, function (p)
          return p:isWounded()
        end)
        player:drawCards(1, moyao.name)
        if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = moyao.name,
        prompt = "#moyao2",
        cancelable = false,
        })
        if #tos > 0 then
        room:recover({who = tos[1], num = 1, recoverBy = player, skillName = moyao.name})
        end
        end
    end
   end
})

Fk:loadTranslationTable {["pang_moyao"] = "魔药",
[":pang_moyao"] = "回合结束时，若你本回合因弃置失去过牌，你可以弃置一张牌并令一名角色失去1点体力，否则你可以摸一张牌并令一名角色回复1点体力。",
["#moyao1"] = "令一名角色失去1点体力",
["#moyao2"] = "令一名角色回复1点体力",
["#moyao_discard"] = "你可以弃置一张牌并令一名角色失去1点体力",
["#moyao_ask"] = "你可以摸一张牌并令一名角色回复1点体力",
}
return moyao