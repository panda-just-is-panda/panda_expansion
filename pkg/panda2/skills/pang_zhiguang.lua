local zhiguang = fk.CreateSkill {
  name = "pang_zhiguang",
  tags = {},
}

zhiguang:addEffect("active", {
  anim_type = "support",
  card_num = 0,
  target_num = 0,
  prompt = "#pang_zhiguang",
  can_use = function(self, player)
    return player:usedSkillTimes(zhiguang.name, Player.HistoryPhase) == 0
  end,
  on_use = function(self, room, effect)
    local from = effect.from
    if not from.dead then
      room:loseHp(from, 1, zhiguang.name)
      if not from.dead then
      local choices = {"zhiguang_kutong", "zhiguang_bihu"}
      local choice = room:askToChoice(from, {
      choices = choices,
      skill_name = zhiguang.name,
      })
      if choice == "zhiguang_kutong" then
        for _, p in ipairs(room:getAlivePlayers()) do
        if not p.dead then
          room:loseHp(p, 1, zhiguang.name)
        end
        end
      else
        local tos = room:askToChoosePlayers(from, {
        min_num = 1,
        max_num = 2,
        targets = room:getAlivePlayers(),
        skill_name = zhiguang.name,
        prompt = "#zhiguang_hujia",
        cancelable = false,
        })
        if #tos > 0 then
          for _, p in ipairs(tos) do
        room:changeShield(p, 1, {cancelable = false})
          end
        end
      end
      end
    end
  end,
})

Fk:loadTranslationTable {["pang_zhiguang"] = "织光",
[":pang_zhiguang"] = "出牌阶段限一次，你可以失去1点体力并选择一项：令所有角色各失去1点体力；令至多两名角色各获得1点护甲。",
["#pang_zhiguang"] = "你可以失去体力并赐予苦痛或庇护",
["zhiguang_kutong"] = "令所有角色各失去1点体力",
["zhiguang_bihu"] = "令至多两名角色各获得1点护甲",
["#zhiguang_hujia"] = "令至多两名角色各获得1点护甲",
}

return zhiguang