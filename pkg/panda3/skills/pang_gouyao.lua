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
      local x = math.min(data.to:getLostHp(), 3)
    room:drawCards(player, x, gouyao.name)
    local to = data.to
    if not to.dead and not to:isNude() and to:getMark("@@gouyao") < 1 then
    local card = room:askToCards(to, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = gouyao.name,
        pattern = ".|.|.|.|.|basic",
        prompt = "#gouyao_discard",
        cancelable = true,
      })
        if #card > 0 then
            room:throwCard(card, gouyao.name, to, to)
        else
            room:addPlayerMark(to, "@@gouyao")
        end
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
  [":pang_gouyao"] = "持恒技，锁定技，当你对一名角色造成伤害后，你摸X张牌（X为其已损失的体力值且至多为3），然后除非其弃置一张基本牌，否则你本回合对其使用牌无次数限制。",
  ["#gouyao_discard"] = "你被咬住了！弃置一张基本牌脱身或等死！",
  ["@@gouyao"] = "被咬住",
  ["$pang_gouyao1"] = "颅献白骨观，血祭黄沙场！",
  ["$pang_gouyao2"] = "拥酒炙胡马，北虏复唱匈奴歌！",
}


return gouyao