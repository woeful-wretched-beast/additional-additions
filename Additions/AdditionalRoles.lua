SMODS.ConsumableType{
    key = 'Role',
    primary_colour = HEX('E573C8'),
    secondary_colour = HEX('E573C8'),
    loc_txt = {
        name = 'Role',
        collection = 'Role Cards',
        undiscovered = {
            name = 'Unknown Role',
            text = { }
        }
    },
    collection_rows = {5, 5},
    shop_rate = 0,
    default = 'c_addadd_jester',
}

SMODS.Consumable {
    key = "jester",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Jester",
        text = {
            'Stock {C:attention}#1#{} Jokers with',
            'a random {C:attention}edition{}'
        },
    },
    config = { stocked_cards = 2 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.stocked_cards} } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        for i = 1, self.config.stocked_cards do
            Addadd_Funcs.stock_card(1, 'Joker', poll_edition('jest', nil, false, true))
        end
    end
}

SMODS.Consumable {
    key = "philosopher",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Philosopher",
        text = {
            'Stock {C:attention}#1#{} random',
            'consumables'
        },
    },
    config = { stocked_cards = 3 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.stocked_cards} } 
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge("Character", G.C.SECONDARY_SET.Role, nil, 1.2 )
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        Addadd_Funcs.stock_card(self.config.stocked_cards, 'Consumeables')
    end
}

SMODS.Consumable {
    key = "aura_seer",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Aura Seer",
        text = {
            'Stock {C:attention}#1#{} playing cards with',
            'a random {C:attention}edition{}, {C:attention}seal{},',
            'and {C:attention}enhancement{}'
        },
    },
    config = { stocked_cards = 2 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.stocked_cards} } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        for i = 1, self.config.stocked_cards do
            Addadd_Funcs.stock_playing_card(1, nil, nil, G.P_CENTERS[SMODS.poll_enhancement({key = 'aura_seer', guaranteed = true})],
            SMODS.poll_seal({key ='aura_seer', guaranteed = true}), poll_edition('aura_seer', nil, true, true))
        end
    end
}

SMODS.Consumable {
    key = "mystic_seer",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 3, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Mystic Seer",
        text = {
            'Only {C:tarot}Tarots{} can appear',
            'this shop, {C:attention}rerolls{} shop'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        G.GAME.addadd_roles.mystic_seer_active = true
        G.GAME.addadd_roles.apprentice_seer_active = false
        Addadd_Funcs.force_reroll()
    end
}

SMODS.Consumable {
    key = "apprentice_seer",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 4, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Apprentice Seer",
        text = {
            'Only {C:planet}Planets{} can appear',
            'this shop, {C:attention}rerolls{} shop'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        G.GAME.addadd_roles.mystic_seer_active = false
        G.GAME.addadd_roles.apprentice_seer_active = true
        Addadd_Funcs.force_reroll()
    end
}

SMODS.Consumable {
    key = "arsonist",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 0, y = 1 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Arsonist",
        text = {
            'Stock a {C:matchbox_type}Matchbox{} for',
            'every {C:money}#1#${} of {C:attention}reroll{}',
            '{C:attention}cost{}',
            '{C:inactive}(max of {C:attention}#2#{C:inactive}){}'
        },
    },
    config = { dollars = 2, max = 5 },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.c_addadd_Matchbox
        return { vars = { self.config.dollars, self.config.max } } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        local stocked_cards = math.floor(G.GAME.current_round.reroll_cost/self.config.dollars)
        if stocked_cards > self.config.max then
            stocked_cards = self.config.max
        end
        Addadd_Funcs.stock_card(stocked_cards, 'matchbox_type')
    end
}

SMODS.Consumable {
    key = "boomdandy",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 1, y = 1 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Boomdandy",
        text = {
            '{C:attention}Remove{} all items from shop and',
            'earn their total price as {C:money}${}'
        },
    },
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge("Character", G.C.SECONDARY_SET.Role, nil, 1.2 )
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        local payout = 0
        for i, c in pairs(G.shop_jokers.cards) do
            payout = payout + c.cost
            c:start_dissolve()
        end
        for i, c in pairs(G.shop_booster.cards) do
            payout = payout + c.cost
            c:start_dissolve()
        end
        for i, c in pairs(G.shop_vouchers.cards) do
            payout = payout + c.cost
            G.GAME.current_round.voucher.spawn[c.config.center_key] = false
            c:start_dissolve()
        end
        ease_dollars(payout)
    end
}

