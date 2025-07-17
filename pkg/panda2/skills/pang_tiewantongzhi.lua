local tiewan = fk.CreateSkill({
  name = "pang_tiewantongzhi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

tiewan:addEffect(fk.Damage, {
  prompt = "#pang_jigao1",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
     end
})

tiewan:addEffect(fk.Damaged, {
  prompt = "#pang_jigao1",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
     end
})

Fk:loadTranslationTable{["pang_tiewantongzhi"] = "铁腕统治",
  [":pang_tiewantongzhi"] = "当你造成或受到伤害后，你可以视为使用一张【无中生有】或【过河拆桥】；若你本回合发动过此技能，此牌的目标角色需为受到伤害的角色。",
  ["#pang_jigao1"] = "你可以令其摸一张牌并选择失去体力或对自己用【兵粮寸断】",
  ["losehp"] = "失去体力",
  ["shortage"] = "获得饥饿",
  ["use_shortage"] = "将一张黑色牌作为兵粮寸断使用",
  ["#pang_jigao2"] = "你可以摸一张牌并选择失去体力或对自己用【兵粮寸断】",
}

return tiewan