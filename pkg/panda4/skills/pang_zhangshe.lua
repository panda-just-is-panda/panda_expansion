local zhangshe = fk.CreateSkill{
  name = "pang_zhangshe",
  tags = { },
}

Fk:loadTranslationTable{
  ["pang_zhangshe"] = "掌舌",
  [":pang_zhangshe"] = "体力值不大于你的角色的摸牌阶段开始时，你可以摸三张牌并将其中两张牌置于牌堆顶，然后将一张手牌置于牌堆底。",
  ["#zhangshe1"] = "掌舌：将其中两张牌置于牌堆顶",
  ["#zhangshe2"] = "掌舌：将一张手牌置于牌堆底",

  ["$pang_zhangshe1"] = "这都是陛下的恩泽呀。",
  ["$pang_zhangshe2"] = "陛下盛宠，臣万莫敢忘。",
}

zhangshe:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zhangshe.name) and target.phase == Player.Draw and target.hp <= player.hp
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = player:drawCards(3, zhangshe.name)
    local toPut = room:askToCards(player, {
      min_num = 2,
      max_num = 2,
      include_equip = true,
      skill_name = zhangshe.name,
      pattern = tostring(Exppattern{ id = cards }),
      prompt = "#zhangshe1",
      cancelable = false,
    })
    toPut = room:askToGuanxing(player, {
        cards = toPut,
        top_limit = { #toPut, #toPut },
        bottom_limit = { 0, 0 },
        skill_name = zhangshe.name,
        skip = true,
      }).top
    toPut = table.reverse(toPut)
    room:moveCardTo(toPut, Card.DrawPile, nil, fk.ReasonPut, zhangshe.name, nil, true)
    local toPut2 = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = zhangshe.name,
      prompt = "#zhangshe2",
      cancelable = false,
    })
    room:moveCards({
      ids = toPut2,
      from = player,
      toArea = Card.DrawPile,
      moveReason = fk.ReasonPut,
      skillName = zhangshe.name,
      drawPilePosition = -1,
    })
  end,
})

return zhangshe