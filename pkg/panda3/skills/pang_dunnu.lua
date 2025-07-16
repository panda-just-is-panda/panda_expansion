local dunnu = fk.CreateSkill{
  name = "pang_dunnu",
    tags = {},
}

dunnu:addEffect(fk.TurnStart, {
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(dunnu.name) and player == target
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room:getAlivePlayers(),
        skill_name = dunnu.name,
        prompt = "#dunnu",
        cancelable = true,
        })
        if #tos > 0 then
          for _, p in ipairs(tos) do
            if not p.dead then
            room:damage{
          from = player,
          to = p,
          damage = 1,
          skillName = dunnu.name,
            }
            end
            if not player.dead then
            room:damage{
          from = player,
          to = player,
          damage = 1,
          skillName = dunnu.name,
            }
            end
          end
        end
  end
})

Fk:loadTranslationTable{
  ["pang_aiganglie"] = "惇怒",
  [":pang_aiganglie"] = "回合开始时，你可以选择一名角色，然后你依次对该角色和你各造成1点伤害。",
  ["#dunnu"] = "惇怒！",
}

return dunnu