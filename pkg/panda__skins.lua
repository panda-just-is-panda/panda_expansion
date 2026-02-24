local extension = Package:new("panda__skins", Package.SkinPack)
extension.extensionName = "panda"

local content1 = {
  {
  skins={"pang__ocean_steve.jpg"}, 
  enabled_generals = {"pang__steve"},
  },
  {
  skins={"pang__horse_steve.jpg"}, 
  enabled_generals = {"pang__steve"},
  },
  {
  skins={"pang__classical_steve.jpg"}, 
  enabled_generals = {"pang__steve"},
  },
  {
  skins={"pang__zhangxiu_vindicator.jpg"}, 
  enabled_generals = {"pang__vindicator"},
  },
  {
  skins={"pang__girl_vindicator.jpg"}, 
  enabled_generals = {"pang__vindicator"},
  },
  {
  skins={"pang__pillager_patrol.jpg"}, 
  enabled_generals = {"pang__re_pillager"},
  },
  {
  skins={"pang__lovezoglin.jpg"}, 
  enabled_generals = {"pang__zoglin"},
  },
  {
  skins={"pang__wither_skeleton_thewall.jpg"}, 
  enabled_generals = {"pang__wither_skeleton"},
  },


  {
  skins={"pang__classicpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__speechlesspanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__flowerpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__tangpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__moviepanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__confusedpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__darknesspanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__sadpang.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__missonepanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__sadpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__jilepanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__zayupanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__yokapanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__dresspanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },

  {
  skins={"pang__starcraft1_mengsk.jpg"}, 
  enabled_generals = {"pang__mengsk"},
  },
  {
  skins={"pang__finaljudge.jpg"}, 
  enabled_generals = {"pang__last_judge"},
  },
  {
  skins={"pang__bolinyidong_stockings.jpg"}, 
  enabled_generals = {"pang__bolinyidong"},
  },
  {
  skins={"pang__21+1_meilanni.jpg"}, 
  enabled_generals = {"pang__meilanni"},
  },
  {
  skins={"pang__luxi_queen.jpg"}, 
  enabled_generals = {"pang__luxi", "pang__laoluxi"},
  },
  {
  skins={"pang__groal_the_girl.jpg"}, 
  enabled_generals = {"pang__groal_the_great"},
  },
  {
  skins={"pang__girl_beastfly.jpg"}, 
  enabled_generals = {"pang__savage_beastfly"},
  },
}
extension:addSkinPackage {
  path = "/image/skins",
  content = content1
}
Fk:loadTranslationTable{
  ["pang__classicpanda"] = "胖胖",
  ["pang__speechlesspanda"] = "胖无语",
  ["pang__flowerpanda"] = "胖送花",
  ["pang__tangpanda"] = "唐胖",
  ["pang__confusedpanda"] = "胖受震撼",
  ["pang__darknesspanda"] = "胖将黑化",
  ["pang__sadpang"] = "委屈胖",
  ["pang__missonepanda"] = "缺一！！！",
  ["pang__moviepanda"] = "大电影",
  ["pang__sadpanda"] = "胖悲",
  ["pang__jilepanda"] = "你已急哭",
  ["pang__zayupanda"] = "杂鱼捏",
  ["pang__yokapanda"] = "卢弈胖",
  ["pang__dresspanda"] = "女装胖",
  ["pang__starcraft1_mengsk"] = "一代",
  ["pang__finaljudge"] = "终门审判",
  ["pang__21+1_meilanni"] = "玫瑰的诡计",
  ["pang__bolinyidong_stockings"] = "铅红的真相",
  ["pang__luxi_queen"] = "",
  ["pang__groal_the_girl"] = "可爱捏",
  ["pang__girl_beastfly"] = "可爱捏",
  ["pang__zhangxiu_vindicator"] = "林地斧王",
  ["pang__girl_vindicator"] = "娘化",
  ["pang__horse_steve"] = "骑马与砍杀",
  ["pang__classical_steve"] = "钻石相伴",
  ["pang__ocean_steve"] = "深海探险",
  ["pang__pillager_patrol"] = "拟人",
  ["pang__lovezoglin"] = "猪爱猪猪",
  ["pang__wither_skeleton_thewall"] = "倚墙而息",
}

return extension