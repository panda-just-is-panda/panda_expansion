local zhuri = fk.CreateSkill {
  name = "mo_zhuri",
  tags = {},
}

zhuri:addEffect(fk.TargetSpecifying, {
  anim_type = "offensive",
   can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhuri.name) and
      player:usedSkillTimes(zhuri.name, Player.HistoryTurn) < 2 and
      (data.card.type == Card.TypeBasic or data.card:isCommonTrick()) and
      (#data.use.tos > 1 or #data.use.tos == 1 and data.use.tos[1] ~= player)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targeting = {}
    for _, p in ipairs(data.use.tos) do
        if p ~= player and not p:isKongcheng() then
          table.insert(targeting, 1, p)
        end
        end
    local to = room:askToChoosePlayers(player, {
      targets = targeting,
      min_num = 1,
      max_num = 1,
      prompt = "#zhuri_pindian",
      skill_name = zhuri.name,
      cancelable = true,
    })
    if #to > 0 then
        local pindian = player:pindian({to[1]}, zhuri.name)
        if pindian.results[target].winner ~= player then
            room:addTableMarkIfNeed(player, "@mo_zhuri", data.card.number)
        end
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data.additionalEffect = (data.additionalEffect or 0) + 1
  end,
})

zhuri:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    if table.contains(player:getTableMark("@mo_zhuri"), card.number .. "_char") then
      local subcards = card:isVirtual() and card.subcards or {card.id}
      return #subcards > 0 and
        table.every(subcards, function(id)
          return table.contains(player:getCardIds("h"), id)
        end)
    end
  end,
  prohibit_response = function(self, player, card)
    if table.contains(player:getTableMark("@mo_zhuri"), card.number .. "_char") then
      local subcards = card:isVirtual() and card.subcards or {card.id}
      return #subcards > 0 and
        table.every(subcards, function(id)
          return table.contains(player:getCardIds("h"), id)
        end)
    end
  end,
})

Fk:loadTranslationTable {["pang_zhuri"] = "逐日",
[":pang_zhisu"] = "每回合限两次，当你使用基本牌或普通锦囊牌指定目标时，你可以与一名目标角色拼点，令此牌额外结算一次；若你没赢，则你此后无法使用或打出与使用牌点数相同的牌，然后此技能视为本回合未发动过。",
["#zhuri_pindian"] = "你可以和一名目标角色拼点",
 ["@mo_zhuri"] = "逐日",
}

return zhuri