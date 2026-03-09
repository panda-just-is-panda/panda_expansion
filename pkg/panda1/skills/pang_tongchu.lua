local tongchu = fk.CreateSkill({
  name = "pang_tongchu",
  attached_skill_name = "pang_tongchu_active&",
})

Fk:loadTranslationTable{
  ["pang_tongchu"] = "铜储",
  [":pang_tongchu"] = "每名角色的出牌阶段限一次，若你的“货”数小于5，其可以将一张牌扣置于你的武将牌上，称为“货”；你可以将“货”如手牌般使用或打出。",



  ["$1"] = "",
  ["$2"] = "",
}

tongchu:addAcquireEffect(function (self, player)
  local room = player.room
  for _, p in ipairs(room.alive_players) do
    room:handleAddLoseSkills(p, "pang_tongchu_active&", nil, false, true)
  end
end)

tongchu:addLoseEffect(function (self, player, is_death)
  local room = player.room
  for _, p in ipairs(room.alive_players) do
    room:handleAddLoseSkills(p, "-pang_tongchu_active&", nil, false, true)
  end
end)

tongchu:addEffect("filter", {
  handly_cards = function (self, player)
    if player:hasSkill(tongchu.name) then
      return player:getPile("copper_golem_huo")
    end
  end,
})

return tongchu