
local tanta = fk.CreateSkill({
  name = "pang_tanta", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

tanta:addEffect("viewas", {
  anim_type = "offensive",
  prompt = "#pang_tanta",
  mute_card = true,
  pattern = "slash",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    if #selected > 4 then return false end
    return #selected < 4
  end,
  view_as = function(self, player, cards)
    if #cards ~= 4 then
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
tanta:addEffect(fk.DamageCaused, {
  prompt = "#tanta_shield",
  can_trigger = function (self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, tanta.name)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = player
    room:changeShield(to, 1)
  end,
})


Fk:loadTranslationTable{["pang_tanta"] = "坦踏",
  [":pang_tanta"] = "你可以将四张牌作为无次数限制的【杀】使用，然后若此【杀】造成了伤害，你可以获得1点护甲。",
  ["#pang_tanta"] = "坦踏：将四张牌作为【杀】使用，若造成伤害则获得护甲",
  ["#tanta_shield"] = "你可以获得1点护甲"
}

return tanta