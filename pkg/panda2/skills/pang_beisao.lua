local skel = fk.CreateSkill{
  name = "pang_beisao",
tags = { Skill.Compulsory },
}
--local U = require "packages/utility/utility"
Fk:loadTranslationTable{
  ["pang_beisao"] = "北扫",
  [":pang_beisao"] = "锁定技，当你造成或受到伤害时，若受伤角色有牌，你防止此伤害并弃置其两张牌；否则，此伤害+1。",
  ["#pang_beisao-discard"] = "北扫：你需要依次弃置 %src 两张牌（现在是第 %arg 张）",
}
---@type TrigSkelSpec<DamageTrigFunc>
local bingxin = {
  anim_type = "defensive",
  can_trigger = function (self, event, target, player, data)
    return player == target and player:hasSkill(skel.name) and data.to
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    local to = data.to
    room:doIndicate(player, { to })
    if to:isNude() then
        data:changeDamage(1)
    else
        data:preventDamage()
        for i = 1, 2 do
        if not player.dead and not to.dead and not to:isNude() then
            if player == to then
                local cid = room:askToDiscard(player, {
                min_num = 1,
                max_num = 1,
                cancelable = false,
                skill_name = skel.name,
                prompt = "#tea__bingxin-discard:" .. to.id .. "::" .. i,
                include_equip = true
                })
            else
                local cid = room:askToChooseCard(player, {
                target = to,
                skill_name = skel.name,
                flag = "he",
                prompt = "#tea__bingxin-discard:" .. to.id .. "::" .. i,
                })
                if cid then
                    room:throwCard(cid, skel.name, to, player)
                end
            end
        end
        end
    end
  end
}
skel:addEffect(fk.DamageCaused, bingxin)
skel:addEffect(fk.DamageInflicted, bingxin)
return skel