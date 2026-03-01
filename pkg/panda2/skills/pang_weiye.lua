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

local weiye = fk.CreateSkill{
  name = "pang_weiye",
  }

Fk:loadTranslationTable{
  ["pang_weiye"] = "伟液",
  [":pang_weiye"] = "出牌阶段，你可以选择一项：获得一名角色一张牌，然后其弃置你两张牌；交给一名角色一张牌，然后你弃置其两张牌。当你每回合非首次发动此技能时，你隐匿。",

  ["#weiye1"] = "获得一名角色一张牌，然后弃置两张牌",
  ["#weiye2"] = "交给一名角色一张牌，然后你弃置其两张牌",
  ["#weiye_discard"] = "伟液：弃置两张牌",
  ["#weiye_discard2"] = "伟液：弃置 %src 两张牌",
  ["#weiye-choosing"] = "伟液：选择一名角色并获得其一张牌，或选择一张牌并将此牌交给一名角色",

}

weiye:addEffect("active", {
  anim_type = "control",
  min_card_num = 0,
  target_num = 1,
  prompt = "#weiye-choosing",
  can_use = Util.TrueFunc,
  card_filter = function (self, player, to_select, selected)
    return #selected < 2
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isNude()
  end,
  feasible = function (self, player, selected, selected_cards)
      return true
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    if #effect.cards > 0 then
        local card = effect.cards
        room:obtainCard(target, card, false, fk.ReasonGive)
        local cards = room:askToChooseCards(player, {
            target = target,
            min = 2,
            max = 2,
            flag = "he",
            skill_name = weiye.name,
            prompt = "#weiye_discard2:"..target.id,
        })
        room:throwCard(cards, weiye.name, target, player)
        room:addPlayerMark(player, "weiye-turn", 1)
    else
        local card = room:askToChooseCard(player, {
          target = target,
          skill_name = weiye.name,
          flag = "he",
        })
        room:obtainCard(player, card, false, fk.ReasonPrey)
        local cards = room:askToChooseCards(target, {
            target = player,
            min = 2,
            max = 2,
            flag = "he",
            skill_name = weiye.name,
            prompt = "#weiye_discard2:"..player.id,
        })
        room:addPlayerMark(player, "weiye-turn", 1)
    end
    if player:getMark("weiye-turn") > 1 then
        EnterHidden(player)
    end
  end,
})

return weiye