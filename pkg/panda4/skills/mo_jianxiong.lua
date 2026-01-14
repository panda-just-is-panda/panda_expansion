local skel = fk.CreateSkill {
  name = "mo_jianxiong",
}

Fk:loadTranslationTable{
  ["mo_jianxiong"] = "奸雄",
  [":mo_jianxiong"] = "当你指定或成为伤害牌目标时，可以摸一张牌并令此牌对一名目标角色的结算改为：对其造成1点伤害，然后其获得此牌（每轮每种牌名限一次）或摸一张牌。",

  ["#"] = "奸雄：你可以获得对你造成伤害的牌",
  ["#mo_jianxiong-get"] = "奸雄：你可以将%arg对一名目标角色的效果改为造成1点伤害并令其选择获得此牌或摸一张牌",


}

skel:addEffect(fk.AfterCardTargetDeclared, {
  anim_type = "masochism",
  can_trigger = function (self, event, target, player, data)
    if target == player and player:hasSkill(skel.name) then
      return data.from and data.card.is_damage_card
    end
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
          min_num = 1,
          max_num = 1,
          targets = data.tos,
          skill_name = skel.name,
          prompt = "#mo_jianxiong-get:::"..data.card:toLogString(),
          cancelable = true,
        })
    if #to > 0 then
        event:setCostData(self, {tos = to})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, skel.name)
    data.extra_data = data.extra_data or {}
    data.extra_data.efengqi__jianxiongTos = data.extra_data.efengqi__jianxiongTos or {}
    table.insertIfNeed(data.extra_data.efengqi__jianxiongTos, event:getCostData(self).tos[1])
    if data.card.trueName == "slash" then
      data.unoffsetableList = {event:getCostData(self).tos[1]}
    end
  end,
})

skel:addEffect(fk.TargetConfirming, {
  anim_type = "masochism",
  can_trigger = function (self, event, target, player, data)
    if target == player and player:hasSkill(skel.name) then
      return data.from and data.card.is_damage_card
    end
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
          min_num = 1,
          max_num = 1,
          targets = data.use.tos,
          skill_name = skel.name,
          prompt = "#mo_jianxiong-get:::"..data.card:toLogString(),
          cancelable = true,
        })
    if #to > 0 then
        event:setCostData(self, {tos = to})
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, skel.name)
    data.extra_data = data.extra_data or {}
    data.extra_data.efengqi__jianxiongTos = data.extra_data.efengqi__jianxiongTos or {}
    table.insertIfNeed(data.extra_data.efengqi__jianxiongTos, event:getCostData(self).tos[1])
    if data.card.trueName == "slash" then
      data.disresponsive = true
    end
  end,
})


skel:addEffect(fk.PreCardEffect, {
  can_refresh = function(self, event, target, player, data)
    return data.to == player and
    data.extra_data and data.extra_data.efengqi__jianxiongTos and table.contains(data.extra_data.efengqi__jianxiongTos, data.to)
  end,
  on_refresh = function(self, event, target, player, data)
    data:changeCardSkill("mo_jianxiong_card_skill")
  end,
})



return skel