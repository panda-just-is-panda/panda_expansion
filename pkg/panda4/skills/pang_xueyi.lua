local xueyi = fk.CreateSkill {
  name = "pang_xueyi",
  tags = { Skill.Lord, Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["pang_xueyi"] = "血裔",
  [":pang_xueyi"] = "主公技，锁定技，你的手牌上限+X（X为武将牌上没有主公技的角色数）。",
}

xueyi:addEffect("maxcards", {
  correct_func = function(self, player)
    if player:hasSkill(xueyi.name) then
      local n = #Fk:currentRoom().alive_players
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
            n = n - 1
        end
      end
      return n
    end
  end,
})

return xueyi