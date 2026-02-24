local skel = fk.CreateSkill{
  name = "pang__lianxiu",
  tags = { Skill.Compulsory }
}
Fk:loadTranslationTable{
  ["pang__lianxiu"] = "炼修",
  [":pang__lianxiu"] = "锁定技，①你的所有阶段改为重铸任意张手牌并使用一张因此重铸的牌；②当你失去最后一张手牌后，你摸三张牌；③回合结束时，若你的手牌数大于三，你将手牌调整至三张并回复1点体力。",
  ["#pang__lianxiu-invoke"] = "炼修：现在是 %arg ，你重铸任意张手牌并使用其中一张",
  ["#pang__lianxiu-use"] = "炼修：使用一张牌",
  ["#pang__lianxiu-discard"] = "炼修：你须将手牌弃至三张，然后你回复1点体力",
}

---@type TrigSkelSpec<PhaseFunc>
local lianxiu = {
  mute = true,
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(skel.name) and player == target
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    data.phase_end = true
    room:notifySkillInvoked(player, skel.name, "special")
    local phases = { "", "phase_start", "phase_judge", "phase_draw", "phase_play", "phase_discard", "phase_finish" }
    local cids = {}
    if not player:isKongcheng() then
      cids = room:askToCards(player, {
        min_num = 1,
        max_num = 999,
        skill_name = skel.name,
        cancelable = false,
        prompt = "#pang__lianxiu-invoke:::" .. phases[player.phase],
        include_equip = false,
      })
    end
    if #cids > 0 then
      room:recastCard(cids, player, skel.name)
      if not player.dead then
        cids = table.filter(cids, function (id)
          return table.contains({ Card.DiscardPile, Card.DrawPile }, room:getCardArea(id))
        end)
        if #cids > 0 then
          room:askToUseRealCard(player, {
            skill_name = skel.name,
            pattern = tostring(Exppattern{ id = cids }),
            prompt = "#pang__lianxiu-use",
            extra_data = {
              bypass_times = true
            }
          })
        end
      end
    end
  end,
}
---@type TrigSkelSpec<MoveCardsFunc>
local lianxiu_trig = {
  mute = true,
  can_trigger = function (self, event, target, player, data)
    if player:hasSkill(skel.name, true) then
      for _, move in ipairs(data) do
        if move.from == player then 
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerHand then
              if player:isKongcheng() and player:hasSkill(skel.name) then
                return true
              end
            end
          end
        end
      end
    end
  end,
  on_use = function (self, event, target, player, data)
    player:drawCards(3, skel.name)
  end
}
---@type TrigSkelSpec<TurnFunc>
local lianxiu_discard = {
  mute = true,
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(skel.name) and player == target and #player:getCardIds("h") > 3
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local num = #player:getCardIds("h") - 3
    room:askToDiscard(player, {
      min_num = num,
      max_num = num,
      cancelable = false,
      skill_name = skel.name,
      prompt = "#pang__lianxiu-discard"
    })
    if not player.dead and player:isWounded() then
      room:recover{
        who = player,
        num = 1,
        skillName = skel.name
      }
    end
  end
}
---@type TrigSkelSpec<TurnFunc>
local lianxiu_effect = {
  can_refresh = function (self, event, target, player, data)
    return player:hasSkill(skel.name) and player == target
  end,
  on_refresh = function (self, event, target, player, data)
    player.room:notifySkillInvoked(player, skel.name, "special")
  end
}
skel:addEffect(fk.EventPhaseStart, lianxiu)
skel:addEffect(fk.AfterCardsMove, lianxiu_trig)
skel:addEffect(fk.TurnEnd, lianxiu_discard)
skel:addEffect(fk.TurnStart, lianxiu_effect)
return skel