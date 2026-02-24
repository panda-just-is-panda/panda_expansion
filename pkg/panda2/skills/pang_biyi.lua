local biyi = fk.CreateSkill {
  name = "pang_biyi",
  tags = {},
}
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","笔锋族兔","吓哭了，虚构集大人","发动一次“笔意”杀死至少两名角色","general:pang__xugouji",true,nil,true)
    end
end

biyi:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(biyi.name) and data.to ~= player
    and data.to:getMark("biyi_used-turn") < 1
    and player.room.current == player and player.phase == Player.Play
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(data.to, "biyi_used-turn", 1)
  end,
})

biyi:addEffect(fk.EventPhaseEnd, {
 can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(biyi.name) and player.phase == Player.Play
    end,
    on_refresh = function(self, event, target, player, data)
    local room = player.room
    local used_tos = table.filter(room:getOtherPlayers(player, false), function (p)
      return p:getMark("biyi_used-turn") > 0
    end)
    if #used_tos == #room:getOtherPlayers(player, false) or #used_tos > #room:getOtherPlayers(player, false) then
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 3,
        targets = used_tos,
        skill_name = biyi.name,
        prompt = "#biyi",
        cancelable = true,
      })
      if #tos > 0 then
        room:addPlayerMark(player, "biyu_minus-turn", 2)
        for _, p in ipairs(tos) do
          if not p.dead then
            room:damage{
              from = player,
              to = p,
              damage = 1,
              skillName = biyi.name,
            }
            if p.dead then
              room:addPlayerMark(player, "biyi_kill-phase", 1)
            end
          end
        end
      end
    else
        room:addPlayerMark(player, "biyu_plus-turn", 2)
    end
    if player:getMark("biyi_kill-phase") > 1 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(biyi.name.."_achive")==0 then
        room:setPlayerMark(player,biyi.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"笔锋族兔","吓哭了，虚构集大人","general:pang__xugouji", {player})
      end
    end
    end,
})
biyi:addEffect("maxcards", {
  correct_func = function(self, player)
    return -player:getMark("biyu_minus-turn")
  end,
})
biyi:addEffect("maxcards", {
  correct_func = function(self, player)
    return player:getMark("biyu_plus-turn")
  end,
})


Fk:loadTranslationTable {["pang_biyi"] = "笔意",
[":pang_biyi"] = "出牌阶段结束时，若你此阶段使用牌指定过所有其他角色为目标，你可以对至多三名其他角色各造成1点伤害并令本回合你的手牌上限-2；否则，本回合你的手牌上限+2。",
["#biyi"] = "你可以对至多三名其他角色各造成1点伤害并令手牌上限本回合-2",
}

return biyi