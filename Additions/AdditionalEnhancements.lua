SMODS.Enhancement {
    key = "bronze",
    atlas = "add_enhancements",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    config = { h_mult = 6 },
    loc_txt = {
        name = "Bronze Card",
        text = {
            '{C:mult}+#1#{} Mult when',
            'held in hand'
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_mult } }
    end,
}

SMODS.Enhancement {
    key = "tin",
    atlas = "add_enhancements",
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    config = { h_chips = 40 },
    loc_txt = {
        name = "Tin Card",
        text = {
            '{C:chips}+#1#{} chips when',
            'held in hand'
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_chips } }
    end,
}