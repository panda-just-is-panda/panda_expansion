local zhulve = fk.CreateSkill({
  name = "pang_zhulve", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

zhulve:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zhulve.name) and data.card.trueName == "slash"
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local card = room:askToDiscard(player, {
      skill_name = zhulve.name,
      prompt = "#zhulve_discard:"..target.id,
      cancelable = true,
      min_num = 1,
      max_num = 1,
      include_equip = true,
    })
    if #card > 0 then 
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = target
    to:drawCards(1, zhulve.name)
    if player:getMark("pang_zhulve_used") < 1 then
      room:setPlayerMark(to, "@@pang_zhulve", 1)
      room:setPlayerMark(player, "pang_zhulve_used", 1)
    end
    if to:getMark("@@pang_zhulve") > 0 then
      player:drawCards(1, zhulve.name)
    end
  end,
})


Fk:loadTranslationTable {["pang_zhulve"] = "助掠",
[":pang_zhulve"] = "一名角色使用【杀】时，你可以弃置一张牌，令其摸一张牌；若其为第一个因此获得牌的其他角色，你摸一张牌。",
["#zhulve_discard"] = "你可以弃置一张牌，令%src摸一张牌",
["@@pang_zhulve"] = "助掠",

["$pang_zhulve1"] = "嗷～吼吼～",
["$pang_zhulve2"] = "吼吼～",
}
return zhulve  --不要忘记返回做好的技能对象哦