local yuankui = fk.CreateSkill({
  name = "pang_yuankui", 
  tags = {}, 
})

yuankui:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    if not target == player or not player:hasSkill(yuankui.name) then return false end
    local X = 0
    for _, to in ipairs(player.room.alive_players) do
        if to:getMark("@@rmt__puppet") > 0 then
            X = X + 1
        end
    end
    return  X < 2
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = {}
    for _, p in ipairs(player.room.alive_players) do
        if p:getMark("@@rmt__puppet") == 0 then
            table.insert(tos, p)
        end
    end
    if #tos > 0 then
        local to = room:askToChoosePlayers(player, {
          targets = tos,
          min_num = 1,
          max_num = 1,
          prompt = "#yuankui",
          skill_name = yuankui.name,
          cancelable = true,
        })
        if #to > 0 then
            event:setCostData(self, { to = to })
            return true
        end
    end
  end,
    on_use = function(self, event, target, player, data)
      local room = player.room
      local to = event:getCostData(self).to[1]
      room:setPlayerMark(to, "@@rmt__puppet", 1)
     end,
})

yuankui:addEffect(fk.Damaged, {
  can_refresh = function(self, event, target, player, data)
    return target:getMark("@@rmt__puppet") > 0 and player:hasSkill(yuankui.name)
  end,
  on_refresh = function(self, event, target, player, data)
    player:drawCards(1, yuankui.name)
  end,
})


Fk:loadTranslationTable{["pang_yuankui"] = "怨傀",
  [":pang_yuankui"] = "当你造成伤害后，若场上的“傀”数小于2，你可以令一名没有“傀”的角色获得1枚“傀”；当有“傀”的角色受到伤害后，你摸一张牌。",
  ["#yuankui"] = "怨傀：你可以令一名没有“傀”的角色获得一枚“傀”",


}

return yuankui