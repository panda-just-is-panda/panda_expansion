local xiangle = fk.CreateSkill {
  name = "pang_xiangle",
  tags = {Skill.Compulsory},
}

Fk:loadTranslationTable{
  ["pang_xiangle"] = "享乐",
  [":pang_xiangle"] = "锁定技，当其他角色使用【杀】或锦囊牌指定你为目标后，除非其弃置一张基本牌，否则此牌对你无效。",

  ["#xiangle-discard"] = "享乐：你须弃置一张基本牌，否则此牌对 %src 无效",

  ["$pang_xiangle1"] = "打打杀杀，真没意思。",
  ["$pang_xiangle2"] = "我爸爸是刘备！",
}

xiangle:addEffect(fk.TargetSpecified, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and data.to == player and player:hasSkill(xiangle.name) and data.card.trueName == "slash"
    or target ~= player and data.to == player and player:hasSkill(xiangle.name) and data.card.type == Card.TypeTrick
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if data.from.dead or #room:askToDiscard(data.from, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = xiangle.name,
      cancelable = true,
      pattern = ".|.|.|.|.|basic",
      prompt = "#xiangle-discard:"..player.id,
    }) == 0 then
      data.nullified = true
    end
  end,
})

return xiangle