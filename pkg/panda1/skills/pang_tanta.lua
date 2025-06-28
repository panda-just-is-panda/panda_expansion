
local tanta = fk.CreateSkill({
  name = "pang_tanta", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

tanta:addEffect("viewas", {
  anim_type = "offensive",
  mute_card = true,
  pattern = "slash",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected > 3 then return false end
    return #selected < 3
  end,
  view_as = function(self, player, cards)
    if #cards ~= 3 then
      return nil
    end
    local card = Fk:cloneCard("slash")
    card.skillName = tanta.name
    card:addSubcards(cards)
    return card
  end,
  enabled_at_play = function (self, player)
    --这里是在出牌阶段 这个按钮是否亮起来的判断 return true就是亮
    return true
  end,
  enabled_at_response = function (self, player, response)
    --这里是在需要响应别人的牌时 这个按钮是否亮起来的判断 return true就是亮
    if response then return false end
    return true
  end
})
tanta:addEffect("targetmod",{
  bypass_times = function(self, player, skill, scope, card, to)
    return card and table.contains(card.skillNames, tanta.name)    
  end,
})

Fk:loadTranslationTable{["pang_tanta"] = "坦踏",
  [":pang_tanta"] = "你可以将三张牌作为无次数限制的【杀】使用，",
  ["#pang_tanta"] = "坦踏：将三张牌作为无次数限制【杀】使用",
}

return tanta