local swj = fk.CreateSkill {
  name = "pang_siweijiang",
  tags = { },
}

Fk:loadTranslationTable{
  ["pang_siweijiang"] = "丝为缰",
  [":pang_siweijiang"] = "当点数为4的牌进入弃牌堆时，你获得之；每回合开始时，你可以将一张点数为4的牌置于牌堆顶；当其他角色失去点数为4的牌时，你可以获得其两张牌。",
}

return swj