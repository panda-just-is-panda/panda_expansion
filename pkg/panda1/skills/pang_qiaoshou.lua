
local qiaoshou = fk.CreateSkill({
  name = "pang_qiaoshou", ---技能内部名称，要求唯一性
})

qiaoshou:addEffect("viewas", {
  anim_type = "offensive",
  prompt = "#pang_qiaoshou",
  mute_card = true,
  pattern = "slash",
  handly_pile = true,
  include_equip = false,
  derived_piles = "meilanni_qiao",
  can_use = function(self, player)
    return player.phase == Player.Play and player:usedSkillTimes(qiaoshou.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return Fk:currentRoom():getCardArea(to_select) ~= Player.Equip
  end,
  view_as = function(self, player, cards)
    if #cards < 1 then
      return nil
    end
    local card = Fk:cloneCard("slash")
    card.skillName = qiaoshou.name
    card:addSubcards(cards)
    return card
  end,
  enabled_at_play = function (self, player)
    return true
  end,
  enabled_at_response = function (self, player, response)
    if response then return false end
    return true
  end
})
qiaoshou:addEffect(fk.DamageCaused, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, qiaoshou.name)
  end,
  on_refresh = function(self, event, target, player, data)
      player:addToPile("meilanni_qiao", data.card, true, qiaoshou.name)
  end,
})


Fk:loadTranslationTable{["pang_qiaoshou"] = "巧手",
  [":pang_qiaoshou"] = "出牌阶段限一次，你可以将任意张手牌作为【杀】使用；当此【杀】造成伤害后，你将这些牌置于武将牌上，称为“巧”。",
  ["#pang_qiaoshou"] = "巧手：将若干张牌作为【杀】使用，若造成伤害则获得“巧”",
  ["meilanni_qiao"] = "巧",
  ["qiaoshou_gain_qiao"] = "你可以将这些牌作为”巧“置于武将牌上",
}

return qiaoshou