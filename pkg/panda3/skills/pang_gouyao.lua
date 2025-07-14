local gouyao = fk.CreateSkill{
  name = "pang_gouyao",
  tags = {Skill.Compulsory, Skill.Permanent},
}

gouyao:addEffect(fk.Damage, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(gouyao.name) and target == player
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
      local x = math.max(data.to:getLostHp(), 1)
    room:drawCards(player, x, gouyao.name)
    local to = data.to
    local card = room:askToChooseCard(player, {
          target = to,
          skill_name = gouyao.name,
          flag = "he",
        })
        room:throwCard(card, gouyao.name, to, player)
    if Fk:getCardById(card).type == Card.TypeBasic then
      room:addPlayerMark(to, "@@gouyao")
    end
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
  [":pang_gouyao"] = "持恒技，锁定技，当你对一名角色造成伤害后，你摸X张牌（X为其已损失的体力值且至少为1）并弃置其一张牌；若此牌为基本牌，你本回合对其使用牌无次数限制。",
  ["@@gouyao"] = "被咬住",
  ["$pang_gouyao1"] = "百战生豪意，一戟破万军！",
  ["$pang_gouyao2"] = "烽烟既起，吾当独擎沙场！",
}


return gouyao