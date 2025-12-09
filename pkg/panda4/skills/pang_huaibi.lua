local huaibi = fk.CreateSkill {
  name = "pang_huaibi",
  tags = { Skill.Compulsory, Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_huaibi"] = "怀璧",
  [":pang_huaibi"] = "主公技，锁定技，游戏开始时，你获得X点护甲(X为群势力角色数)；有护甲的你受到伤害时，伤害来源获得1点护甲。",

  ["$pang_huaibi1"] = "哎！匹夫无罪，怀璧其罪啊。",
  ["$pang_huaibi2"] = "粮草尽皆在此，宗兄可自取之。",
}

huaibi:addEffect(fk.GameStart, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local X = 0
    for _, p in ipairs(Fk:currentRoom().alive_players) do
      if p.kingdom == "qun" then
        X = X + 1
      end
    end
    room:changeShield(player, X, {cancelable = false})
  end,
})

huaibi:addEffect(fk.DamageInflicted, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name) and target == player and target.shield > 0 and data.from
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.from
    room:changeShield(to, 1, {cancelable = false})
  end,
})


return huaibi