local zhange = fk.CreateSkill {
  name = "peng_zhange",
  tags = {  },
}

Fk:loadTranslationTable{
  ["peng_zhange"] = "绽歌",
  [":peng_zhange"] = "每回合各限一次，你使用一张牌后，可以摸一张与之颜色不同的同类别牌。",
  ["#zhange_invoke"] = "绽歌：你可以摸一张颜色不同但类型和此牌相同的牌",
  ["@@zhange_trick_used-turn"] = "锦囊 已摸",
  ["@@zhange_basic_used-turn"] = "基本 已摸",
  ["@@zhange_equip_used-turn"] = "装备 已摸",

  ["$peng_zhange1"] = "优雅的歌声～",
  ["$peng_zhange2"] = "绽放的歌声～"
}

zhange:addEffect(fk.CardUseFinished, {
    anim_type = "drawcard",
    can_trigger = function(self, event, target, player, data)
        return target == player and player:hasSkill(zhange.name) and (data.extra_data or {}).can_zhange
    end,
    on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
        skill_name = zhange.name,
        prompt = "#zhange_invoke",
    }) then
        return true
    end
  end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local color = data.card.color
        local type = data.card.type
        local cards = {}
        if color == Card.Black and type == Card.TypeTrick then
            cards = player.room:getCardsFromPileByRule(".|.|heart,diamond|.|.|trick", 1)
        elseif color == Card.Red and type == Card.TypeTrick then
            cards = player.room:getCardsFromPileByRule(".|.|spade,club|.|.|trick", 1)
        elseif color == Card.Black and type == Card.TypeBasic then
            cards = player.room:getCardsFromPileByRule(".|.|heart,diamond|.|.|basic", 1)
        elseif color == Card.Red and type == Card.TypeBasic then
            cards = player.room:getCardsFromPileByRule(".|.|spade,club|.|.|basic", 1)
        elseif color == Card.Black and type == Card.TypeEquip then
            cards = player.room:getCardsFromPileByRule(".|.|heart,diamond|.|.|equip", 1)
        elseif color == Card.Red and type == Card.TypeEquip then
            cards = player.room:getCardsFromPileByRule(".|.|spade,club|.|.|equip", 1)
        elseif color ~= Card.Red and color ~= Card.Black and type == Card.TypeEquip then
            cards = player.room:getCardsFromPileByRule(".|.|.|.|.|equip", 1)
        elseif color ~= Card.Red and color ~= Card.Black and type == Card.TypeTrick then
            cards = player.room:getCardsFromPileByRule(".|.|.|.|.|trick", 1)
        elseif color ~= Card.Red and color ~= Card.Black and type == Card.TypeBasic then
            cards = player.room:getCardsFromPileByRule(".|.|.|.|.|basic", 1)
        end
        if #cards > 0 then
            room:obtainCard(player, cards, false, fk.ReasonJustMove, player, zhange.name)
        end
        if type == Card.TypeTrick then
            room:addPlayerMark(player, "@@zhange_trick_used-turn", 1)
        elseif type == Card.TypeBasic then
            room:addPlayerMark(player, "@@zhange_basic_used-turn", 1)
        else
            room:addPlayerMark(player, "@@zhange_equip_used-turn", 1)
        end
    end,
})

zhange:addEffect(fk.CardUseFinished, {
  can_refresh = function(self, event, target, player, data)
    if target == player and player:hasSkill(zhange.name, true) then
        if data.card.type == Card.TypeTrick and player:getMark("@@zhange_trick_used-turn") == 0 or
        data.card.type == Card.TypeEquip and player:getMark("@@zhange_equip_used-turn") == 0
        or data.card.type == Card.TypeBasic and player:getMark("@@zhange_basic_used-turn") == 0 then
            return true
        else
            return false
        end
    else
        return false
    end
  end,
  on_refresh = function(self, event, target, player, data)
      data.extra_data = data.extra_data or {}
      data.extra_data.can_zhange = true
  end,
})

return zhange