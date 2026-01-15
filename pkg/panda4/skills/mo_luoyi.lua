local luoyi = fk.CreateSkill({
  name = "mo_luoyi", 
  tags = {}, 
})

luoyi:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#mo_luoyi",
  max_phase_use_time = 1,
  target_num = 0,
  card_num = 0,
  card_filter = Util.FalseFunc,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    if #player:getCardIds("h") > 0 then
        player:showCards(player:getCardIds("h"))
        room:delay(200)
        local cards = table.filter(player:getCardIds("h"), function(id)
            local card = Fk:getCardById(id)
            return card and card.type == Card.TypeBasic
        end)
        if #cards > 0 then
            room:recastCard(cards, player, luoyi.name)
        end
    end
    room:askToUseVirtualCard(player, {
            name = "duel", skill_name = luoyi.name, cancelable = false, skip = false,
    })
end,
})





Fk:loadTranslationTable {["mo_luoyi"] = "裸衣",
[":mo_luoyi"] = "出牌阶段限一次，你可以展示所有手牌，重铸其中所有的基本牌，然后视为使用【决斗】。",
["#mo_luoyi"] = "裸衣：你可以展示手牌并重铸所有基本牌，然后视为使用【决斗】",

  ["$mo_luoyi1"] = "过来打一架，对，就是你！",
  ["$mo_luoyi2"] = "废话少说，放马过来吧！",

}
return luoyi