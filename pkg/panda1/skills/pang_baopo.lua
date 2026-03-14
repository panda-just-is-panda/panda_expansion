---@param player ServerPlayer @ 目标角色
EnterHidden = function (player)
  local room = player.room
  if player:getMark("__hidden_general") == 0 and player:getMark("__hidden_deputy") == 0 then
  room:sendLog({
    type = "#EnterHidden",
    from = player.id,
  })
  local skills = "hidden_skill&"
  room:setPlayerMark(player, "__hidden_general", player.general)
  for _, s in ipairs(Fk.generals[player.general]:getSkillNameList(true)) do
    if player:hasSkill(s, true) then
      skills = skills.."|-"..s
    end
  end
  if player.deputyGeneral ~= "" then
    room:setPlayerMark(player, "__hidden_deputy", player.deputyGeneral)
    for _, s in ipairs(Fk.generals[player.deputyGeneral]:getSkillNameList(true)) do
      if player:hasSkill(s, true) then
        skills = skills.."|-"..s
      end
    end
  end
  player.general = "hiddenone"
  player.gender = General.Male
  room:broadcastProperty(player, "gender")
  if player.deputyGeneral ~= "" then
    player.deputyGeneral = ""
  end
  player.kingdom = "jin"
  room:setPlayerMark(player, "__hidden_record",
  {
    maxHp = player.maxHp,
    hp = player.hp,
  })
  player.maxHp = 1
  player.hp = 1
  for _, property in ipairs({"general", "deputyGeneral", "kingdom", "maxHp", "hp"}) do
    room:broadcastProperty(player, property)
  end
  room:handleAddLoseSkills(player, skills, nil, false, true)
  end
end

local baopo = fk.CreateSkill {
  name = "pang_baopo",
}

Fk:loadTranslationTable{
  ["pang_baopo"] = "爆迫",
  [":pang_baopo"] = "出牌阶段，你可以重铸一张牌并令一名距离为1的其他角色选择一项：弃置两张牌并隐匿；你可以弃置两张和此牌类型不同的牌并对你和其各造成3点伤害，否则你隐匿。",
  ["#baopo_discard"] = "爆迫：你可以弃置两张牌并隐匿，否则 %src 可以弃牌并对其和你各造成3点伤害",
  ["#baopo_discard_player"] = "爆迫：你可以弃置两张和此牌类型不同的牌并对你和 %src 各造成3点伤害，否则你隐匿",
  ["#baopo_choose"] = "爆迫：你可以重铸一张牌并选择一名距离为1的其他角色",

  ["$pang_baopo1"] = "嘶——嘶嘶嘶嘶嘶嘶嘶嘶——",
  ["$pang_baopo2"] = "嘭！",
  ["$pang_baopo3"] = "呲嘶——",
}

baopo:addEffect("active", {
  anim_type = "control",
  mute = true,
  prompt = "#baopo_choose",
  card_num = 1,
  target_num = 1,
  can_use = function(self, player)
    return true
  end,
  card_filter = function(self, player, to_select, selected)
   return #selected < 1 and not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return player:distanceTo(to_select) == 1 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local to = effect.tos[1]
    local card = effect.cards[1]
    local type = Fk:getCardById(card).type
    room:recastCard(effect.cards, player, baopo.name)
    player:broadcastSkillInvoke(baopo.name, 1)
    local discard_1 = room:askToDiscard(to, {
        skill_name = baopo.name,
        prompt = "#baopo_discard:"..player.id,
        cancelable = true,
        min_num = 2,
        max_num = 2,
        include_equip = true,
    })
    if #discard_1 > 0 then
        EnterHidden(to)
        player:broadcastSkillInvoke(baopo.name, 3)
    else
        local available = table.filter(player:getCardIds("he"), function(id)
            local card = Fk:getCardById(id)
            return card and card.type ~= type
        end)
        local discard_2 = room:askToCards(player, {
            min_num = 2,
            max_num = 2,
            include_equip = true,
            prompt = "#baopo_discard_player:"..to.id,
            pattern = tostring(Exppattern{ id = available }),
            skill_name = baopo.name,
            cancelable = true,
        })
        if #discard_2 > 1 then
            room:throwCard(discard_2, baopo.name, player, player)
            player:broadcastSkillInvoke(baopo.name, 2)
            room:damage{
                from = player,
                to = player,
                damage = 3,
                skillName = baopo.name,
            }
            room:damage{
                from = player,
                to = to,
                damage = 3,
                skillName = baopo.name,
            }
        else
            EnterHidden(player)
            player:broadcastSkillInvoke(baopo.name, 3)
        end
    end
end
})

local U = require "packages.utility.utility"
local gdU
if Fk.skills["glory_days__show"] then
    gdU = require "packages.glory_days.utility"
    if type(gdU.RegisterAchievement) == "function" then
      gdU.RegisterAchievement("胖胖胖胖","闪电苦力怕","我的伤害翻倍呢？","受到闪电造成的伤害","general:pang__creeper",true,nil,true)
    end
end

baopo:addEffect(fk.Damage, {
  trigger_times = function(self, event, target, player, data)
    return 1
  end,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return data.to == player and player:hasSkill(self) and data.card and data.card.trueName == "lightning"
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if Fk.skills["glory_days__show"] and gdU then
          room:setPlayerMark(player,baopo.name.."_achive",1)
          gdU.addAchievement(room,"steam",250,nil,"闪电苦力怕","我的伤害翻倍呢？","general:pang__creeper", {player})
      end
  end,
})

return baopo