local laoyun = fk.CreateSkill {
  name = "pang_laoyun",
}

Fk:loadTranslationTable {["pang_laoyun"] = "劳运",
[":pang_laoyun"] = "每回合限一次，当你获得牌后，你可以观看一名其他角色的手牌，然后你交给其一张牌并摸一张牌。",

["#laoyun-choose"] = "劳运：你可以观看一名其他角色的手牌，然后交给其一张牌并摸一张牌",
["#laoyun_ask"] = "劳运：交给 %src 一张牌并摸一张牌",


["$pang_laoyun1"] = "机关运转声",
["$pang_laoyun2"] = "机械摩擦声",
}

laoyun:addEffect(fk.AfterCardsMove, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(laoyun.name) and player:usedSkillTimes(laoyun.name, Player.HistoryTurn) == 0 and
      not player:isNude() then
      for _, move in ipairs(data) do
        if move.to == player and move.toArea == Player.Hand then
          return #player.room:getOtherPlayers(player, false) > 0
        end
      end
    end
    end,
    on_cost = function(self, event, target, player, data)
        local tos = player.room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = player.room:getOtherPlayers(player, false),
            skill_name = laoyun.name,
            prompt = "#laoyun-choose",
            cancelable = true,
        })
        if #tos > 0 then
            event:setCostData(self, {tos = tos})
            return true
        end
    end,
    on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    if not to:isKongcheng() then
        room:viewCards(player, { cards = to:getCardIds("h"), skill_name = laoyun.name, prompt = "$ViewCardsFrom:" .. to.id })
    end
    local cards = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = laoyun.name,
        prompt = "#laoyun_ask:"..to.id,
        cancelable = false,
    })
    if #cards > 0 then
        room:obtainCard(to, cards, false, fk.ReasonGive)
        player:drawCards(1, laoyun.name)
    end
  end,
})




return laoyun