SMODS.Consumable {
    key = "hunter",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 2, y = 1 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Hunter",
        text = {
            'Earn {C:attention}#1#X{} the cost of',
            'a reroll as {C:money}${}',
            '{C:inactive}(Max of {C:money}#2#${C:inactive}){}'
        },
    },
    config = { multiplier = 3, max = 45 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.multiplier, self.config.max } } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        local payout = G.GAME.current_round.reroll_cost * self.config.multiplier
        if payout > self.config.max then
            payout = self.config.max
        end
        ease_dollars(payout)
    end
}

SMODS.Consumable {
    key = "gunner",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 3, y = 1 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Gunner",
        text = {
            '{C:attention}Reroll{} the shop, all {C:attention}boosters{},',
            'and all {C:attention}vouchers{}',
            '{s:0.8}doesn\'t restock boosters/vouchers{}'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        Addadd_Funcs.force_reroll()
        local items = 0
        for i, c in pairs(G.shop_booster.cards) do
            items = items + 1
            c:start_dissolve()
        end
        for i = 1, items do
            SMODS.add_booster_to_shop()
        end
        items = 0
        local vouch = nil
        for i, c in pairs(G.shop_vouchers.cards) do
            if items == 0 then
                vouch = c.config.center
            end
            items = items + 1
            G.GAME.current_round.voucher.spawn[c.config.center_key] = false
            c:start_dissolve()
        end
        for i = 1, items do
            SMODS.add_voucher_to_shop()
        end
        if G.GAME.current_round.voucher.spawn[vouch] then
            G.GAME.current_round.voucher.spawn[vouch] = false
            G.GAME.current_round.voucher.spawn[G.shop_vouchers.cards[1]] = true
        end
    end
}

SMODS.Consumable {
    key = "magus",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 4, y = 1 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Magus",
        text = {
            'Stock a {C:attention}copy{} of a',
            '{C:green}random{} purchasable',
            'card',
            '{s:0.8}does not copy edition'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        if #G.shop_jokers.cards > 0 then
            local copied_card = pseudorandom_element(G.shop_jokers.cards, pseudoseed('hit role magus from hit discord server town of salem anticipation'))
            if copied_card.ability.effect == 'Base' or copied_card.ability.set == 'Enhanced' then
                Addadd_Funcs.stock_playing_card_copy(copied_card)
            else
                Addadd_Funcs.stock_card(1, copied_card.ability.set, nil, copied_card.config.center.key)
            end
        end
    end
}

SMODS.Consumable {
    key = "mason",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 0, y = 2 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Mason",
        text = {
            'Gain {C:attention}#3#{} free {C:green}Rerolls{} for each',
            '{C:attention}Mason{} used this run',
            '{C:inactive}(Currently {C:attention}#1#{C:inactive}, max of {C:attention}#2#{C:inactive}){}'
        },
    },
    config = { max = 10, multiplier = 2 },
    loc_vars = function(self, info_queue)
        local currently = (G.GAME.addadd_roles.masons_used * self.config.multiplier) + self.config.multiplier
        if currently > self.config.max then
            currently = self.config.max
        end
        return { vars = { currently, self.config.max, self.config.multiplier } } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        G.GAME.addadd_roles.masons_used = G.GAME.addadd_roles.masons_used + 1
        if G.GAME.addadd_roles.masons_used * self.config.multiplier > self.config.max then
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + self.config.max
        else
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + (G.GAME.addadd_roles.masons_used * self.config.multiplier)
        end
        calculate_reroll_cost()
    end
}

SMODS.Consumable {
    key = "channeler",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 1, y = 2 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Channeler",
        text = {
            'Stock a {C:spectral}Spectral Pack{}'
        },
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        SMODS.add_booster_to_shop('p_spectral_normal_1')
    end
}

SMODS.Consumable {
    key = "robber",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 2, y = 2 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Robber",
        text = {
            'All {C:attention}cards{} and {C:attention}boosters{} currently',
            'in shop are made {C:money}free{}',
            '{C:inactive}(not {C:dark_edition}negative{C:inactive} cards){}'
        },
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        for i, c in pairs(G.shop_jokers.cards) do
            if not (c.edition and c.edition.key == 'e_negative') then
                c.cost = 0
            end
        end
        for i, c in pairs(G.shop_booster.cards) do
            c.cost = 0
        end
    end
}

SMODS.Consumable {
    key = "baron",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 3, y = 2 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Baron",
        text = {
            'This shop has {C:attention}2{}',
            'more card slots',
            '{C:inactive}(doesn\'t stack){}'
        },
    },
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge("Character", G.C.SECONDARY_SET.Role, nil, 1.2 )
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        if not G.GAME.addadd_roles.baron_active then
            G.GAME.addadd_roles.baron_active = true
            change_shop_size(2)
        end
    end
}

