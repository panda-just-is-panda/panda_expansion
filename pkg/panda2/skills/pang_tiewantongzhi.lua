local tiewan = fk.CreateSkill({
  name = "pang_tiewantongzhi", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","星际枭雄","你的台词怎么这么多","于本局内听到过“铁腕统治”的全部语音","general:pang__mengsk",true,nil,true)
    end
end

tiewan:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"wuzhongshengyou", "Cancel"}
    if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
      if player:canUseTo(Fk:cloneCard("dismantlement"), data.to) or player == data.to and not player:isAllNude() then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_attack2::"..data.to.id,
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    else
      local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
      if #targets > 0 then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_attack1",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    end
    end,
    on_use = function(self, event, target, player, data)
      local room = player.room
      local choice = event:getCostData(self).choice
      if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 1 then
        local target = data.to
        if choice == "wuzhongshengyou" then
          player:broadcastSkillInvoke(tiewan.name, 3)
          room:addPlayerMark(player,"mengsk_voiceline3",1)
          if player:getMark("mengsk_voiceline3") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("ex_nihilo", nil, player, target, tiewan.name, true)
        elseif choice == "guohechaiqiao" then
          player:broadcastSkillInvoke(tiewan.name, 4)
          room:addPlayerMark(player,"mengsk_voiceline4",1)
          if player:getMark("mengsk_voiceline4") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("dismantlement", nil, player, target, tiewan.name, true)
        end
      else
        if choice == "wuzhongshengyou" then
          player:broadcastSkillInvoke(tiewan.name, 1)
          room:addPlayerMark(player,"mengsk_voiceline1",1)
          if player:getMark("mengsk_voiceline1") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("ex_nihilo", nil, player, player, tiewan.name, true)
        elseif choice == "guohechaiqiao" then
          player:broadcastSkillInvoke(tiewan.name, 2)
          room:addPlayerMark(player,"mengsk_voiceline2",1)
          if player:getMark("mengsk_voiceline2") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
          if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = tiewan.name,
            prompt = "#tiewan_chai",
            cancelable = false,
            })
            if #tos > 0 then
              local targets = tos
              room:sortByAction(targets)
              room:useVirtualCard("dismantlement", nil, player, targets, tiewan.name, true)
            end
          end
        end
      end
      if player:getMark("mengsk_total") == 10 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(tiewan.name.."_achive")==0 then
          room:setPlayerMark(player,tiewan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"星际枭雄","你的台词怎么这么多","general:pang__mengsk", {player})
        end
      end
     end,
})

tiewan:addEffect(fk.Damaged, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tiewan.name) and target == player
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"wuzhongshengyou", "Cancel"}
    if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 0 then
      if not player:isAllNude() then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_defense2",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    else
      local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
      if #targets > 0 then
        table.insert(choices, 2, "guohechaiqiao")
      end
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = tiewan.name,
      prompt = "tiewan_defense1",
      })
      if choice ~= "Cancel" then
        event:setCostData(self, {choice = choice})
        return true
      end
    end
    end,
    on_use = function(self, event, target, player, data)
      local room = player.room
      local choice = event:getCostData(self).choice
      if player:usedSkillTimes(tiewan.name, Player.HistoryTurn) > 1 then
        local target = player
        if choice == "wuzhongshengyou" then
          player:broadcastSkillInvoke(tiewan.name, 7)
          room:addPlayerMark(player,"mengsk_voiceline7",1)
          if player:getMark("mengsk_voiceline7") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("ex_nihilo", nil, player, target, tiewan.name, true)
        elseif choice == "guohechaiqiao" then
          player:broadcastSkillInvoke(tiewan.name, 8)
          room:addPlayerMark(player,"mengsk_voiceline8",1)
          if player:getMark("mengsk_voiceline8") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("dismantlement", nil, player, target, tiewan.name, true)

        end
      else
        if choice == "wuzhongshengyou" then
          player:broadcastSkillInvoke(tiewan.name, 5)
          room:addPlayerMark(player,"mengsk_voiceline5",1)
          if player:getMark("mengsk_voiceline5") == 1 then
            room:addPlayerMark(player,"mengsk_total",1)
          end
          room:useVirtualCard("ex_nihilo", nil, player, player, tiewan.name, true)
        elseif choice == "guohechaiqiao" then
          player:broadcastSkillInvoke(tiewan.name, 6)
            room:addPlayerMark(player,"mengsk_voiceline6",1)
            if player:getMark("mengsk_voiceline6") == 1 then
              room:addPlayerMark(player,"mengsk_total",1)
            end
          local targets = table.filter(room:getOtherPlayers(player, false), function (p)
          return player:canUseTo(Fk:cloneCard("dismantlement"), p)
          end)
          if #targets > 0 then
            local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = tiewan.name,
            prompt = "#tiewan_chai",
            cancelable = false,
            })
            if #tos > 0 then
              local targets = tos
              room:sortByAction(targets)
              room:useVirtualCard("dismantlement", nil, player, targets, tiewan.name, true)
            end
          end
        end
      end
      if player:getMark("mengsk_total") == 10 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(tiewan.name.."_achive")==0 then
          room:setPlayerMark(player,tiewan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"星际枭雄","你的台词怎么这么多","general:pang__mengsk", {player})
        end
      end
     end,
})

