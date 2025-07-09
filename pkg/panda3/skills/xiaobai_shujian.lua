local shujian = fk.CreateSkill{
  name = "xiaobai_shujian",
}

shujian:addEffect(fk.TargetConfirmed, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(shujian.name) and data.from == player or
    target == player and player:hasSkill(shujian.name) and data.card.type == Card.TypeBasic or
    target == player and player:hasSkill(shujian.name) and data.card.suit == Card.Heart
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local valid_target = table.filter(room.alive_players, function (p)
      return p ~= room.current
    end)
    local to = room:askToChoosePlayers(player, {
        targets = valid_target,
        skill_name = shujian.name,
        min_num = 1,
        max_num = 1,
        prompt = "shujian1",
        cancelable = true,
    })
    if #to > 0 then
        player.room:setPlayerMark(player, "@shujian", 0)
        if data.from == player then
            player.room:addPlayerMark(player, "@shujian", 1)
        end 
        if data.card.type == Card.TypeBasic then
            player.room:addPlayerMark(player, "@shujian", 1)
        end 
        if data.card.suit == Card.Heart then
            player.room:addPlayerMark(player, "@shujian", 1)
        end
        event:setCostData(self, {tos = to})
      return true
    end
end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to1 = event:getCostData(self).tos[1]
    if player:getMark("@shujian") < 3 or not to1:isWounded() then
        to1:drawCards(1, shujian.name)
    else
         local choices = {"draw1", "recover"}
         local choice = room:askToChoice(to1, {
      choices = choices,
      skill_name = shujian.name,
      prompt = "shujian_ask",
    })
    if choice == "draw1" then
        to1:drawCards(1, shujian.name)
    else
        room:recover({
        who = to1,
        num = 1,
        recoverBy = player,
        skillName = shujian.name
      })
    end
  end
  if player:getMark("@shujian") == 2 then
        local valid_target2 = table.filter(room.alive_players, function (p2)
      return p2 ~= room.current and p2 ~= to1
    end)
    local to_number2 = room:askToChoosePlayers(player, {
      skill_name = shujian.name,
      min_num = 1,
      max_num = 1,
      targets = valid_target2,
      prompt = "shujian2",
      cancelable = true,
    })
    if #to_number2 > 0 then
        to_number2:drawCards(1, shujian.name)
    end
  end
  end
})

Fk:loadTranslationTable {["xiaobai_shujian"] = "疏谏",
[":xiaobai_shujian"] = "当你成为红桃牌、基本牌或你使用的牌的目标后你可以令一名不为当前回合的角色摸一张牌，若该牌：仅满足两项，你可以多选择一名角色；均满足，被选择的角色可改为回复1点体力。",
["shujian1"] = "令一名不为当前回合的角色摸一张牌",
["shujian2"] = "你可多选择一名不为当前回合的角色",
["shujian_ask"] = "回复体力或摸牌",
["@shujian"] = "疏谏",
}
return shujian
