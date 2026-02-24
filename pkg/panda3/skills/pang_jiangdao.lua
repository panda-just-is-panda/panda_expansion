local skel = fk.CreateSkill{
  name = "pang__jiangdao",
}
Fk:loadTranslationTable{
  ["pang__jiangdao"] = "讲道",
  [":pang__jiangdao"] = "回合开始时，你可以选择一名角色，若其手牌数：为0，其摸三张牌；大于3，其将手牌弃置至三张并回复1点体力；" ..
  "均不满足，其可以重铸任意张手牌并可以使用一张因此重铸的牌。",
  ["#pang__jiangdao-choose"] = "讲道：你可以选择一名角色，并执行相应选项",
  ["#pang__jiangdao-discard"] = "讲道：你须将手牌弃至三张",
  ["#pang__jiangdao-recast"] = "讲道：你可以重铸任意张手牌并使用一张因此重铸的牌",
  ["#pang__jiangdao-use"] = "讲道：你可以使用一张牌",

  ["$pang__jiangdao1"] = "灵台蒙尘者，需受天河洗",
  ["$pang__jiangdao2"] = "掌心三寸乾坤小，丹田方寸天地宽",
}
---@type TrigSkelSpec<TurnFunc>
local jiangdao = {
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(skel.name) and player == target
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      targets = room:getAlivePlayers(),
      min_num = 1,
      max_num = 1,
      skill_name = skel.name,
      prompt = "#pang__jiangdao-choose",
    })
    if #tos == 1 then
      event:setCostData(self, { to = tos[1] })
      return true
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    room:notifySkillInvoked(player, skel.name, "support")
    local to = event:getCostData(self).to ---@type ServerPlayer
    if #to:getCardIds("h") == 0 then
      to:drawCards(3, skel.name)
    elseif #to:getCardIds("h") > 3 then
      local num = #to:getCardIds("h") - 3
      room:askToDiscard(to, {
        min_num = num,
        max_num = num,
        cancelable = false,
        skill_name = skel.name,
        prompt = "#pang__jiangdao-discard"
      })
      if not to.dead and to:isWounded() then
        room:recover{
          who = to,
          num = 1,
          skillName = skel.name
        }
      end
    else
      local cids = room:askToCards(to, {
        min_num = 1,
        max_num = 999,
        skill_name = skel.name,
        cancelable = false,
        prompt = "#pang__jiangdao-recast",
        include_equip = false,
      })
      if #cids > 0 then
        room:recastCard(cids, to, skel.name)
        if not to.dead then
          cids = table.filter(cids, function (id)
            return table.contains({ Card.DiscardPile, Card.DrawPile }, room:getCardArea(id))
          end)
          if #cids > 0 then
            room:askToUseRealCard(to, {
              skill_name = skel.name,
              pattern = tostring(Exppattern{ id = cids }),
              expand_pile = cids,
              prompt = "#pang__jiangdao-use",
            })
          end
        end
      end
    end
  end
}
skel:addEffect(fk.TurnStart, jiangdao)
return skel