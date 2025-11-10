local fuxin = fk.CreateSkill {
  name = "pang_fuxin",
  tags = {Skill.Switch},
}

Fk:loadTranslationTable{
  ["pang_fuxin"] = "复信",
  [":pang_fuxin"] = "转换技，①你可以交给一名其他角色一张牌并视为使用或打出【闪】。②当你获得牌后，你可以视为使用一张【过河拆桥】。",

  [":pang_fuxin_yang"] = "转换技，<font color=\"#E0DB2F\">①你可以交给一名其他角色一张牌并视为使用或打出【闪】。</font>②当你获得牌后，你可以视为使用一张【过河拆桥】。",
  [":pang_fuxin_yin"] = "转换技，①你可以交给一名其他角色一张牌并视为使用或打出【闪】。<font color=\"#E0DB2F\">②当你获得牌后，你可以视为使用一张【过河拆桥】。</font>",

  ["#fuxin_jink"] = "复信：你可以交给一名其他角色一张牌并视为使用或打出【闪】",
  ["#fuxin-give"] = "复信：交给一名其他角色一张牌",
  ["#fuxin-invoke"] = "复信：你可以视为使用一张【过河拆桥】",
  ["#fuxin_chai"] = "复信：视为使用一张【过河拆桥】",

}

fuxin:addEffect("viewas", {
    mute_card = false,
  anim_type = "support",
  prompt = "#fuxin_jink",
  pattern = "jink",
  card_filter = Util.FalseFunc,
  before_use = function(self, player)
    local room = player.room
    local to, card = room:askToChooseCardsAndPlayers(player, {
      targets = room:getOtherPlayers(player, false),
      min_num = 1,
      max_num = 1,
      max_card_num = 1,
      min_card_num = 1,
      prompt = "#fuxin-give",
      skill_name = fuxin.name,
      cancelable = false})
      room:obtainCard(to, card, false, fk.ReasonGive)
  end,
  view_as = function(self, player)
    local c = Fk:cloneCard("jink")
    c.skillName = fuxin.name
    return c
  end,
  enabled_at_play = function (self, player)
    return player:getSwitchSkillState(fuxin.name, true) ~= fk.SwitchYang and not player:isNude()
    end,
  enabled_at_response = function (self, player, response)
    return player:getSwitchSkillState(fuxin.name, true) ~= fk.SwitchYang and not player:isNude()
  end,
})

fuxin:addEffect(fk.AfterCardsMove, {
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(fuxin.name, true) or player:getSwitchSkillState(fuxin.name, true) ~= fk.SwitchYang then return false end
    local room = player.room
    for _, move in ipairs(data) do
      if move.to == player and move.toArea == Player.Hand then
        for _, info in ipairs(move.moveInfo) do
          if table.contains(player:getCardIds("h"), info.cardId) then
            return true
          end
        end
      end
    end
  end,
   on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = fuxin.name,
      prompt = "#fuxin-invoke::"..player.id,
    }) then
      event:setCostData(self, {tos = {data.from}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function (p)
        return player:canUseTo(Fk:cloneCard("dismantlement"), p)
        end)
    if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
            min_num = 1,
            max_num = 1,
            targets = targets,
            skill_name = fuxin.name,
            prompt = "#fuxin_chai",
            cancelable = false,
        })
        if #tos > 0 then
            local targets = tos
            room:sortByAction(targets)
            room:useVirtualCard("dismantlement", nil, player, targets, fuxin.name, true)
        end
    end
  end,
})



return fuxin