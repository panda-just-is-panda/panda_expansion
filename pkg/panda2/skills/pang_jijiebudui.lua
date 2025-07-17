local jijie = fk.CreateSkill {
  name = "pang_jijiebudui",
}


jijie:addEffect("viewas", {
    mute_card = false,
    mute = true,
    pattern = "slash,jink",
    prompt = "#pang_jijiebudui",
    interaction = function(self, player)
    local names = player.getViewAsCardNames(player, self.name, { "slash", "jink" })
    if #names > 0 then
      return UI.CardNameBox { choices = names }
    end
    end,
    card_filter = Util.FalseFunc,
    view_as = function(self, player, cards)
        if not self.interaction.data then return nil end
        local card = Fk:cloneCard(self.interaction.data)
        card.skillName = jijie.name
        card:addSubcards(player:getCardIds("h"))
        return card
    end,
    enabled_at_play = function(self, player)
        return player:usedSkillTimes(jijie.name, Player.HistoryTurn) == 0 and not player:isKongcheng()
    end,
    enabled_at_response = function(self, player, response)
        return player:usedSkillTimes(jijie.name, Player.HistoryTurn) == 0 and not player:isKongcheng()
    end,
    after_use = function(self, player, use)
    local choices = {"draw_tomax", "Cancel"}
    player:broadcastSkillInvoke(jijie.name, 1)
    local choice = player.room:askToChoice(player, {
      choices = choices,
      skill_name = jijie.name,
    })
    if choice ~= "Cancel" then
      player.room:addPlayerMark(player, "jijieing-turn", 1)
      if not player.dead and use.card then
        local num = player.maxHp - #player:getCardIds("h")
        if num > 0 then
          player:drawCards(num, jijie.name)
        end
      end
    end
  end,
})

jijie:addEffect(fk.DamageInflicted, {
    mute = true,
    anim_type = "negative",
    can_refresh = function (self, event, target, player, data)
        return player:hasSkill(jijie.name) and player == target and player:getMark("jijieing-turn") > 0
    end,
    on_refresh = function (self, event, target, player, data)
        player:broadcastSkillInvoke(jijie.name, 2)
        player.room:setPlayerMark(player, "jijieing-turn", 0)
        if #player:getCardIds("h") > 0 then
          player.room:throwCard(player:getCardIds("h"), jijie.name, player, player)
        end
    end,
})

jijie:addEffect(fk.AfterCardsMove, {
  mute = true,
  anim_type = "negative",
  can_refresh = function(self, event, target, player, data)
    local yes = false
    if player:hasSkill(jijie.name) and player:getMark("jijieing-turn") > 0 then
      for _, move in ipairs(data) do
        if move.from == player then
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerHand then
                yes = true
              break
            end
          end
        end
      end
    end
    if yes then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
        player:broadcastSkillInvoke(jijie.name, 2)
        player.room:setPlayerMark(player, "jijieing-turn", 0)
        if #player:getCardIds("h") > 0 then
          player.room:throwCard(player:getCardIds("h"), jijie.name, player, player)
        end
    end,
})

Fk:loadTranslationTable{
  ["pang_jijiebudui"] = "集结部队",
  [":pang_jijiebudui"] = "每回合限一次，你可以将所有手牌作为【杀】或【闪】使用或打出；若如此做，你可以将手牌摸至体力上限，然后你本回合下次失去手牌或受到伤害时弃置所有手牌。",
  ["draw_tomax"] = "将手牌摸至体力上限",
  ["#pang_jijiebudui"] = "集结部队：将所有手牌作为【杀】或【闪】使用或打出",

  ["$pang_jijiebudui1"] = "敌人扑过来了，圣堂武士，亮出光刃！",
  ["$pang_jijiebudui2"] = "我得重新集结部队。",

}

return jijie