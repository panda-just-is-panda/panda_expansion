local shengji = fk.CreateSkill {
  name = "pang_shengji",
  tags = {},
}

shengji:addEffect(fk.EventPhaseStart, {
  mute = true,
anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(shengji.name) and target.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local num = 0
    player:broadcastSkillInvoke(shengji.name, 1)
    for _, p in ipairs(room:getAlivePlayers()) do
        if not p.dead then
          num = num + p:getLostHp()
        end
        end
    if num > #player:getCardIds("h") then
    local to_draw = num - #player:getCardIds("h")
    player:drawCards(to_draw, shengji.name)
    if #player:getCardIds("h") > 5 then
      local to_discard = #player:getCardIds("h") - 5
      local card_discard = room:askToDiscard(player, {
            skill_name = shengji.name,
            prompt = "#shengji_discard",
            cancelable = false,
            min_num = to_discard,
            max_num = to_discard,
            include_equip = false,
            })
      local savage_assault = Fk:cloneCard("savage_assault")
      local tos = table.filter(room:getOtherPlayers(player, false), function (p)
      return player:canUseTo(savage_assault, p)
      end)
      local targets = tos
      room:sortByAction(targets)
      room:useVirtualCard("savage_assault", nil, player, targets, shengji.name, true)
    end
    end
  end,
})
shengji:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, shengji.name)
  end,
  on_refresh = function(self, event, target, player, data)
      player.room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = shengji.name
      })
      if player:getMark("shengji_audio-phase") == 0 then
        player:broadcastSkillInvoke(shengji.name, 2)
        player.room:setPlayerMark(player, "shengji_audio-phase", 1)
      end
  end,
})

Fk:loadTranslationTable {["pang_shengji"] = "生祭",
[":pang_shengji"] = "结束阶段，你可以将手牌摸至X张（X为所有角色已损失的体力值之和），然后若你的手牌数大于五，你将手牌弃置至五张并视为一张使用【南蛮入侵】；当你因此造成伤害后，你回复1点体力。",
["#shengji_discard"] = "将手牌弃置至5张",


["$pang_shengji1"] = "Enter the gate and see the light.",
["$pang_shengji2"] = "Once shattered, now remade.",
}

return shengji