tiewan:addEffect(fk.CardUsing, {
mute = true,
can_refresh = function(self, event, target, player, data)
  return target == player and player:hasSkill(tiewan.name) and data.card.trueName == "archery_attack"
end,
on_refresh = function(self, event, target, player, data)
  local room = player.room
  player:broadcastSkillInvoke(tiewan.name, 9)
  room:addPlayerMark(player,"mengsk_voiceline9",1)
  if player:getMark("mengsk_voiceline9") == 1 then
    room:addPlayerMark(player,"mengsk_total",1)
  end
  if player:getMark("mengsk_total") == 10 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(tiewan.name.."_achive")==0 then
          room:setPlayerMark(player,tiewan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"星际枭雄","你的台词怎么这么多","general:pang__mengsk", {player})
        end
  end
end,
})

tiewan:addEffect(fk.CardUsing, {
mute = true,
can_refresh = function(self, event, target, player, data)
  return target == player and player:hasSkill(tiewan.name) and data.card.trueName == "savage_assault"
end,
on_refresh = function(self, event, target, player, data)
  local room = player.room
  player:broadcastSkillInvoke(tiewan.name, 10)
  room:addPlayerMark(player,"mengsk_voiceline10",1)
  if player:getMark("mengsk_voiceline10") == 1 then
    room:addPlayerMark(player,"mengsk_total",1)
  end
  if player:getMark("mengsk_total") == 10 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(tiewan.name.."_achive")==0 then
          room:setPlayerMark(player,tiewan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"星际枭雄","你的台词怎么这么多","general:pang__mengsk", {player})
        end
  end
end,
})

Fk:loadTranslationTable{["pang_tiewantongzhi"] = "铁腕统治",
  [":pang_tiewantongzhi"] = "当你造成或受到伤害后，你可以视为使用一张【无中生有】或【过河拆桥】；若你本回合发动过此技能，此牌的目标角色改为受到伤害的角色。",
  ["wuzhongshengyou"] = "无中生有",
  ["guohechaiqiao"] = "过河拆桥",
  ["tiewan_attack1"] = "你可以视为使用一张无中生有或过河拆桥",
  ["tiewan_attack2"] = "你可以视为对 %dest 使用一张无中生有或过河拆桥",
  ["tiewan_defense1"] = "你可以视为使用一张无中生有或过河拆桥",
  ["tiewan_defense2"] = "你可以视为对自己使用一张无中生有或过河拆桥",
  ["#tiewan_chai"] = "无需对敌人仁慈",

  ["$pang_tiewantongzhi1"] = "决定性的胜利。",
  ["$pang_tiewantongzhi2"] = "什么，都阻挡不了我！",
  ["$pang_tiewantongzhi3"] = "我向你们承诺过，我会守护你们，我没有食言。",
  ["$pang_tiewantongzhi4"] = "没人能质疑我的权威，我的力量是无穷的。",
  ["$pang_tiewantongzhi5"] = "帝国的子民们，拿起武器，保卫你们的家园！",
  ["$pang_tiewantongzhi6"] = "不会有人，被打措手不及的！",
  ["$pang_tiewantongzhi7"] = "这场战争，已经没有平民可言！",
  ["$pang_tiewantongzhi8"] = "我无数的子民做出了终极牺牲。",
  ["$pang_tiewantongzhi9"] = "发射导弹，继续发，全射出去！",
  ["$pang_tiewantongzhi10"] = "这是他们逼我们的。释放异虫。",
}

return tiewan