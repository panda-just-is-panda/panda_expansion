local genmao = fk.CreateSkill({
  name = "pang_genmao", 
  tags = {}, 
})

Fk:loadTranslationTable{
  ["pang_genmao"] = "耕贸",
  [":pang_genmao"] = "弃牌阶段开始时和结束时，你可以视为对自己使用一张【五谷丰登】；其他角色可以交给你一张方块牌以成为此【五谷丰登】的额外目标。",
  ["#genmao-give"] = "耕贸：你可以交给%src一张方块牌并成为此【五谷丰登】的额外目标",

  ["$pang_genmao1"] = "哼啊～",
  ["$pang_genmao2"] = "哼啊——",
}

genmao:addEffect(fk.EventPhaseStart, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Discard
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:useVirtualCard("amazing_grace", nil, player, player, genmao.name, true)
  end,
})

genmao:addEffect(fk.EventPhaseEnd, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Discard
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:useVirtualCard("amazing_grace", nil, player, player, genmao.name, true)
  end,
})

genmao:addEffect(fk.TargetConfirming, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(genmao.name) and data.card and table.contains(data.card.skillNames, genmao.name)
    and not data.cancelled
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
      return not table.contains(data.use.tos, p) and
      not data.from:isProhibited(p, data.card)
    end)
    for _, tos in ipairs(targets) do
        local card = room:askToCards(tos, {
        skill_name = genmao.name,
        min_num = 1,
        max_num = 1,
        include_equip = true,
        pattern = ".|.|diamond|hand",
        prompt = "#genmao-give:" .. player.id,
      })
      if #card > 0 then
        room:obtainCard(player, card, true, fk.ReasonGive, tos, genmao.name)
        data:addTarget(tos)
      end
    end
  end,
})

return genmao