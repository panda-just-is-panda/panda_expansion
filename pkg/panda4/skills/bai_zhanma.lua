Fk:loadTranslationTable{
  ["bai_zhanma"] = "斩麻",
  [":bai_zhanma"] = "锁定技，摸牌阶段，你多摸X张牌，（X为与你体力不相同的角色数），若你的上家和下家与你的手牌数均不相同，你于回合内使用【杀】无次数距离限制。",

}

local zhanma = fk.CreateSkill{
  name = "bai_zhanma",
  tags = { Skill.Compulsory },
}

zhanma:addEffect(fk.DrawNCards, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zhanma.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local n_plus = 0
    for _, p in ipairs(Fk:currentRoom().alive_players) do
        if p ~= player and p.hp - player.hp ~= 0 then
            n_plus = n_plus + 1
        end
    end
    data.n = data.n + n_plus
  end,
})

zhanma:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card)
    local test = 1
    for _, p in ipairs(Fk:currentRoom().alive_players) do
        if (p:getNextAlive() == player or player:getNextAlive() == p)
        and p:getHandcardNum() - player:getHandcardNum() == 0 then
            test = 0
        end
    end
    return player:hasSkill(zhanma.name) and card and card.trueName == "slash" and test == 1
  end,
  bypass_distances = function(self, player, skill_name, card, to)
    local test = 2
    for _, p in ipairs(Fk:currentRoom().alive_players) do
        if (p:getNextAlive() == player or player:getNextAlive() == p)
        and p:getHandcardNum() - player:getHandcardNum() == 0 then
            test = 0
        end
    end
    return player:hasSkill(zhanma.name) and card and card.trueName == "slash" and test == 2
  end,
})

return zhanma