local lijun = fk.CreateSkill({
  name = "pang_lijun",
  tags = {Skill.lord},
})

lijun:addEffect(fk.EventPhaseStart, { --
    anim_type = "control", 
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(self) and
        player.phase == Player.Start
    end,
    on_cost = function(self, event, target, player, data)
        local room = player.room
        local success, dat = room:askToUseActiveSkill(player,
      {
        skill_name = "pang_lijun_choose",
        prompt = "#pang_lijun-promot",
        no_indicate = true
      }
    )
    if success and dat then
      event:setCostData(self, dat.targets)
      return true
    end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local costData = event:getCostData(self)
        local to = costData[1]
        local cards = player.room:getCardsFromPileByRule("slash", 1, "discardPile")
        if #cards > 0 then
            room:obtainCard(to, cards[1], true, fk.ReasonJustMove, to, lijun.name)
            if player.dead then return false end
        end
    end,
})


Fk:loadTranslationTable {["pang_lijun"] = "立军",
[":pang_lijun"] = "主公技，准备阶段，你可以令一名吴势力角色从弃牌堆中获得一张【杀】。",
["#pang_lijun-promot"] = "立军：你可以令一名吴势力角色从弃牌堆中获得一张【杀】",


["$pang_lijun1"] = "立于朝堂，定于军心。",
["$pang_lijun2"] = "君立于朝堂，军策于四方！",
}
return lijun  --不要忘记返回做好的技能对象哦