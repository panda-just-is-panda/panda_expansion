local dangli = fk.CreateSkill {
  name = "pang_dangli",
  tags = {Skill.Switch},
}
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","方头耄耋","劫掠兽哈气了","于一个回合内发动两次“荡力”","general:pang__ravager",true,nil,true)
    end
end

dangli:addEffect(fk.DamageInflicted, {
prompt = "#dangli",
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(dangli.name) and player:getSwitchSkillState(dangli.name, true) ~= fk.SwitchYang
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(1)
    local cards = player.room:getCardsFromPileByRule("slash", 1, "discardPile")
    if #cards > 0 then
      player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, dangli.name)
      if player.dead then return false end
    end
    if player:usedSkillTimes(dangli.name, Player.HistoryTurn) > 1 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(dangli.name.."_achive")==0 then
        room:setPlayerMark(player,dangli.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"方头耄耋","劫掠兽哈气了","general:pang__ravager", {player})
      end
    end
  end,
})

dangli:addEffect(fk.DamageCaused, {
prompt = "#dangli",
anim_type = "switch",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(dangli.name) and player:getSwitchSkillState(dangli.name, true) == fk.SwitchYang
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(1)
    local cards = player.room:getCardsFromPileByRule("slash", 1, "discardPile")
    if #cards > 0 then
      player.room:obtainCard(player, cards[1], true, fk.ReasonJustMove, player, dangli.name)
      if player.dead then return false end
    end
    if player:usedSkillTimes(dangli.name, Player.HistoryTurn) > 1 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(dangli.name.."_achive")==0 then
        room:setPlayerMark(player,dangli.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"方头耄耋","劫掠兽哈气了","general:pang__ravager", {player})
      end
    end
  end,
})


Fk:loadTranslationTable {["pang_dangli"] = "荡力",
[":pang_dangli"] = "转换技，①当你受到伤害时②当你造成伤害时，你可以令此伤害+1并获得弃牌堆中的一张【杀】。",
["#dangli"] = "你可以令此伤害+1并获得【杀】",

["$pang_dangli1"] = "哈～",
["$pang_dangli2"] = "哈——",
}
return dangli  --不要忘记返回做好的技能对象哦