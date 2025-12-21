local survival = fk.CreateSkill({
  name = "hua_for_survival", 
  tags = {}, 
})

Fk:loadTranslationTable {["hua_for_survival"] = "以生存之名",
[":hua_for_survival"] = "你可以失去“有罪之人的子弹”或“持枪之人的子弹”，视为使用一张无距离限制的【杀】，当因此造成伤害后，摸三张牌。结束阶段，若你没有“有罪之人的子弹”，你失去1点体力，获得之。",
["#for_survival"] = "你可以失去一个“子弹”，视为使用一张无距离限制的【杀】",
}

survival:addEffect("viewas", {
    anim_type = "offensive",
    mute_card = false,
    pattern = "slash",
    prompt = "#for_survival",
    interaction = function(self, player)
    local skills = player:getSkillNameList()
    local choices = {}
    skills = table.filter(skills, function(skill) 
        return skill == "hua_gun_bullet" or skill == "hua_sinner_bullet"
         end)
    if #skills > 0 then
      table.insertTable(choices, skills)
    end
    return UI.ComboBox { choices = choices }
  end,
    card_filter = function ()
      return false
    end,
    before_use = function(self, player, use)
      local room = player.room
        room:handleAddLoseSkills(player,"-"..self.interaction.data,nil, true, false)
    end,
    view_as = function(self,player, cards)
      local card = Fk:cloneCard("slash")
      card.skillName = survival.name
      return card
    end,
    enabled_at_play = function(self, player)
        return player:hasSkill("hua_gun_bullet") or player:hasSkill("hua_sinner_bullet")
    end,
    enabled_at_response = function(self, player, response)
        return not response and (player:hasSkill("hua_gun_bullet") or player:hasSkill("hua_sinner_bullet"))
    end,
})

survival:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, survival.name)
  end,
  on_refresh = function(self, event, target, player, data)
      player:drawCards(3, survival.name)
  end,
})

survival:addEffect("targetmod", {
  bypass_distances = function (self, player, skill, card)
    return player:hasSkill(survival.name) and card and table.contains(card.skillNames, survival.name)
  end
})

survival:addEffect(fk.EventPhaseStart, { --
  anim_type = "drawcard", 
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(survival.name) and
      player.phase == Player.Finish and not player:hasSkill("hua_sinner_bullet")
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:loseHp(player, 1, survival.name)
    room:handleAddLoseSkills(player,"hua_sinner_bullet",nil, true, false)
  end,
})

return survival