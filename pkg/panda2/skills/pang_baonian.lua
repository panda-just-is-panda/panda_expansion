local baonian = fk.CreateSkill {
  name = "pang_baonian",
  tags = {Skill.Compulsory},
}

local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","他自杀了","锁定技害我","发动暴碾杀死自己","general:pang__skull_tyrant",true,nil,true)
    end
end

baonian:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(baonian.name) and target == player
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:getNCards(2)
    local to = data.to
    room:turnOverCardsFromDrawPile(player, cards, baonian.name)
    local search = table.filter(cards, function (id)
        return Fk:getCardById(id).trueName == "slash"
    end)
    if #search > 0 then
          if player:getMark("baonian_audio-turn") == 0 then
            room:addPlayerMark(player, "baonian_audio-turn", 1)
            player:broadcastSkillInvoke(baonian.name, 1)
          elseif player:getMark("baonian_audio-turn") == 1 then
            room:addPlayerMark(player, "baonian_audio-turn", 1)
            player:broadcastSkillInvoke(baonian.name, 2)
          end
        local discard = room:askToDiscard(to, {
            skill_name = baonian.name,
            prompt = "#pang_baonian:"..player.id,
            cancelable = true,
            min_num = 1,
            max_num = 1,
            include_equip = true,
        })
        if #discard == 0 then
            room:damage{
                from = player,
                to = to,
                damage = 1,
                skillName = baonian.name,
            }
          if player.dead and Fk.skills["glory_days__show"] and gdU then
            room:setPlayerMark(player,baonian.name.."_achive",1)
            gdU.addAchievement(room,"steam",250,nil,"他自杀了","锁定技害我","general:pang__skull_tyrant", {player})
          end
        end
    end
    room:cleanProcessingArea(cards, baonian.name)
  end,
})



Fk:loadTranslationTable {["pang_baonian"] = "暴碾",
[":pang_baonian"] = "锁定技，当你使用牌指定一名角色为目标后，你将牌堆顶的两张牌置入弃牌堆，然后若其中有【杀】，其需弃置一张牌或受到你造成的1点伤害。",
["#pang_baonian"] = "暴碾：你需弃置一张牌，否则 %src 对你造成1点伤害",


["$pang_baonian1"] = "焦灼的小曲～",
["$pang_baonian2"] = "激战的小曲～",
}

return baonian