local gukuang = fk.CreateSkill{
  name = "pang_gukuang",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["pang_kuanggu"] = "骨狂",
  [":pang_kuanggu"] = "锁定技，当你受到1点伤害后，你需弃置一张牌或失去1点体力。",

  ["losehp"] = "失去1点体力",
  ["discard1"] = "弃置一张牌",
  ["#gukuang_discard"] = "骨狂：你需弃置一张牌",
}

gukuang:addEffect(fk.Damaged, {
  anim_type = "negative",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gukuang.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = {"losehp"}
    if not player:isNude() then
        table.insert(choices, 2, "discard1")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = gukuang.name,
    })
    event:setCostData(self, {choice = choice})
    return true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if event:getCostData(self).choice == "losehp" then
        room:loseHp(player, 1, gukuang.name)
    else
        local card = room:askToDiscard(player, {
          skill_name = gukuang.name,
          prompt = "#gukuang_discard",
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = true,
        })
    end
  end,
})


return gukuang