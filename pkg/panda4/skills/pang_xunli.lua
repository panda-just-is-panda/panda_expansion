local xunli = fk.CreateSkill {
  name = "pang_xunli",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_xunli"] = "循理",
  [":pang_xunli"] = "主公技，每回合限一次，当一名蜀势力角色弃置任意角色的牌后，其可以交给你一张牌并摸一张牌。",
  ["#xunli-give"] = "你可以交给刘禅一张牌并摸一张牌",

  ["$pang_xunli1"] = "蜀汉有相父在，我可安心。",
  ["$pang_xunli2"] = "这些事情，你们安排就好。",
}

xunli:addEffect(fk.AfterCardsMove,{
        anim_type = "defensive",
      can_trigger = function (self, event, target, player, data)
              if player:hasSkill(xunli.name) and player:usedSkillTimes(xunli.name, Player.HistoryTurn) < 1 then
              for _, move in ipairs(data) do
                if #move.moveInfo > 0 then
                  if move.proposer and  move.proposer.kingdom == "shu" and move.proposer ~= player and move.moveReason == fk.ReasonDiscard and move.from then
                  for _, info in ipairs(move.moveInfo) do
                    if table.contains({Card.PlayerEquip,Card.PlayerHand},info.fromArea) then
                      return true
                    end
                end
              end
            end
          end
        end
      end,
      on_cost = function (self, event, target, player, data)
        local room = player.room
        local user = data.move.proposer
        local cards = room:askToCards(user, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            skill_name = xunli.name,
            prompt = "#xunli-give",
            cancelable = true,
            })
        if #cards > 0 then
            room:obtainCard(player, cards, false, fk.ReasonGive)
            return true
        end
      end,
      on_use = function (self, event, target, player, data)
        local user = data.move.proposer
        user:drawCards(1)
      end,
    })

    return xunli