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

local jjf = fk.CreateSkill {
  name = "pang_jianjiefu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_jianjiefu"] = "茧结缚",
  [":pang_jianjiefu"] = "锁定技，当你使用点数为4的牌后，你隐匿。",
}

jjf:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        if target ~= player or not player:hasSkill(jjf.name) then return end
        local card_number = data.card.number
        if card_number == 4 then
            return true
        end
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        EnterHidden(player)
    end,
})