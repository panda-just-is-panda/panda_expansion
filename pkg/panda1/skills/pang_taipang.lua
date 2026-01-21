local taipang = fk.CreateSkill {
  name = "pang_taipang",
  tags = {},
}
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","太胖太胖","胖胖太胖太胖","手牌上限增加到10及以上","general:pang__panda",true,nil,true)
    end
end

taipang:addEffect(fk.TargetSpecifying, {
  anim_type = "offensive",
   can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(taipang.name) and table.contains(data.use.tos, player)
    and (player:getMark("taipang1-turn") == 0 or player:getMark("taipang2-turn") == 0)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:cancelTarget(player)
    local choices = {}
    if player:getMark("taipang2-turn") == 0 then
        table.insert(choices, 1, "#pang_taipang2")
    end
    if player:getMark("taipang1-turn") == 0 then
        table.insert(choices, 1, "#pang_taipang1")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = taipang.name,
    })
    if choice == "#pang_taipang1" then
        room:addPlayerMark(target, "taipang1-turn", 1)
        local to_draw = player:getMaxCards() - player:getHandcardNum()
        if to_draw > 0 then
             player:drawCards(to_draw, taipang.name)
        end
    else
        room:addPlayerMark(target, "taipang2-turn", 1)
        room:addPlayerMark(player, MarkEnum.AddMaxCards, 1)
    end
    if player:getMaxCards() > 9 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(taipang.name.."_achive")==0 then
        room:setPlayerMark(player,taipang.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"太胖太胖","胖胖太胖太胖","general:pang__panda", {player})
      end
    end
  end,
})



Fk:loadTranslationTable {["pang_taipang"] = "太胖",
[":pang_taipang"] = "每回合各限一次，当你使用牌指定自己为目标时，你可以取消之并选择一项：将手牌摸至手牌上限；令你的手牌上限+1。",
["#pang_taipang1"] = "将手牌摸至手牌上限",
["#pang_taipang2"] = "令你的手牌上限+1",


["$pang_taipang1"] = "何故胖",
["$pang_taipang2"] = "唉太胖",
}

return taipang