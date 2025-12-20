local huifu = fk.CreateSkill({
  name = "pang_huifu", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","癫狂屠戮","我杀，我杀，我再杀","连续三个回合发动“挥斧”","general:pang__vindicator",true,nil,true)
    end
end

huifu:addEffect(fk.TurnEnd, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) == 0 and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) == 0 then
      player.room:setPlayerMark(player,"huifu_counter",0)
    end
    return player:hasSkill(huifu.name)
    and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player or e.data.to == player end, Player.HistoryTurn) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local the_prompt
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0 and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) == 0 then
      the_prompt = "huifu-invoke1"
    elseif #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) == 0 and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0 then
      the_prompt = "huifu-invoke2"
    elseif #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0 and #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0 then
      the_prompt = "huifu-invoke3"
    end
    if player.room:askToSkillInvoke(player, {
      skill_name = huifu.name,
      prompt = the_prompt,
    }) then
      return true
    else
      player.room:setPlayerMark(player,"huifu_counter",0)
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.from == player end, Player.HistoryTurn) > 0 then
      local cards = player.room:getCardsFromPileByRule("slash", 1, "discardPile")
      if #cards > 0 then
        player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, huifu.name)
        if player.dead then return false end
      end
    end
    if #player.room.logic:getActualDamageEvents(1, function(e) return e.data.to == player end, Player.HistoryTurn) > 0 then
      local slash = Fk:cloneCard("slash")
      local max_num = slash.skill:getMaxTargetNum(player, slash)
      local targets = table.filter(room:getOtherPlayers(player, false), function (p)
        return player:canUseTo(slash, p, {bypass_times = true})
      end)
      if #targets > 0 then
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = max_num,
        targets = targets,
        skill_name = huifu.name,
        prompt = "#huifu_choose",
        cancelable = false,
      })
        if #tos > 0 then
          local targets = tos
          room:sortByAction(targets)
          room:useVirtualCard("slash", nil, player, targets, huifu.name, true)
        end
      end
    end
    room:addPlayerMark(player,"huifu_counter",1)
    if player:getMark("huifu_counter") == 3 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(huifu.name.."_achive")==0 then
        room:setPlayerMark(player,huifu.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"癫狂屠戮","我杀，我杀，我再杀","general:pang__vindicator", {player})
      end
    end
end,
})

Fk:loadTranslationTable {["pang_huifu"] = "挥斧",
[":pang_huifu"] = "每回合结束时，若你本回合：造成过伤害，你获得弃牌堆中的一张【杀】；受到过伤害，你可以视为使用一张【杀】。",
["huifu-invoke1"] = "挥斧：你可以视为使用一张【杀】",
["huifu-invoke2"] = "挥斧：你可以获得一张【杀】",
["huifu-invoke3"] = "挥斧：你可以获得一张【杀】并视为使用一张【杀】",
["#huifu_choose"] = "视为使用一张【杀】",

["$pang_huifu1"] = "哼哼～",
["$pang_huifu2"] = "哼哼！",
}
return huifu  --不要忘记返回做好的技能对象哦