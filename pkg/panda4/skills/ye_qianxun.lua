local qianxun = fk.CreateSkill {
  name = "ye_qianxun",
  tags = {},
}

qianxun:addEffect("viewas", {
  anim_type = "control",
  pattern = "nullification,ex_nihilo",
  mute_card = false,
  prompt = "#pang_qianxun",
  card_filter = Util.FalseFunc,
  interaction = function(self, player)
    local names
    if player:getMark("@@wuxie-round") == 0 and player:getMark("@@wuzhong-round") == 0 then
      names = player:getViewAsCardNames(qianxun.name, {"nullification", "ex_nihilo"})
    elseif player:getMark("@@wuxie-round") > 0 and player:getMark("@@wuzhong-round") == 0 then
      names = player:getViewAsCardNames(qianxun.name, {"ex_nihilo"})
    elseif player:getMark("@@wuxie-round") == 0 and player:getMark("@@wuzhong-round") > 0 then
      names = player:getViewAsCardNames(qianxun.name, {"nullification"})
    end
    return UI.CardNameBox {choices = names, all_choices = {"nullification", "ex_nihilo"}}
  end,
  filter_pattern = function (self, player, card_name)
    local cards = player:getCardIds("h")
    return {
      max_num = #cards,
      min_num = #cards,
      pattern = ".|.|.|hand",
      subcards = cards
    }
  end,
  view_as = function(self, player, cards)
    if not self.interaction.data then return end
    local card = Fk:cloneCard(self.interaction.data)
    card.skillName = qianxun.name
    card:addSubcards(player:getCardIds("h"))
    return card
  end,
  before_use = function(self, player, use)
    if self.interaction.data == "nullification" then
      player.room:addPlayerMark(player, "@@wuxie-round")
    else
       player.room:addPlayerMark(player, "@@wuzhong-round")
    end
  end,
  enabled_at_play = function(self, player)
    return (player:getMark("@@wuxie-round") == 0 or player:getMark("@@wuzhong-round") == 0) and not player:isKongcheng()
  end,
  enabled_at_response = function(self, player)
    return (player:getMark("@@wuxie-round") == 0 or player:getMark("@@wuzhong-round") == 0) and not player:isKongcheng()
  end,
})


Fk:loadTranslationTable {["ye_qianxun"] = "谦逊",
[":ye_qianxun"] = "每轮各限一次，你可将所有手牌当【无懈可击】或【无中生有】使用。",
["#pang_qianxun"] = "谦逊：每轮各限一次，你可将所有手牌当【无懈可击】或【无中生有】使用。",
["@@wuxie-round"] = "无懈 已使用",
["@@wuzhong-round"] = "无中 已使用",


["$ye_qianxun1"] = "步步为营者，定无后顾之虞。",
["$ye_qianxun2"] = "明公彀中藏龙卧虎，放之海内皆可称贤。",
}
return qianxun