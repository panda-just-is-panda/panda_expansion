local zhangwu = fk.CreateSkill {
  name = "pang_zhangwu",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_zhangwu"] = "章武",
  [":pang_zhangwu"] = "主公技，当汉势力或蜀势力角色使用【杀】造成伤害后，你可以令受到伤害的角色选择一项：弃置一张手牌；令你摸一张牌。",
  ["liubei_draw1"] = "令刘备摸一张牌",
  ["discard_hand1"] = "弃置一张手牌",
  ["#zhangwu_discard"] = "章武：你需要弃置一张手牌",

  ["$pang_zhangwu1"] = "匡扶汉室，岂能无诸将之助！",
  ["$pang_zhangwu2"] = "大汉将士，何人敢战！",
}

zhangwu:addEffect(fk.Damage,{
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
              return player:hasSkill(zhangwu.name) and data.card and data.card.trueName == "slash" and (data.extra_data or {}).zhangwuCheck
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local to = data.to
        local choices = {"liubei_draw1"}
        if not to:isKongcheng() then
            table.insert(choices, 2, "discard_hand1")
        end
        local choice = room:askToChoice(to, {
            choices = choices,
            skill_name = zhangwu.name,
        })
        if choice == "liubei_draw1" then
            player:drawCards(1)
        else
            local card = room:askToDiscard(player, {
                skill_name = zhangwu.name,
                prompt = "#zhangwu_discard",
                cancelable = false,
                min_num = 1,
                max_num = 1,
                include_equip = false,
            })
        end
    end,
    })

zhangwu:addEffect(fk.BeforeHpChanged, {
  can_refresh = function(self, event, target, player, data)
    if data.damageEvent and (data.damageEvent.from.kingdom == "shu" or data.damageEvent.from.kingdom == "han") then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    data.damageEvent.extra_data = data.damageEvent.extra_data or {}
    data.damageEvent.extra_data.zhangwuCheck = true
  end,
})

    return zhangwu