local paixing = fk.CreateSkill{
  name = "pang_paixing",
}

paixing:addAcquireEffect(function (self, player, is_start)
  local room = player.room
  if not player:hasSkill("pang_duizi") then
    room:handleAddLoseSkills(player, "pang_duizi", nil, true, false)
  end
  if not player:hasSkill("pang_feiji") then
    room:handleAddLoseSkills(player, "pang_feiji", nil, true, false)
  end
  if not player:hasSkill("pang_zhadan") then
    room:handleAddLoseSkills(player, "pang_zhadan", nil, true, false)
  end
end)



Fk:loadTranslationTable {["pang_paixing"] = "牌型",
[":pang_paixing"] = "你可以将两/三/四张点数相同的牌作为【过河拆桥】/【无中生有】/【无懈可击】使用。",
}

return paixing