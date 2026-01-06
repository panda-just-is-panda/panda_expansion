local skel = fk.CreateSkill {
  name = "mo_jianxiong_card_skill",
}

skel:addEffect("cardskill", {
  mute = true,
  mod_target_filter = Util.TrueFunc,
  target_filter = Util.CardTargetFilter,
  target_num = 1,
  on_effect = function(self, room, effect)
    local from = effect.from
    local to = effect.to
    if not to.dead then
      local skillName = skel.name
      if effect.card and Fk:cloneCard(effect.card.name).is_damage_card then
        skillName = Fk:cloneCard(effect.card.name).skill.name
      end
      room:damage({
        from = from,
        to = to,
        card = effect.card,
        damage = 1,
        skillName = skillName,
      })
      if not to.dead then
        local choices = { "draw_one" }
        if not table.contains(to:getTableMark("mojianxiong-round"), effect.card.trueName) then
            table.insert(choices, 2, "#mo_jianxiong-na")
        end
        local choice = room:askToChoice(to, {
            choices = choices,
            skill_name = skel.name,
        })
        if choice == "draw_one" then
            to:drawCards(1, skel.name)
        else
            local get = room:getSubcardsByRule(effect.card, {Card.Processing})
            room:obtainCard(to, get, true, fk.ReasonJustMove, to, skel.name)
            for _, p in ipairs(Fk:currentRoom().alive_players) do
                room:addTableMark(p, "mojianxiong-round", effect.card.trueName)
            end
        end
      end
    end
  end,
})

Fk:loadTranslationTable{
  ["mo_jianxiong_card_skill"] = "奸雄",
  ["draw_one"] = "摸一张牌",
  ["#mo_jianxiong-na"] = "获得造成伤害的牌"

}

return skel