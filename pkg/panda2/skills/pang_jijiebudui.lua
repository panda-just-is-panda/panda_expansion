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
    after_use = function(self, player, use)
    player:broadcastSkillInvoke(jijie.name, 1)
    player.room:addPlayerMark(player, "jijieing-turn", 1)
    if not player.dead and use.card then
    local num = player.maxHp - #player:getCardIds("h")
    if num > 0 then
        player:drawCards(num, jijie.name)
    end
    end
  end,
})

jijie:addEffect(fk.DamageInflicted, {
    mute = true,
    anim_type = "negative",
    can_refresh = function (self, event, target, player, data)
        return player:hasSkill(jijie.name) and player == target and #player:getCardIds("h") > 0 and player:getMark("jijieing-turn") > 0
    end,
    on_refresh = function (self, event, target, player, data)
        player:broadcastSkillInvoke(jijie.name, 2)
        player.room:setPlayerMark(player, "jijieing-turn", 0)
        player.room:throwCard(player:getCardIds("h"), jijie.name, player, player)
    end,
})

Fk:loadTranslationTable{
  ["pang_jijiebudui"] = "集结部队",
  [":pang_jijiebudui"] = "每回合限一次，你可以将所有手牌作为【杀】或【闪】使用或打出，然后你将手牌摸至体力上限；若如此做，你本回合下次受到伤害时弃置所有手牌。",

  ["#pang_jijiebudui"] = "集结部队：将所有手牌作为【杀】或【闪】使用或打出",

}

return jijie