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
      max_limit = {1, 1},
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
    player.phase == Player.Finish
    end,
  on_refresh = function(self, event, target, player, data)
    player.room:shuffleDrawPile()
  end,
})


Fk:loadTranslationTable{
  ["pang_gouyun"] = "狗运",
  [":pang_gouyun"] = "持恒技，判定阶段或摸牌阶段开始时，你可以观看牌堆底的十张牌并将其中一张置于牌堆顶；结束阶段，你洗牌。",
  ["#gouyun"] = "将其中一张置于牌堆顶",
  ["$pang_gouyun1"] = "百战生豪意，一戟破万军！",
  ["$pang_gouyun2"] = "烽烟既起，吾当独擎沙场！",
}


return gouyun