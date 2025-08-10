local moya = fk.CreateSkill({
  name = "pang_moya", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

moya:addEffect(fk.TurnEnd, {
  anim_type = "offensive",
  prompt = "#pang_moya",
  can_trigger = function(self, event, target, player, data)
    local cards = player:getCardIds("h")
    return target ~= player and #cards < player.hp and player:hasSkill(moya.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(2, moya.name)
    local victims = target
    if not target.dead then
        room:useVirtualCard("slash", nil, player, {target}, moya.name, true)
    end
  end,
})

Fk:loadTranslationTable {["pang_moya"] = "魔牙",
[":pang_moya"] = "其他角色的回合结束时，若你的手牌数小于体力值，你可以摸两张牌并视为对当前回合角色使用一张【杀】。",
["#pang_moya"] = "你可以摸两张牌并视为对当前回合角色使用一张【杀】",

["$pang_moya1"] = "魔法吟唱声",
["$pang_moya2"] = "魔法吟唱声",
}
return moya