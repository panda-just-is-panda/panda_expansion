local quyuan = fk.CreateSkill{
  name = "pang_quyuan",
  tags = { Skill.Hidden },
}
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","同归于蛆","伟大，无须多言","场上所有角色均获得“蛆渊”","general:pang__groal_the_great",true,nil,true)
    end
end

Fk:loadTranslationTable{
  ["pang_quyuan"] = "蛆渊",
  [":pang_quyuan"] = "隐匿技，当你登场时，你可以令一名角色弃置一张牌，然后若此牌不为【闪】，其获得“蛆渊”；当你成为【桃】的目标时，你取消之并失去此技能。",

  ["#quyuan-choose"] = "蛆渊：你可以令一名角色弃置一张牌，若不为【闪】则其获得“蛆渊”",
  ["#quyuan_show?"] = "蛆渊：你需弃置一张牌，若不为【闪】，你获得蛆渊",

  ["$pang_quyuan1"] = "车轮战的小曲～",
  ["$pang_quyuan2"] = "出场的小曲～",

}

local U = require "packages/utility/utility"

quyuan:addEffect(U.GeneralAppeared, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasShownSkill(quyuan.name) then
        return true
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = {}
    for _, p in ipairs(Fk:currentRoom().alive_players) do
      if not p:isNude() then
        table.insert(targets, p)
      end
    end
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = quyuan.name,
      prompt = "#quyuan-choose",
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = {tos[1]}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local target = event:getCostData(self).tos[1]
    local decision = 0
    local card = room:askToCards(target, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = quyuan.name,
      prompt = "#quyuan_show?",
      cancelable = false,
    })
    if #card > 0 then
        local card_test = Fk:getCardById(card[1]).trueName
        if card_test == "jink" then
            decision = 1
        end
    end
    room:throwCard(card, quyuan.name, target, target)
    if decision == 0 and not target:hasSkill("pang_quyuan") then
        room:handleAddLoseSkills(target, "pang_quyuan", nil, true, false)
    end
    local qu_number
    for _, p in ipairs(Fk:currentRoom().alive_players) do
      if p:hasSkill("pang_quyuan") then
        qu_number = qu_number + 1
      end
    end
    if player:hasSkill("pang_weiye") and qu_number == #Fk:currentRoom().alive_players then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(quyuan.name.."_achive")==0 then
        room:setPlayerMark(player,quyuan.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"同归于蛆","伟大，无须多言","general:pang__groal_the_great", {player})
      end
    end
  end,
})

quyuan:addEffect(fk.TargetConfirming, {
  anim_type = "negative",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(quyuan.name) and data.card.trueName == "peach"
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    data:cancelTarget(player)
    room:handleAddLoseSkills(player, "-pang_quyuan", nil, true, false)
  end
})

return quyuan