SMODS.Consumable {
    key = "executive",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 4, y = 2 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Executive",
        text = {
            'All items this shop are',
            '{C:attention}half price{}'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        if not G.GAME.addadd_roles.executive_active then
            G.GAME.addadd_roles.executive_active = true
            G.GAME.discount_percent = 50
            for i, c in pairs(G.shop_jokers.cards) do
                c:set_cost(c.cost) 
            end
            for i, c in pairs(G.shop_booster.cards) do
                c:set_cost(c.cost) 
            end
            for i, c in pairs(G.shop_vouchers.cards) do
                c:set_cost(c.cost) 
            end
        end
    end
}

SMODS.Consumable {
    key = "diablo",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 0, y = 3 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Diablo",
        text = {
            '{C:attention}Destroy{} the chosen Joker',
            'and stock {C:attention}#1#{} Jokers',
            'of the same {C:attention}rarity{}',
            '{C:inactive}({C:attention}1{C:inactive} if higher than {C:rare}rare{C:inactive}){}'
        },
    },
    config = { stocked_cards = 2 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.stocked_cards } } 
    end,
    can_use = function(self, card)
        return G.shop and #G.jokers.highlighted == 1 and G.jokers.highlighted[1].ability.set == 'Joker'
    end,
    use = function(self, card, area, copier)
        local kill = G.jokers.highlighted[1]
        -- local kill_rarity = 0
        -- if kill.config.center.rarity == 1 or kill.config.center.rarity == 2 then
        --     kill_rarity = kill.config.center.rarity + 1
        -- else
        local kill_rarity = kill.config.center.rarity
        -- end

        if not kill.ability.eternal then
            kill:start_dissolve()
        end
        local stock_candidates = {}
        for i, center in ipairs(G.P_CENTER_POOLS.Joker) do
            if center.rarity == kill_rarity and center.unlocked then
                table.insert(stock_candidates, center.key) 
            end
        end
        if kill.config.center.rarity == 3 or kill.config.center.rarity == 2 or kill.config.center.rarity == 1 then
            for i = 1, self.config.stocked_cards do
                Addadd_Funcs.stock_card(1, 'Joker', nil, pseudorandom_element(stock_candidates, pseudoseed('diablo')))
            end
        else
            Addadd_Funcs.stock_card(1, 'Joker', nil, pseudorandom_element(stock_candidates, pseudoseed('diablo')))
        end
    end
}

SMODS.Consumable {
    key = "mentalist",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 1, y = 3 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Mentalist",
        text = {
            'Cards in this shop are {C:attention}10X{} as likely',
            'to have an {C:dark_edition}edition{} and cannot have',
            'a {C:attention}sticker{}'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        G.GAME.addadd_roles.mentalist_active = true
        if not G.GAME.addadd_roles.mentalist_active then
            G.GAME.edition_rate = G.GAME.edition_rate * 10
        end
        for i, c in pairs(G.shop_jokers.cards) do
            for key, sticker in pairs(SMODS.Stickers) do
                c.ability[key] = false
            end
            c:set_cost(c.cost)
        end
    end
}

SMODS.Consumable {
    key = "curator",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 2, y = 3 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Curator",
        text = {
            '{C:common}Common{} Jokers are {C:attention}3X{}',
            'less likely to appear',
            'this shop, {C:attention}rerolls{} shop'
        },
    },
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        G.GAME.addadd_roles.curator_active = true
        Addadd_Funcs.force_reroll()
    end
}

