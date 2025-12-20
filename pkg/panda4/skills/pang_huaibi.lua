local huaibi = fk.CreateSkill {
  name = "pang_huaibi",
  tags = { Skill.Compulsory, Skill.Lord },
}

local U = require "packages.utility.utility"
Fk:loadTranslationTable{
  ["pang_huaibi"] = "怀璧",
  [":pang_huaibi"] = "主公技，锁定技，游戏开始时，你获得X点护甲(X为群势力角色数)；有护甲的你受到伤害时，伤害来源获得1点护甲。",

  ["$pang_huaibi1"] = "哎！匹夫无罪，怀璧其罪啊。",
  ["$pang_huaibi2"] = "粮草尽皆在此，宗兄可自取之。",
}
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","怀璧其罪","谁家董卓？","游戏开始时因“怀璧”获得5点护甲","general:pang__liuzhang",true,nil,true)
    end
end

huaibi:addEffect(fk.GameStart, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local X = 0
    for _, p in ipairs(Fk:currentRoom().alive_players) do
      if p.kingdom == "qun" then
        X = X + 1
      end
    end
    room:changeShield(player, X, {cancelable = false})
    if X > 4 then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(huaibi.name.."_achive")==0 then
        room:setPlayerMark(player,huaibi.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"怀璧其罪","谁家董卓？","general:pang__liuzhang", {player})
      end
    end
  end,
})

huaibi:addEffect(fk.DamageInflicted, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name) and target == player and target.shield > 0 and data.from
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.from
    room:changeShield(to, 1, {cancelable = false})
  end,
})


return huaibi