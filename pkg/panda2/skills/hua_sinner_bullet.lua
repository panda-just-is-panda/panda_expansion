local bullet = fk.CreateSkill({
  name = "hua_sinner_bullet", 
  tags = {}, 
})

Fk:loadTranslationTable {["hua_sinner_bullet"] = "罪者之弹",
[":hua_sinner_bullet"] = "这是一枚子弹。",
}

return bullet