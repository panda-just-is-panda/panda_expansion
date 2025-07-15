local shengji = fk.CreateSkill {
  name = "pang_shengji",
  tags = {},
}

Fk:loadTranslationTable {["pang_shengji"] = "生祭",
[":pang_shengji"] = "结束阶段，你可以将手牌摸至X张（X为所有角色已损失的体力值之和），然后若你的手牌数大于五，你将手牌弃置至五张并视为一张使用【南蛮入侵】；当你因此造成伤害时，你回复1点体力。",
}

return shengji