
local ganglie = fk.CreateSkill{
  name = "pang_ganglie",
}

ganglie:addEffect(fk.Damaged, {
  anim_type = "masochism",
   can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ganglie.name)
   end,
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
        skill_name = ganglie.name,
      }) then
        return true
      end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local judge = {
      who = player,
      reason = ganglie.name,
      pattern = ".|.|spade,club,diamond",
    }
    room:judge(judge)
    if not data.from or data.from.dead then return false end
    if judge.card.suit ~= Card.Heart then
      room:drawCards(player, 20, ganglie.name)
    end
  end
})

Fk:loadTranslationTable{
  ["pang_ganglie"] = "缸裂",
  [":pang_ganglie"] = "当你受到1点伤害后，你可以进行一次判定，若判定结果不为红桃，你摸20张牌。",

  ["$pang_ganglie1"] = "哪个敢动我！",
  ["$pang_ganglie2"] = "伤我者，十倍奉还！",
}

return ganglie