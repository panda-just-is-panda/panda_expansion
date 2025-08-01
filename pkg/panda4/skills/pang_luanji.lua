local luanji = fk.CreateSkill{
  name = "pang_luanji",
}

luanji:addEffect("viewas", {
    anim_type = "offensive",
    pattern = "archery_attack",
    prompt = "#luanji",
    handly_pile = true,
    card_filter = function(self, player, to_select, selected)
        return #selected == 0
    end,
    view_as = function(self, player, cards)
        if #cards ~= 1 then
            return nil
        end
        local c = Fk:cloneCard("archery_attack")
        c.skillName = luanji.name
        c:addSubcards(cards)
        return c
    end,
  enabled_at_play = function(self, player)
        return player:usedSkillTimes(luanji.name, Player.HistoryTurn) == 0
    end,
})
luanji:addEffect(fk.CardUseFinished, {
    anim_type = "control",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(luanji.name) and data.card and table.contains(data.card.skillNames, luanji.name)
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local card = data.card
    local suit = Fk:getCardById(card):getSuitString()
    local discard = room:askToDiscard(player, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            pattern = ".|.|"..suit,
            skill_name = luanji.name,
            prompt = "#luanji-discard:"..suit,
            })
            if #discard > 0 then
                room:throwCard(discard, luanji.name, player, player)
                local choices = {"luanji_jin", "luanji_tui"}
                local choice = room:askToChoice(player, {
                    choices = choices,
                    skill_name = luanji.name,
                })
                if choice == "luanji_jin" then
                    player:setSkillUseHistory(luanji.name, 0, Player.HistoryTurn)
                else
                    player:drawCards(2, luanji.name)
                end
            end
  end,
})


Fk:loadTranslationTable{
  ["pang_luanji"] = "乱击",
  [":pang_luanji"] = "每回合限一次，你可以将一张手牌当【万箭齐发】使用；此牌结算结束后，你可以弃置一张和此牌花色相同的牌并选择一项：此技能本回合视为未发动过；摸两张牌。",

  ["#luanji"] = "你可以将一张手牌作为【万箭齐发】使用",
  ["luanji_jin"] = "令“乱击”视为本回合未发动过",
  ["luanji_tui"] = "摸两张牌",
  ["#luanji-discard"] = "你可以弃置一张%arg牌并选择一项",

  ["$pang_luanji1"] = "弓箭手，准备放箭！",
  ["$pang_luanji2"] = "全都去死吧！",
}

return luanji