local tongchu = fk.CreateSkill({
  name = "pang_tongchu",
  attached_skill_name = "pang_tongchu_active&",
})

Fk:loadTranslationTable{
  ["pang_tongchu"] = "铜储",
  [":pang_tongchu"] = "每名角色的出牌阶段限一次，若你的“货”数小于5，其可以将一张牌扣置于你的武将牌上，称为“货”；当你使用或打出牌后，你可以获得一张“货”。",

  ["$copper_golem_huo"] = "货",
  ["#pang_tongchu_get"] = "铜储：你可以获得一张“货”",
  ["tongchu_getcard"] = "铜储：你可以获得一张“货”",


  ["$pang_tongchu1"] = "机关检测声",
  ["$pang_tongchu2"] = "机械运转声",
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

local tongchu_spec = {
anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(tongchu.name)
    end,
    on_cost = function(self, event, target, player, data)
      local room = player.room
      if room:askToSkillInvoke(player, { skill_name = tongchu.name, prompt = "tongchu_getcard"}) then
        local cards, choice = room:askToChooseCardsAndChoice(
          target,
          {
            cards = player:getPile("$copper_golem_huo"),
            choices = { "OK" },
            skill_name = tongchu.name,
            prompt = "#pang_tongchu_get",
            cancel_choices = { "Cancel" }
          }
        )
        if choice == "OK" and #cards > 0 then
          event:setCostData(self, { cards = cards })
          return true
        end
      end
    end,
    on_use = function(self, event, target, player, data)
      player.room:moveCardTo(event:getCostData(self).cards, Card.PlayerHand, player, fk.ReasonJustMove, tongchu.name, nil, true, player)
  end,
}

tongchu:addEffect(fk.CardUseFinished, tongchu_spec)
tongchu:addEffect(fk.CardRespondFinished, tongchu_spec)

return tongchu