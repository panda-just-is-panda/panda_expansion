local bullet = fk.CreateSkill({
  name = "hua_gun_bullet", 
  tags = {}, 
})

Fk:loadTranslationTable {["hua_gun_bullet"] = "持枪之人的子弹",
[":hua_gun_bullet"] = "这是一枚子弹。",
}

return bullet