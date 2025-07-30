local taipang = fk.CreateSkill {
  name = "pang_taipang",
  tags = {},
}

taipang:addEffect(fk.TargetSpecifying, {
  anim_type = "offensive",
   can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(taipang.name) and table.contains(data.use.tos, player)
    and (player:getMark("taipang1-turn") == 0 or player:getMark("taipang2-turn") == 0)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:cancelTarget(player)
    local choices = {}
    if player:getMark("taipang1-turn") == 0 then
        table.insert(choices, 1, "#pang_taipang1")
    end
    if player:getMark("taipang2-turn") == 0 then
        table.insert(choices, 2, "#pang_taipang2")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = taipang.name,
    })
    if choice == "#pang_taipang1" then
        room:addPlayerMark(target, "taipang1-turn", 1)
        local to_draw = player:getMaxCards() - player:getHandcardNum()
        if to_draw > 0 then
             player:drawCards(to_draw, taipang.name)
        end
    else
        room:addPlayerMark(target, "taipang2-turn", 1)
        room:addPlayerMark(player, MarkEnum.AddMaxCards, 1)
    end
  end,
})

Fk:loadTranslationTable {["pang_taipang"] = "太胖",
[":pang_taipang"] = "每回合各限一次，当你使用牌指定自己为目标时，你可以取消之并选择一项：将手牌摸至手牌上限；令你的手牌上限+1。",
["#pang_taipang1"] = "将手牌摸至手牌上限",
["#pang_taipang2"] = "令你的手牌上限+1",
}

return taipang