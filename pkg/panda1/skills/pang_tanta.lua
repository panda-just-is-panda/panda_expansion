local skill = fk.CreateSkill({
  name = "pang_tanta", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

skill:addEffect("viewas", {
  anim_type = "offensive",
  mute_card = true,
  pattern = "slash",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected == 3 then return false end
    local record = Self:getTableMark("@hs__luanji-turn")
    return not table.contains(record, Fk:getCardById(to_select):getSuitString(true))
  end,
  view_as = function(self, player, cards)
    if #cards ~= 3 then
      return nil
    end
    local card = Fk:cloneCard("slash")
    card.skillName = skill.name
    card:addSubcards(cards)
    return card
  end,
  before_use = function(self, player, use)
    local room = player.room
    local record = player:getTableMark("@hs__luanji-turn")
    local cards = use.card.subcards
    for _, cid in ipairs(cards) do
      local suit = Fk:getCardById(cid):getSuitString(true)
      if suit ~= "log_nosuit" then table.insertIfNeed(record, suit) end
    end
    room:setPlayerMark(player, "@hs__luanji-turn", record)
  end
})
skill:addEffect("targetmod", {
  bypass_times = function (self, player, skill, scope, card, to)
    return card and table.contains(card.skillNames, skill.name)
  end,
})

Fk:loadTranslationTable{["pang_tanta"] = "坦踏",
  [":pang_tanta"] = "你可以将三张牌作为无次数限制的【杀】使用，然后若其中不包含装备牌，你获得1点护甲且此技能本回合失效。",
  ["#pang_tanta"] = "坦踏：你可将三张牌作为无次数限制【杀】使用；若没有装备牌则你获得护甲且此技能本回合失效",
}

return skill