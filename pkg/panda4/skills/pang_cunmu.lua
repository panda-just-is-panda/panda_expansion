local cunmu = fk.CreateSkill {
  name = "cunmu",
  tags = {Skill.Compulsory},
}

Fk:loadTranslationTable{
  ["cunmu"] = "寸目",
  [":cunmu"] = "锁定技，当你摸牌时，改为从牌堆底摸牌。",

}

cunmu:addEffect(fk.BeforeDrawCard, {
  anim_type = "negative",
  on_use = function(self, event, target, player, data)
    data.fromPlace = "bottom"
  end,
})

return cunmu