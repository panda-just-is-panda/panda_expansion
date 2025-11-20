local zhiheng = fk.CreateSkill{
  name = "mo_chengheng",
}

zhiheng:addEffect('active', {
  anim_type = "drawcard",
  can_use = function(self, player)
    return player:usedSkillTimes(zhiheng.name, Player.HistoryPhase) < 2
  end,
  card_num = 0,
  target_num = 1,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select:getHandcardNum() ~= player:getMark("@mo_chengheng")
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local to = effect.tos[1]
    local X = player:getMark("@mo_chengheng")
    if X > to:getHandcardNum() then
      to:drawCards(1, zhiheng.name)
      room:addPlayerMark(player, "@mo_chengheng_mo", 1)
    elseif X < to:getHandcardNum() then
      room:askToDiscard(to, {
          skill_name = zhiheng.name,
          cancelable = false,
          min_num = 1,
          max_num = 1,
          include_equip = false,
        })
      room:addPlayerMark(player, "@mo_chengheng_qi", 1)
    end
    if player:getMark("@mo_chengheng_mo") == player:getMark("@mo_chengheng_qi") then
      player:setSkillUseHistory(zhiheng.name, 0, Player.HistoryPhase)
      local choices = {"x+1", "x-1"}
      local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = zhiheng.name,
      })
      if choice == "x+1" then
        room:addPlayerMark(player, "@mo_chengheng", 1)
      else
        room:removePlayerMark(player, "@mo_chengheng", 1)
      end
    end
  end
})

zhiheng:addAcquireEffect(function (self, player)
  local room = player.room
  room:setPlayerMark(player, "@mo_chengheng", 3)
end)


Fk:loadTranslationTable{
  ["mo_chengheng"] = "秤衡",
  [":mo_chengheng"] = "出牌阶段限两次，你可以令一名与你体力或手牌数相同的角色，手牌向X调整1（×为3）。然后若因此弃置与摸牌数相同，则此技能视为未发动过并令X±1。",
  ["@mo_chengheng"] = "秤衡",
  ["@mo_chengheng_mo"] = "秤衡 摸",
  ["@mo_chengheng_qi"] = "秤衡 弃",
  ["x+1"] = "令x+1",
  ["x-1"] = "令x-1",


}

return zhiheng