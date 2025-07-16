
local ganglie = fk.CreateSkill{
  name = "pang_ganglieex",
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
      pattern = ".|.|^nosuit",
    }
    room:judge(judge)
    if not data.from or data.from.dead then return false end
    if judge.card.color == Card.Red then
      room:drawCards(player, 10, ganglie.name)
    elseif judge.card.color == Card.Black and not player.dead then
        local tos = table.filter(room:getOtherPlayers(player, false), function (p)
        return not p:isNude()
        end)
        local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = tos,
        skill_name = ganglie.name,
        prompt = "#dunnu!",
        })
        if #to > 0 then
            for _, p in ipairs(to) do
            local cid = room:askToChooseCards(player, {
            target = p,
            min = 1,
            max = 10,
            flag = "he",
            skill_name = ganglie.name,
            prompt = "#dunnu!",
            })
            room:throwCard(cid, ganglie.name, data.from, player)
            end
        end
    end
  end
})

Fk:loadTranslationTable{
  ["pang_ganglieex"] = "刚烈",
  [":pang_ganglieex"] = "当你受到1点伤害后，你可以进行一次判定，然后若判定结果为：红色，你摸10张牌；黑色，你弃置一名其他角色至多10张牌。",
  ["#dunnu!"] = "惇怒！",

  ["$pang_ganglieex1"] = "哪个敢动我！",
  ["$pang_ganglieex2"] = "伤我者，十倍奉还！",
}

return ganglie