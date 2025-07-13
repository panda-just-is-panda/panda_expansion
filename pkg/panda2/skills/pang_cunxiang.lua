local cunxiang = fk.CreateSkill({
  name = "pang_cunxiang", ---技能内部名称，要求唯一性
  tags = {Skill.Switch}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

cunxiang:addEffect("viewas", {
  anim_type = "support",
  prompt = "#cunxiang1",
  pattern = "analeptic",
  card_filter = Util.FalseFunc,
  before_use = function(self, player)
    if player:getSwitchSkillState(cunxiang.name, true) ~= fk.SwitchYang then 
        player:turnOver()
    else
        player:drawCards(2, cunxiang.name)
    end
  end,
  view_as = function(self, player)
    local c = Fk:cloneCard("analeptic")
    c.skillName = cunxiang.name
    return c
  end,
  enabled_at_play = function (self, player)
    return player:getSwitchSkillState(cunxiang.name, true) ~= fk.SwitchYang and player.faceup or player:getSwitchSkillState(cunxiang.name, true) == fk.SwitchYang
  end,
  enabled_at_response = function (self, player, response)
    return not response
  end,
})


Fk:loadTranslationTable {["pang_cunxiang"] = "存想",
[":pang_cunxiang"] = "转换技，当你需要使用【酒】时，你可以①将武将牌翻至背面②摸两张牌，然后你视为使用之。",
["#cunxiang1"] = "你可以视为使用一张【酒】",
}
return cunxiang