local skill = fk.CreateSkill({
  name = "pang_fanjian", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

skill:addEffect("active", {
  anim_type = "control",
  card_num = 1,
  target_num = 1,
  prompt = "#ex__fanjian",
   card_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
    can_use = function(self, player)
    return player:usedSkillTimes(skill.name, Player.HistoryPhase) == 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local id = room:askToChooseCard(player, {target = to, flag = "he", skill_name = skill.name})
    room:throwCard({id}, skill.name, to, player)
  end,
})

Fk:loadTranslationTable {["pang_fanjian"] = "反间",
[":pang_fanjian"] = "出牌阶段限一次，你可以弃置一张手牌并弃置一名其他角色一张牌。",
["#ex__fanjian"] = "弃置一张手牌并选择一名其他角色，然后你弃置其一张牌"
}
return skill  --不要忘记返回做好的技能对象哦