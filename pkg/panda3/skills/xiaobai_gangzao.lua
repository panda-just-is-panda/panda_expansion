local gangzao = fk.CreateSkill{
  name = "xiaobai_gangzao",
}

local gangzao_spec = {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(gangzao.name) then
      local x = player:getMark("@shujian")
      local room = player.room
      local targets = table.filter(room.alive_players, function (p)
      return p:getHandcardNum() == x
    end)
    if #targets > 0 then
        return true
    end
    end
end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local x = player:getMark("@shujian")
    local targets = table.filter(room.alive_players, function (p)
      return p:getHandcardNum() == x and not p:isNude()
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = gangzao.name,
      prompt = "#gangzao_choose",
      cancelable = true,
    })
    if #to > 0 then
        event:setCostData(self, {tos = to})
        return true
    end
end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to1 = event:getCostData(self).tos[1]
    local card = room:askToChooseCard(player, {
          target = to1,
          skill_name = gangzao.name,
          flag = "he",
        })
        room:throwCard(card, gangzao.name, to1, player)
end,
}
gangzao:addEffect(fk.CardUsing, gangzao_spec)
gangzao:addEffect(fk.CardResponding, gangzao_spec)

Fk:loadTranslationTable {["xiaobai_gangzao"] = "疏谏",
[":xiaobai_gangzao"] = "你使用或打出牌后，你可以奔置一名手牌数为×的角色一张牌（×为你上次发动 “疏谏”所满足的项数）",
["#gangzao_choose"] = "你可以弃置一名手牌数为x的角色一张牌",
["gangzao_discard"] = "弃置其中一张牌",
}
return gangzao