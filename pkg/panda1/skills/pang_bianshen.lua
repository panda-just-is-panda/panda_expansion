local bianshen = fk.CreateSkill {
  name = "#pang_bianshen",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["#pang_bianshen"] = "胖将变身",
  [":#pang_bianshen"] = "游戏开始时，你可以变胖！！",

  ["#panda_bianshen"] = "胖胖：你可以变成胖胖！",

  ["$pang_bianshen"] = "太胖太胖",
}

bianshen:addEffect(fk.Death, {
  anim_type = "support",
  prompt = "#panda_bianshen",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(bianshen.name, true, true)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:animDelay(3)
    local general_1 = "pang__pangpanda"
    room:findGeneral(general_1)
    room:changeHero(player, general_1, false, false, true, true)
    room:handleAddLoseSkills(player, "pang_taipang", nil, false, true)
    room:handleAddLoseSkills(player, "pang_pangnu", nil, false, true)
    player:chat("太胖")
  end
})

return bianshen