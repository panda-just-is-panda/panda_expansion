local pangnu = fk.CreateSkill {
  name = "pang_pangnu",
  tags = {},
}

pangnu:addEffect(fk.RoundEnd, {
  anim_type = "offensive",
   can_trigger = function(self, event, target, player, data)
    return player:hasSkill(pangnu.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local fire_attack = Fk:cloneCard("fire_attack")
      local tos = table.filter(room.alive_players, function (p)
      return player:canUseTo(fire_attack, p) and p:getMark("pangnu_fire-round") > 0
      end)
      local targets = tos
      if #targets > 0 then
        room:sortByAction(targets)
        room:useVirtualCard("fire_attack", nil, player, targets, pangnu.name, true)
      end
    if player:getMark("pangnu_firedealt-round") == 0 then
        player:chat(
          "唉，废物胖")
        room:handleAddLoseSkills(player, "-pang_pangnu", nil, false, true)
    end
  end,
})

pangnu:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(pangnu.name) and target and target:getMark("pangnu_fire-round") == 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(target, "pangnu_fire-round", 1)
  end,
})

pangnu:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, pangnu.name)
  end,
  on_refresh = function(self, event, target, player, data)
      player.room:addPlayerMark(target, "pangnu_firedealt-round", 1)
  end,
})

Fk:loadTranslationTable {["pang_pangnu"] = "胖怒",
[":pang_pangnu"] = "每轮结束时，你可以视为对所有本轮造成过伤害的角色使用一张【火攻】；若你未因此造成伤害，你失去此技能。",
["#pang_pangnu1"] = "将手牌摸至手牌上限",
["#pang_taipang2"] = "令你的手牌上限+1",

["$pang_pangnu1"] = "胖怒！",
["$pang_pangnu2"] = "太怒！",
}

return pangnu