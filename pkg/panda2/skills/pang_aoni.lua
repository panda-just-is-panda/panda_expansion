local aoni = fk.CreateSkill({
  name = "pang_aoni", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})


aoni:addAcquireEffect(function (self, player, is_start)
  local room = player.room
  for _, p in ipairs(room:getAlivePlayers()) do
            if p:getMark("@@zhengxie_kuanggu") > 0 then
                room:handleAddLoseSkills(p, "pang_kuanggu", nil, false, true)
            else
                room:handleAddLoseSkills(p, "-pang_kuanggu", nil, false, true)
            end
    end
    for _, p in ipairs(room:getAlivePlayers()) do
        if p:getMark("@@zhengxie_gukuang") > 0 then
            room:handleAddLoseSkills(p, "pang_gukuang", nil, false, true)
        else
            room:handleAddLoseSkills(p, "-pang_gukuang", nil, false, true)
        end
    end
end)

aoni:addEffect(fk.AfterCardTargetDeclared, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(aoni.name) and player.room.current == player and #data.tos > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      targets = data.tos,
      min_num = 1,
      max_num = 1,
      prompt = "#aoni_choose",
      skill_name = aoni.name,
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local choices = {"kuanggu", "gukuang"}
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = aoni.name,
    })
    if choice == "kuanggu" then
      room:addPlayerMark(to, "@@zhengxie_kuanggu", 1)
    else
      room:addPlayerMark(to, "@@zhengxie_gukuang", 1)
    end
  end,
})

aoni:addEffect(fk.TurnStart, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(aoni.name)
  end,
  on_refresh = function(self, event, target, player, data)
    for _, p in ipairs(player.room.alive_players) do
      player.room:setPlayerMark(p, "@@zhengxie_kuanggu", 0)
      player.room:setPlayerMark(p, "@@zhengxie_gukuang", 0)
    end
  end,
})

Fk:loadTranslationTable {["pang_aoni"] = "骜逆",
[":pang_aoni"] = "当你于回合内使用牌指定目标后，你可以令其中一个目标视为拥有“狂骨”或“骨狂”直到你的下个回合开始。",
["#aoni_choose"] = "骜逆：你可以令一名目标角色获得“狂骨”或骨狂",
["kuanggu"] = "令该角色获得“狂骨”",
["gukuang"] = "令该角色获得“骨狂”",
["@@zhengxie_kuanggu"] = "狂骨",
["@@zhengxie_gukuang"] = "骨狂",
}
return aoni