SMODS.Consumable {
    key = "transporter",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 3, y = 3 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Transporter",
        text = {
            'Stock {C:attention}#1#{} {C:money}free{} cards'
        },
    },
    config = { cards = 2 },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.cards } } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        for i = 1, self.config.cards do
            local rand = pseudorandom('trans rights', 0, 10)
            if rand > 7.5 then
                Addadd_Funcs.stock_card(1, 'Joker', poll_edition('trans wrongs', nil, false, false), nil)
            elseif rand > 5 then
                Addadd_Funcs.stock_playing_card(1, nil, nil, G.P_CENTERS[SMODS.poll_enhancement({key = 'trans lefts', guaranteed = false})],
                SMODS.poll_seal({key ='trans ups', guaranteed = false}), poll_edition('trans downs', nil, true, false))
            else
                Addadd_Funcs.stock_card(1, 'Consumeables', nil, nil)
            end
        end
        for i = 0, self.config.cards - 1 do
            G.shop_jokers.cards[#G.shop_jokers.cards - i].cost = 0
        end
    end
}

SMODS.Consumable {
    key = "tanner",
    set = "Role",
    atlas = "add_roles",
    pos = { x = 4, y = 3 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "The Tanner",
        text = {
            '{C:green}#2# in #1#{} chance to stock a {C:dark_edition}negative{}',
            '{C:uncommon}uncommon{} or {C:rare}rare{} Joker'
        },
    },
    config = { odds = 4 },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return { vars = { self.config.odds, G.GAME.probabilities.normal or 1 } } 
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        if pseudorandom('tanner') < G.GAME.probabilities.normal / self.config.odds then
            local stock_candidates = {}
            for i, center in ipairs(G.P_CENTER_POOLS.Joker) do
                if (center.rarity == 2 or center.rarity == 3) and center.unlocked then
                    table.insert(stock_candidates, center.key) 
                end
            end
            Addadd_Funcs.stock_card(1, 'Joker', 'e_negative', pseudorandom_element(stock_candidates, pseudoseed('tanner')))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Role,
                    align = (G.STATE == G.STATES.SMODS_BOOSTER) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.SMODS_BOOSTER) and -0.2 or 0},
                    silent = true
                })
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                card:juice_up(0.3, 0.5)
                return true 
            end }))
        end
    end
}

SMODS.Consumable {
    key = "wizard",
    set = "Spectral",
    atlas = "wiz",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = false,
    hidden = true,
    soul_set = 'Role',
    soul_rate = 0.003,
    loc_txt = {
        name = "The Wizard",
        text = {
            'Stock a {C:dark_edition}Negative{} {C:attention}copy{}',
            'of {C:legendary,E:1}every{} owned {C:attention}Joker{}'
        },
    },
    in_pool = function(self, card) 
        return G.shop
    end,
    can_use = function(self, card)
        return G.shop
    end,
    use = function(self, card, area, copier)
        for _, v in ipairs(G.jokers.cards) do
            Addadd_Funcs.stock_card(1, 'Joker', 'e_negative', v.config.center.key)
        end
    end,
    set_sprites = function(self, card, front)
        G.energy_ball = Sprite(0, 0, 71, 95, G.ASSET_ATLAS[card.config.center.atlas], {x = 1, y = 0})
    end
}

SMODS.DrawStep {
    key = 'add_wizard',
    order = 51,
    func = function(card)
        if card.config.center.key == "c_addadd_wizard" and (card.config.center.discovered or card.bypass_discovery_center) then
            local scale_mod = (0.1 * math.cos(2.2 * G.TIMERS.REAL)) + 0.2 
            local rotate_mod = 2.15 * (G.TIMERS.REAL + (math.sin(0.5 * G.TIMERS.REAL)/2))
            local x_mod = 0.15 * math.sin(G.TIMERS.REAL)
            local y_mod = 0.25 + (0.1 * math.sin(2 * G.TIMERS.REAL))

            G.energy_ball.role.draw_major = card
            G.energy_ball:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, x_mod, y_mod, nil, 0.6)
            G.energy_ball:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod, x_mod, y_mod)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}