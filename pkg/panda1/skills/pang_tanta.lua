local skill = fk.CreateSkill({
  name = "pang_tanta", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

skill:addEffect("viewas", {
  anim_type = "offensive",
  mute_card = true,
  pattern = "slash",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).color == Card.Red
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local c = Fk:cloneCard("slash")
    c.skillName = skill.name
    c:addSubcard(cards[1])
    return c
  end,
})


Fk:loadTranslationTable{
  ["pang_tanta"] = "坦踏",
  [":pang_tanta"] = "你可以将三张牌作为无次数限制的【杀】使用，然后若其中不包含装备牌，你获得1点护甲且此技能本回合失效。",

  ["#pang_tanta"] = "坦踏：你可将三张牌作为无次数限制【杀】使用；若没有装备牌则你获得护甲且此技能本回合失效",

}