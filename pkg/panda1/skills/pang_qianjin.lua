local qianjin = fk.CreateSkill{
  name = "pang_qianjin",
  tags = { Skill.Hidden },
}


Fk:loadTranslationTable{
  ["pang_qianjin"] = "潜近",
  [":pang_qianjin"] = "隐匿技，当你登场时，本回合你计算和其他角色的距离-1。",
  ["@@qianjin-turn"] = "潜近",



}

local U = require "packages/utility/utility"

qianjin:addEffect(U.GeneralAppeared, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasShownSkill(qianjin.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player, "@@qianjin-turn", 1)
  end,
})

qianjin:addEffect("distance", {
  correct_func = function(self, from, to)
    return -from:getMark("@@qianjin-turn")
  end,
})



return qianjin