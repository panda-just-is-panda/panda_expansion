local haoshou = fk.CreateSkill({
  name = "pang_haoshou", ---技能内部名称，要求唯一性
  tags = {},
})

haoshou:addEffect(fk.EventPhaseStart, { --
  anim_type = "offensive", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player.phase == Player.Start
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local duel = Fk:cloneCard("duel")
    local choices = {"losehp", ""}
  end
})


Fk:loadTranslationTable {["pang_haoshou"] = "狂乱",
[":pang_haoshou"] = "锁定技，结束阶段或当你受到伤害后，你摸一张牌并选择一项：使用一张【杀】；失去1点体力。",
["#haoshou"] = "你需使用一张【杀】，否则失去1点体力",
}
return haoshou  --不要忘记返回做好的技能对象哦