local zaichen = fk.CreateSkill {
  name = "pang_zaichen",
  tags = {Skill.Switch},
}

Fk:loadTranslationTable{
  ["pang_zaichen"] = "再臣",
  [":pang_zaichen"] = "转换技，①当你成为牌的目标后，你可以令一名本回合失去过牌的角色摸一张牌。②当你受到伤害后，伤害来源可以将手牌数摸至体力上限，然后你回复1点体力。",

  [":pang_zaichen_yang"] = "转换技，<font color=\"#E0DB2F\">①当你成为牌的目标后，你可以令一名本回合失去过牌的角色摸一张牌。</font>②当你受到伤害后，伤害来源可以将手牌数摸至体力上限，然后你回复1点体力。",
  [":pang_zaichen_yin"] = "转换技，①当你成为牌的目标后，你可以令一名本回合失去过牌的角色摸一张牌。<font color=\"#E0DB2F\">②当你受到伤害后，伤害来源可以将手牌数摸至体力上限，然后你回复1点体力。</font>",

  ["#zaichen-choose"] = "再臣：你可以令一名本回合失去过牌的角色摸一张牌",
  ["#zaichen-invoke"] = "再臣：你可以将手牌摸至体力上限并令%dest回复1点体力",

}

zaichen:addEffect(fk.TargetConfirmed, {
  anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return player:getSwitchSkillState(zaichen.name, false) == fk.SwitchYang
    and target == player and player:hasSkill(zaichen.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room.alive_players, function(p)
      return p:getMark("pang_zaichen-turn") > 0
      end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = zaichen.name,
      prompt = "#zaichen-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    event:getCostData(self).tos[1]:drawCards(1, zaichen.name)
  end,
})

zaichen:addEffect(fk.Damaged, {
  anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zaichen.name) and
      player:getSwitchSkillState(zaichen.name, false) == fk.SwitchYin and
      data.from and not data.from.dead
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(data.from, {
      skill_name = zaichen.name,
      prompt = "#zaichen-invoke::"..player.id,
    }) then
      event:setCostData(self, {tos = {data.from}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local num = to.maxHp - to:getHandcardNum()
    if num > 0 then
      to:drawCards(num, zaichen.name)
    end
    room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = zaichen.name
      })
  end,
})

zaichen:addEffect(fk.AfterCardsMove, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    if player:hasSkill(zaichen.name) then
      for _, move in ipairs(data) do
        if move.from then
            for _, info in ipairs(move.moveInfo) do
                if (info.fromArea == Card.PlayerHand or info.fromArea == Card.PlayerEquip) and
                move.from:getMark("pang_zaichen-turn") == 0 then
                    player.room:addPlayerMark(move.from, "pang_zaichen-turn")
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


return zaichen