local skill = fk.CreateSkill("active", {
  anim_type = "control",
  card_num = 1,
  target_num = 1,
  prompt = "#ex__fanjian",
  max_phase_use_time = 1,
   card_filter = function(self, player, to_select, selected)
    return #selected == 0 and table.contains(player:getCardIds("h"), to_select)
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local id = room:askToChooseCard(player, {target = to, flag = "he", skill_name = pang_fanjian.name})
    room:throwCard({id}, pang_fanjian.name, to, player)
  end,
})

Fk:loadTranslationTable {["pang_chaiqian"] = "拆迁",
[":pang_fanjian"] = "出牌阶段限一次，你可以弃置一张手牌并弃置一名其他角色一张牌。",
["#ex__fanjian"] = "弃置一张手牌并选择一名其他角色，然后你弃置其一张牌"
}
return skill  --不要忘记返回做好的技能对象哦