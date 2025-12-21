local bullet = fk.CreateSkill({
  name = "hua_sinner_bullet", 
  tags = {}, 
})

Fk:loadTranslationTable {["hua_sinner_bullet"] = "有罪之人的子弹",
[":hua_sinner_bullet"] = "这是一枚子弹。",
}

return bullet