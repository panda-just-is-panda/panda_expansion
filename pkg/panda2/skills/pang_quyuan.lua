local quyuan = fk.CreateSkill{
  name = "pang_quyuan",
  tags = { Skill.Hidden },
}

Fk:loadTranslationTable{
  ["pang_quyuan"] = "蛆渊",
  [":pang_quyuan"] = "隐匿技，当你登场时，你可以令一名角色除非展示一张【闪】，否则获得“蛆渊”；当你成为【桃】的目标时，取消之，然后你失去此技能。",

  ["#quyuan-invoke"] = "蛆渊：你可以令一名角色除非展示一张【闪】，否则获得“蛆渊”",
  ["#quyuan-choose"] = "蛆渊：选择一名角色",
  ["#quyuan_show?"] = "蛆渊：你可以展示一张手牌，若你不展示或展示的牌不为【闪】，你获得蛆渊",

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
    if room:askToSkillInvoke(player, {
      skill_name = quyuan.name,
      prompt = "#quyuan-invoke",
    }) then
        local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room.alive_players,
        skill_name = quyuan.name,
        prompt = "#quyuan-choose",
        cancelable = false,
        })
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
      include_equip = false,
      skill_name = quyuan.name,
      prompt = "#quyuan_show?",
      cancelable = true,
    })
    if #card > 0 then
        local card_test = Fk:getCardById(card[1]).trueName
        if card_test == "jink" then
            decision = 1
            target:showCards(card)
        end
    end
    if decision == 0 and not target:hasSkill("pang_quyuan") then
        room:handleAddLoseSkills(target, "pang_quyuan", nil, true, false)
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