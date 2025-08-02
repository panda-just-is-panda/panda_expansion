local xueyi = fk.CreateSkill {
  name = "pang_xueyi",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_xueyi"] = "血裔",
  [":pang_xueyi"] = "主公技，游戏开始时，武将牌上没有主公技的角色依次可以交给你一张牌并从牌堆中获得一张【闪】。",
  ["#luanji-give"] = "你可以交给袁绍一张牌并获得一张【闪】",
}

xueyi:addEffect(fk.GameStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(xueyi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    for _, p in ipairs(Fk:currentRoom().alive_players) do
        local test = 0
        if #p:getSkillNameList() > 0 then
          for _, s in ipairs(Fk.generals[p.general]:getSkillNameList(true)) do
              if Fk.skills[s]:hasTag(Skill.Lord) then
                  test = 1
              end
          end
        end
        if test == 1 then
          local card_give
          card_give = room:askToCards(p, {
            min_num = 1,
            max_num = 1,
            include_equip = true,
            skill_name = xueyi.name,
            prompt = "#luanji-give",
            cancelable = true,
          })
          if #card_give > 0 then
            room:obtainCard(player, card_give, false, fk.ReasonGive)
            local jink = player.room:getCardsFromPileByRule("jink", 1)
            if #jink > 0 then
              player.room:obtainCard(p, jink[1], true, fk.ReasonJustMove, p, xueyi.name)
            end
          end
        end
    end
  end,
})


return xueyi