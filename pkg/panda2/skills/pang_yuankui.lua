local yuankui = fk.CreateSkill({
  name = "pang_yuankui", 
  tags = {}, 
})

local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","借用一下","你的娃娃是哪家生产的？","游戏开始时，浪漫包卑弥呼也在场","general:pang__changzhang",true,nil,true)
    end
end

yuankui:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    local X = 0
    for _, to in ipairs(player.room.alive_players) do
        if to:getMark("@@rmt__puppet") > 0 then
            X = X + 1
        end
    end
    return  X < 2 and target == player and player:hasSkill(yuankui.name)
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
  can_trigger = function(self, event, target, player, data)
    return target:getMark("@@rmt__puppet") > 0 and player:hasSkill(yuankui.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = target
    local from
    if data.from then
      from = data.from
    end
    if to ~= player and room:askToSkillInvoke(player, {
      skill_name = yuankui.name,
      prompt = "#pang_yuankui_swap:"..to.id,
    }) then
      room:swapAllCards(player, {player, to}, yuankui.name)
    elseif from then
      if room:askToSkillInvoke(from, {
        skill_name = yuankui.name,
        prompt = "#pang_yuankui_remove:"..to.id,
      }) then
        room:setPlayerMark(to, "@@rmt__puppet", 0)
      end
    end
  end,
})

yuankui:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    local X = 0
    for _, to in ipairs(player.room.alive_players) do
        if to.general == "rmt__himiko" or to.deputyGeneral == "rmt__himiko" then
            X = 1
        end
    end
    return player:hasSkill(yuankui.name) and X == 1
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:chat("我去，日本女人，太好")
    if Fk.skills["glory_days__show"] and gdU and player:getMark(yuankui.name.."_achive")==0 then
        player.room:setPlayerMark(player,yuankui.name.."_achive",1)
        gdU.addAchievement(player.room,"steam",250,nil,"借用一下","你的娃娃是哪家生产的？","general:pang__changzhang", {player})
    end
  end,
})

Fk:loadTranslationTable{["pang_yuankui"] = "怨傀",
  [":pang_yuankui"] = "当你造成伤害后，若场上的“傀”数小于2，你可以令一名没有“傀”的角色获得1枚“傀”；当一名有“傀”的角色受到伤害后，你可以和其交换手牌，否则伤害来源可以移除此“傀”。",
  ["#yuankui"] = "怨傀：你可以令一名没有“傀”的角色获得一枚“傀”",

  ["#pang_yuankui_swap"] = "怨傀：你可以和 %src 交换手牌，否则伤害来源可以移除 %src 的“傀”",
  ["#pang_yuankui_remove"] = "怨傀：你可以移除 %src 的“傀”",
}

return yuankui