local eying = fk.CreateSkill({
  name = "pang_eying", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

eying:addEffect("active", {
  anim_type = "control",
  prompt = "#eying",
  card_num = 0,
  min_target_num = 1,
  max_target_num = 2,
  can_use = function(self, player)
    return player:usedSkillTimes(eying.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return not to_select:isNude() and to_select.shield < 1
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local tos = table.simpleClone(effect.tos)
      if #tos > 0 then
        room:sortByAction(tos)
        for _, p in ipairs(tos) do
        room:changeShield(p, 1, {cancelable = false})
          if not p.dead then
            local use = room:askToUseCard(p, {
      skill_name = eying.name,
      pattern = "slash",
      prompt = "#eying_choose",
      extra_data = {
        bypass_times = true,
      }
    })
    if use then
      use.extraUse = true
      room:useCard(use)
    else
        local card = room:askToDiscard(p, {
          skill_name = eying.name,
          prompt = "#eying_discard",
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = true,
        })
        end
        end
        end
    end
end
})


Fk:loadTranslationTable {["pang_eying"] = "厄影",
[":pang_eying"] = "出牌阶段限一次，你可以令至多两名有手牌且没有护甲的角色各获得1点护甲并选择一项：弃置一张手牌；使用一张【杀】。",
["#eying_choose"] = "使用一张【杀】，或点取消然后弃置一张牌",
["#eying"] = "令至多两名角色获得护甲或用杀",
["#eying_discard"] = "弃置一张牌",
}
return eying