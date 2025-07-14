local gouyun = fk.CreateSkill{
  name = "pang_gouyun",
  tags = {Skill.Permanent},
}

gouyun:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gouyun.name) and
    (player.phase == Player.Judge or player.phase == Player.Draw)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local ret = room:askToArrangeCards(player, {
      skill_name = gouyun.name,
      card_map = {room:getNCards(10, "bottom"), "Bottom", "Top"},
      prompt = "#gouyun",
      free_arrange = true,
      max_limit = {10, 9},
      min_limit = {0, 1},
    })
    local top, bottom = ret[2], ret[1]
    for i = #top, 1, -1 do
      table.removeOne(room.draw_pile, top[i])
      table.insert(room.draw_pile, 1, top[i])
    end
    for i = 1, #bottom, 1 do
      table.removeOne(room.draw_pile, bottom[i])
      table.insert(room.draw_pile, bottom[i])
    end
    room:sendLog{
      type = "#GuanxingResult",
      from = player.id,
      arg = #top,
      arg2 = #bottom,
    }
  end,
})

gouyun:addEffect(fk.EventPhaseStart, {
    can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(gouyun.name) and
    player.phase == Player.End
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:shuffleDrawPile()
  end,
})


Fk:loadTranslationTable{
  ["pang_gouyun"] = "狗运",
  [":pang_gouyun"] = "持恒技，判定阶段开始时或摸牌阶段开始时，你观看牌堆底的十张牌并可以将其中一张置于牌堆顶；结束阶段，你洗牌。",
  ["#gouyun"] = "将其中一张置于牌堆顶",
  ["$pang_gouyun1"] = "颅献白骨观，血祭黄沙场！",
  ["$pang_gouyun2"] = "拥酒炙胡马，北虏复唱匈奴歌！",
}


return gouyun