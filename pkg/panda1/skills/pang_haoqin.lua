local haoqin = fk.CreateSkill({
  name = "pang_haoqin", ---技能内部名称，要求唯一性
  tags = {Skill.Limited}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})
local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages/glory_days/utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","点子扎手","致敬贾大爷乱武完杀自己","你于“浩侵”结算期间死亡","general:pang__re_pillager",true,nil,true)
    end
end

haoqin:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#haoqin",
  card_num = 0,
  min_target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(haoqin.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return not to_select.dead
  end,
  feasible = function(self, player, selected, selected_cards)
    return #selected > 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local targets = table.simpleClone(effect.tos)
    room:sortByAction(targets)
    for _, p in ipairs(targets) do
      if not p.dead then
        room:setPlayerMark(p, "pang_haoqin_choose-turn", 1)
        local slash = Fk:cloneCard("slash")
        local max_num = slash.skill:getMaxTargetNum(p, slash)
        local targets = table.filter(room:getOtherPlayers(p, false), function (p2)
          return p:canUseTo(slash, p2, {bypass_times = true})
        end)
        if #targets > 0 then
          local tos = room:askToChoosePlayers(p, {
            min_num = 1,
            max_num = max_num,
            targets = targets,
            skill_name = haoqin.name,
            prompt = "#haoqin_choose",
            cancelable = false,
          })
          if #tos > 0 then
            local targets = tos
            room:sortByAction(targets)
            room:useVirtualCard("slash", nil, p, targets, haoqin.name, true)
          end
        end
      end
    end
    local others = {}
    for _, p in ipairs(Fk:currentRoom().alive_players) do
      if p:getMark("pang_haoqin_choose-turn") == 0 then
        table.insert(others, p)
      end
    end
    for _, p in ipairs(others) do
      local use = room:askToUseCard(p, {
        skill_name = haoqin.name,
        pattern = "slash",
        prompt = "#haoqin_strikeback",
        extra_data = {
          bypass_times = true,
        }
      })
      if use then
        use.extraUse = true
        room:useCard(use)
      end
    end
    if player.dead then
      if Fk.skills["glory_days__show"] and gdU and player:getMark(haoqin.name.."_achive")==0 then
        room:setPlayerMark(player,haoqin.name.."_achive",1)
        gdU.addAchievement(room,"steam",250,nil,"点子扎手","致敬贾大爷乱武完杀自己","general:pang__re_pillager", {player})
      end
    end
  end,
})

Fk:loadTranslationTable {["pang_haoqin"] = "浩侵",
[":pang_haoqin"] = "限定技，出牌阶段，你可以令任意名角色依次视为使用一张【杀】，然后其余角色依次可以使用一张【杀】。",
["#haoqin"] = "浩侵：令任意名角色依次视为使用一张【杀】，其余角色依次可以使用一张【杀】",
["#haoqin_choose"] = "浩侵：视为使用一张【杀】",
["#haoqin_strikeback"] = "浩侵：你可以使用一张【杀】",

["$pang_haoqin1"] = "嘟嘟～嘟～嘟——嘟——",
["$pang_haoqin2"] = "嘟嘟～嘟嘟——嘟——",
}
return haoqin