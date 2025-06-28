local skill = fk.CreateSkill({
  name = "pang_binghai", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

skill:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = player:drawCards(2)
    if #cards == 0 then return false end
    if player.dead then return end
     local cards = player:getCardIds("h")
    if #cards > 0 then
      player:showCards(cards)
    end
      room:delay(50)
      if player.dead then return end
      local discards = table.filter(player:getCardIds("he"), function(id)
        return Fk:getCardById(to_select).color == Card.Black and not player:prohibitDiscard(id)
      end)
      if #discards > 0 then
        room:throwCard(discards, skill.name, player, player)
      end
  end,
})


Fk:loadTranslationTable {["pang_binghai"] = "兵海",
[":pang_binghai"] = "当你使用一张牌后，你可以摸两张牌并展示所有手牌，然后你弃置其中的黑色牌。",
}
return skill  --不要忘记返回做好的技能对象哦