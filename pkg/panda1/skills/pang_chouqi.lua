local chouqi = fk.CreateSkill{
  name = "pang_chouqi",
  tags = {  },
}
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","猪的力量","猪猪，怒了！","通过发动“仇起”杀死一名角色","general:pang__zombified_piglin",true,nil,true)
    end
end

Fk:loadTranslationTable {
  ["pang_chouqi"] = "仇起",
  [":pang_chouqi"] = "当一名角色受到除你以外的角色造成的伤害后，你可以选择一项，然后视为对伤害来源使用一张【杀】：此技能失效直到伤害来源受到伤害或死亡；失去1点体力。",

  ["pang_losehp"] = "失去1点体力",
  ["#chouqi-invoke"] = "你可以选择一项负面，然后视为对%src使用一张【杀】",
  ["limit_skill"] = "此技能失效直到%src受到伤害",
  ["@@pang_chouqi"] = "仇起失效",
  ["@@pang_beichouqi"] = "仇起目标",

  ["$pang_chouqi1"] = "哼唧——",
["$pang_chouqi2"] = "哼唧——！",
}

chouqi:addEffect(fk.Damaged, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(chouqi.name) and data.from and data.from ~= player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if player.room:askToSkillInvoke(player, {
      skill_name = chouqi.name,
      prompt = "#chouqi-invoke:"..data.from.id,
    }) then
    return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.from
    local choices = {"pang_losehp", "limit_skill:"..to.id}
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = chouqi.name,
    })
    if choice == "pang_losehp" then
        room:loseHp(player, 1, chouqi.name)
    else
        room:setPlayerMark(player, "@@pang_chouqi", 1)
        room:setPlayerMark(to, "@@pang_beichouqi", 1)
        room:invalidateSkill(player, chouqi.name)
    end
    room:sortByAction(to)
    room:useVirtualCard("slash", nil, player, to, chouqi.name, true)
    if to.dead then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(chouqi.name.."_achive")==0 then
        room:setPlayerMark(player,chouqi.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"猪的力量","猪猪，怒了！","general:pang__zombified_piglin", {player})
      end
    end
  end,
})


chouqi:addEffect(fk.Damaged, {
  can_refresh = function(self, event, target, player, data)
    return player:getMark("@@pang_chouqi") > 0 and data.to:getMark("@@pang_beichouqi") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    room:setPlayerMark(player, "@@pang_chouqi", 0)
    room:setPlayerMark(to, "@@pang_beichouqi", 0)
    room:validateSkill(player, chouqi.name)
  end,
})

chouqi:addEffect(fk.Death, {
  can_refresh = function(self, event, target, player, data)
    return player:getMark("@@pang_chouqi") > 0 and target:getMark("@@pang_beichouqi") > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local to = target
    room:setPlayerMark(player, "@@pang_chouqi", 0)
    room:setPlayerMark(target, "@@pang_beichouqi", 0)
    room:validateSkill(player, chouqi.name)
  end,
})




return chouqi