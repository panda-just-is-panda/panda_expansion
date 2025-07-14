local gouyao = fk.CreateSkill{
  name = "pang_gouyao",
  tags = {Skill.Compulsory, Skill.Permanent},
}

gouyao:addEffect(fk.Damage, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(gouyao.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if data.to:getLostHp() == 1 or data.to:getLostHp() < 1 then
      player.room:addPlayerMark(data.to, "@@gouyao")
      return true
    else
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
      local x = math.max(data.to:getLostHp(), 1)
    player.room:drawCards(player, x, gouyao.name)
  end,
})

gouyao:addEffect(fk.TurnEnd, {
  anim_type = "special",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(gouyao.name)
  end,
  on_refresh = function(self, event, target, player, data)
    for _, p in ipairs(player.room.alive_players) do
      player.room:setPlayerMark(p, "@@gouyao", 0)
    end
  end,
})

gouyao:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and to and to:getMark("@@gouyao") > 0
  end,
})

Fk:loadTranslationTable{
  ["pang_gouyao"] = "狗咬",
  [":pang_gouyao"] = "持恒技，锁定技，当你对一名角色造成伤害后，你摸X张牌（X为其已损失的体力值且至少为1）；若X为1，你本回合对其使用牌无次数限制。",
  ["@@gouyao"] = "被咬住",
  ["$pang_gouyao1"] = "百战生豪意，一戟破万军！",
  ["$pang_gouyao2"] = "烽烟既起，吾当独擎沙场！",
}


return gouyao