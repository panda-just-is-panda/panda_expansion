local kuangluan = fk.CreateSkill({
  name = "pang_kuangluan", ---技能内部名称，要求唯一性
  tags = {Skill.Compulsory}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","马神之力","我怎么还在断杀","因“狂乱”失去体力死亡，且本局从未因“狂乱”使用【杀】","general:pang__zoglin",true,nil,true)
    end
end

kuangluan:addEffect(fk.EventPhaseStart, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, kuangluan.name)
    local use = room:askToUseCard(player, {
      skill_name = kuangluan.name,
      pattern = "slash",
      prompt = "#kuangluan_sha",
      extra_data = {
        bypass_times = true,
      }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
      room:addPlayerMark(player,"kuangluan_counter",1)
    else
        room:loseHp(player, 1, kuangluan.name)
      if player.dead and player:getMark("kuangluan_counter") == 0 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(kuangluan.name.."_achive")==0 then
          room:setPlayerMark(player,kuangluan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"马神之力","我怎么还在断杀","general:pang__zoglin", {player})
        end
      end
    end
  end,
})
kuangluan:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return 1
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, kuangluan.name)
    local use = room:askToUseCard(player, {
      skill_name = kuangluan.name,
      pattern = "slash",
      prompt = "#kuangluan_sha",
      extra_data = {
        bypass_times = true,
      }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
      room:addPlayerMark(player,"kuangluan_counter",1)
    else
      room:loseHp(player, 1, kuangluan.name)
      if player.dead and player:getMark("kuangluan_counter") == 0 then
        if Fk.skills["glory_days__show"] and gdU and player:getMark(kuangluan.name.."_achive")==0 then
          room:setPlayerMark(player,kuangluan.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"马神之力","我怎么还在断杀","general:pang__zoglin", {player})
        end
      end
    end
  end,
})


Fk:loadTranslationTable {["pang_kuangluan"] = "狂乱",
[":pang_kuangluan"] = "锁定技，结束阶段或当你受到伤害后，你摸一张牌并选择一项：使用一张【杀】；失去1点体力。",
["#kuangluan_sha"] = "你需使用一张【杀】，否则失去1点体力",

["$pang_kuangluan1"] = "僵尸疣猪兽嘶吼",
["$pang_kuangluan2"] = "僵尸疣猪兽嘶吼",
}
return kuangluan  --不要忘记返回做好的技能对象哦