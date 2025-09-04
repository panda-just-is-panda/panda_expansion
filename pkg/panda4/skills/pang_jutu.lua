local jutu = fk.CreateSkill {
  name = "pang_jutu",
}

Fk:loadTranslationTable{
  ["pang_jutu"] = "据土",
  [":pang_jutu"] = "摸牌阶段结束时，你可以将手牌摸至五张；若你未因此摸牌，你可于下个阶段结束时如此做。",

  ["#jutu-ask"] = "据土：你可以将手牌摸至五张",
  ["@@jutu"] = "可继续据土",

  ["$pang_jutu1"] = "百姓安乐足矣，穷兵黩武实不可取啊。",
  ["$pang_jutu2"] = "内乱初定，更应休养生息。",
}



jutu:addEffect(fk.EventPhaseEnd, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jutu.name) and (player.phase == Player.Draw or player:getMark("@@jutu") > 0)
  end,
  on_cost = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@jutu", 0)
    if player.room:askToSkillInvoke(player, {
        skill_name = jutu.name,
        prompt = "#jutu-ask",
      }) then
        return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local X = 5 - player:getHandcardNum()
    if X > 0 then
        player:drawCards(X, jutu.name)
    else
        room:addPlayerMark(player, "@@jutu")
    end
  end,
})

return jutu