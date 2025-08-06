local nihun = fk.CreateSkill {
  name = "bai_nihun",
  tags = {Skill.Compulsory},
}

Fk:loadTranslationTable{
  ["bai_nihun"] = "溺昏",
  [":bai_nihun"] = "锁定技，当你进入濒死状态被救回后，你视为对1名攻击范围内的其他角色使用1张无视防具的【杀】，此【杀】造成伤害后，你弃置其所有手牌。",
  ["#nihun_choose"] = "溺昏：视为对一名攻击范围内的角色使用一张无视目标防具的【杀】",

}


nihun:addEffect(fk.AfterDying, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(nihun.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local slash = Fk:cloneCard("slash")
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(slash, p, {bypass_times = true})
    end)
    if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = nihun.name,
            prompt = "#nihun_choose",
            cancelable = false,
        })
        if #tos > 0 then
            local targets = tos
            room:sortByAction(targets)
            room:useVirtualCard("slash", nil, player, targets, nihun.name, true)
        end
    end
  end,
})

nihun:addEffect(fk.TargetSpecified, {
  can_refresh = function (self, event, target, player, data)
    return data.card and table.contains(data.card.skillNames, nihun.name) and not data.to.dead
  end,
  on_refresh = function (self, event, target, player, data)
    data.to:addQinggangTag(data)
  end,
})

nihun:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, nihun.name)
    and not data.to.dead and not data.to:isKongcheng()
  end,
  on_refresh = function(self, event, target, player, data)
      data.to:throwAllCards("h", nihun.name)
  end,
})

return nihun