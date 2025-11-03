SMODS.Booster {
    key = 'role_booster_normal_1',
    atlas = "add_boosters",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 0.7,
    discovered = true,
    config = { extra = 3, choose = 1},
    loc_txt = {
        name = "Identity Pack",
        group_name = 'Identity Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:role}Role{} cards to',
            'be used immediately'
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.choose, self.config.extra } } 
    end,
    create_card = function(self, card)
        return { set = 'Role', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'addadd' }
    end,
}

SMODS.Booster {
    key = 'role_booster_normal_2',
    atlas = "add_boosters",
    pos = { x = 1, y = 0 },
    cost = 4,
    weight = 0.7,
    discovered = true,
    config = { extra = 3, choose = 1},
    loc_txt = {
        name = "Identity Pack",
        group_name = 'Identity Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:role}Role{} cards to',
            'be used immediately'
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.choose, self.config.extra } } 
    end,
    create_card = function(self, card)
        return { set = 'Role', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'addadd' }
    end,
}

SMODS.Booster {
    key = 'role_booster_jumbo',
    atlas = "add_boosters",
    pos = { x = 2, y = 0 },
    cost = 6,
    weight = 0.7,
    discovered = true,
    config = { extra = 5, choose = 1},
    loc_txt = {
        name = "Jumbo Identity Pack",
        group_name = 'Identity Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:role}Role{} cards to',
            'be used immediately'
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.choose, self.config.extra } } 
    end,
    create_card = function(self, card)
        return { set = 'Role', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'addadd' }
    end,
}

SMODS.Booster {
    key = 'role_booster_mega',
    atlas = "add_boosters",
    pos = { x = 3, y = 0 },
    cost = 8,
    weight = 0.2,
    discovered = true,
    config = { extra = 5, choose = 2},
    loc_txt = {
        name = "Mega Identity Pack",
        group_name = 'Identity Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:role}Role{} cards to',
            'be used immediately'
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.choose, self.config.extra } } 
    end,
    create_card = function(self, card)
        return { set = 'Role', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'addadd' }
    end,
}