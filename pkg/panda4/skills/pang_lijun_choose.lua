local lijunChoose = fk.CreateSkill({
  name = "pang_lijun_choose",
})

Fk:loadTranslationTable{
  ["pang_lijun_choose"] = "立军",
}

lijunChoose:addEffect("active", {
  card_num = 0,
  target_num = 1,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    if #selected > 0 then return false end
    if #selected == 0 then
      local bro = to_select
      return bro.kingdom == "wu"
    end
  end,
})

return lijunChoose