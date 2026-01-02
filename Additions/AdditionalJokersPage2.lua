SMODS.Joker {
    key = 'clown_car',
    name = 'ClownCar',
    atlas = "add_atlas",
    pos = { x = 0, y = 4 },
    rarity = 1,
    cost = 2,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { } },
    loc_txt = {
        name = 'Clown Car',
        text = {
            'When a {C:attention}joker{} is sold,',
            'stock a {C:attention}buffoon pack{}',
            'that costs {C:money}$4{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and G.shop then
            G.shop_booster.config.card_limit = #G.shop_booster.cards + 1 
            local card = Card(G.shop_booster.T.x + G.shop_booster.T.w / 2, G.shop_booster.T.y, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty, G.P_CENTERS.p_buffoon_normal_1)
            create_shop_card_ui(card, "Booster", G.shop_booster)
            card.ability.booster_pos = G.shop_booster.config.card_limit
            card.cost = 4
            G.shop_booster:emplace(card)
        end
    end
}

SMODS.Joker {
    key = 'rolling_ball',
    name = 'RollingBall',
    atlas = "add_atlas",
    pos = { x = 1, y = 4 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { active = false, h_size = 2 } },
    loc_txt = {
        name = 'Rolling Ball',
        text = {
            'If last played hand',
            'contained a {C:attention}Straight{},',
            '{C:attention}+#1#{} hand size'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            G.hand:change_size(card.ability.extra.h_size)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            G.hand:change_size(-card.ability.extra.h_size)
        end
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands ~= nil and not context.blueprint then
            if not card.ability.extra.active and next(context.poker_hands['Straight']) then
                card.ability.extra.active = true
                G.hand:change_size(card.ability.extra.h_size)
                return { 
                    message = "Active!"
                }
            end
            if card.ability.extra.active and not next(context.poker_hands['Straight']) then
                card.ability.extra.active = false
                G.hand:change_size(-card.ability.extra.h_size)
                return { 
                    message = "Inactive"
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'toilet',
    name = 'Toilet',
    atlas = "add_atlas",
    pos = { x = 2, y = 4 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { used = false } },
    loc_txt = {
        name = 'Toilet',
        text = {
            'If played hand contains a {C:attention}Flush{},',
            'destroy all played cards',
            '{C:red,E:2}self destructs{}'
        }
    },
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Flush']) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))
            return {
                message = "Flushed!"
            }
        end
        if context.destroying_card and not context.blueprint and next(context.poker_hands['Flush']) then
            return true
        end
    end
}

SMODS.Joker {
    key = 'lmao_bang',
    name = 'LmaoBang',
    atlas = "add_atlas",
    pos = { x = 3, y = 4 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { mult = 20, max_jokers = 3 } },
    loc_txt = {
        name = 'Lmao Bang',
        text = {
            '{C:mult}+#1#{} Mult if you own',
            '{C:attention}#2#{} or fewer {C:attention}jokers{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.max_jokers } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #G.jokers.cards <= card.ability.extra.max_jokers then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'homemade_pants',
    name = 'HomemadePants',
    atlas = "add_atlas",
    pos = { x = 4, y = 4 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { chips = 0, chip_gain = 8 } },
    loc_txt = {
        name = 'Homemade Pants',
        text = {
            'This joker gains {C:chips}+#2#{} Chips if',
            'discarded hand is a {C:attention}Two Pair{}',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.pre_discard and not context.blueprint then 
            local hand_info = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            if hand_info == 'Two Pair' then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    message = '+'..card.ability.extra.chips..' Chips',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'marketable_joker',
    name = 'MarketableJoker',
    atlas = "add_atlas",
    pos = { x = 0, y = 5 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    loc_txt = {
        name = 'Marketable Joker',
        text = {
            'When shop is {C:attention}entered{} or {C:attention}rerolled{},',
            'stock a joker from the {C:attention}first',
            '{C:attention}page{} of the {C:attention}collection{}'
        }
    },
    calculate = function(self, card, context)
        if context.addadd_shop_start or context.reroll_shop then
            local first_page = { 'j_joker', 'j_greedy_joker', 'j_lusty_joker', 'j_wrathful_joker', 'j_gluttenous_joker',
            'j_jolly', 'j_zany', 'j_mad', 'j_crazy', 'j_droll', 'j_sly', 'j_wily', 'j_clever', 'j_devious', 'j_crafty'}
            Addadd_Funcs.stock_card(1, 'Joker', poll_edition('market', nil, false, false), pseudorandom_element(first_page, pseudoseed('market')))
        end
    end
}

SMODS.Joker {
    key = 'clickbait',
    name = 'Clickbait',
    atlas = "add_atlas",
    pos = { x = 1, y = 5 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = { extra = { mult_mod = 5 } },
    loc_txt = {
        name = 'Clickbait',
        text = {
            'Played {C:chips}Bonus{} cards',
            'give {C:mult}+#1#{} Mult',
            'when scored'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config.center == G.P_CENTERS.m_bonus then
                return {
                    mult = card.ability.extra.mult_mod,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'fire_lion',
    name = 'FireLion',
    atlas = "add_atlas",
    pos = { x = 2, y = 5 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = { extra = { chips_mod = 20 } },
    loc_txt = {
        name = 'Fire Lion',
        text = {
            '{C:chips}+#1#{} Chips for each',
            '{C:mult}mult{} card in',
            'your {C:attention}full deck{}',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        local mult_count = 0
        if G.GAME and G.playing_cards then
            for i, card in ipairs(G.playing_cards) do
                if card.config.center == G.P_CENTERS.m_mult then 
                    mult_count = mult_count + 1
                end
            end
        end
        return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips_mod * mult_count } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local mult_count = 0
            if G.GAME and G.playing_cards then
                for i, card in ipairs(G.playing_cards) do
                    if card.config.center == G.P_CENTERS.m_mult then 
                        mult_count = mult_count + 1
                    end
                end
            end
            return {
                chips = card.ability.extra.chips_mod * mult_count
            }
        end
    end
}

SMODS.Joker {
    key = 'martian_scout',
    name = 'MartianScout',
    atlas = "add_atlas",
    pos = { x = 3, y = 5 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { odds = 2, used_planets = {} } },
    loc_txt = {
        name = 'Martian Scout',
        text = {
            '{C:green}#2# in #1#{} chance to create ',
            'a {C:role}Role{} card the {C:attention}1st{} time',
            'each {C:planet}Planet{} card is used',
            'since shop was last entered',
            '{C:inactive}(Must have room){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.odds, G.GAME.probabilities.normal or 1 } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Planet" then
            local active = true
            for index = 1, #card.ability.extra.used_planets do
                if card.ability.extra.used_planets[index] == context.consumeable.ability.name then
                    active = false
                end
            end
            if active then
                if pseudorandom('alieg!!!') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local role = SMODS.create_card({set = 'Role', area = G.consumeables})
                                role:add_to_deck()
                                G.consumeables:emplace(role)
                            end
                            return true
                        end
                    }))
                end
            end
            card.ability.extra.used_planets[#card.ability.extra.used_planets + 1] = context.consumeable.ability.name
        end
        if context.addadd_shop_start then
            card.ability.extra.used_planets = {}
        end
    end
}

SMODS.Joker {
    key = 'waterwheel_girl',
    name = 'WaterwheelGirl',
    atlas = "add_atlas",
    pos = { x = 4, y = 5 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { reroll_cost = 0 } },
    loc_txt = {
        name = 'Waterwheel Girl',
        text = {
            'When a {C:role}Role{} card is used,',
            'set reroll cost to {C:money}$#1#{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.reroll_cost } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Role" then
            G.GAME.current_round.reroll_cost_increase = card.ability.extra.reroll_cost - G.GAME.round_resets.reroll_cost
            G.GAME.current_round.reroll_cost = card.ability.extra.reroll_cost
        end
    end
}

SMODS.Joker {
    key = 'flowers_of_neptune',
    name = 'FlowersOfNeptune',
    atlas = "add_atlas",
    pos = { x = 0, y = 6 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { Xmult = 1, plus = 0.5 } },
    loc_txt = {
        name = 'Flowers of Neptune',
        text = {
            'This joker gains {X:mult,C:white}X#2#{} Mult',
            'if played hand contains',
            'a {C:attention}Straight Flush{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.plus } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
        if context.before and context.cardarea == G.jokers and next(context.poker_hands['Straight Flush']) and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.plus
            return {
                message = 'Upgraded!',
                colour = G.C.MULT,
                card = card
                }
        end
    end
}

SMODS.Joker {
    key = 'vein_of_stars',
    name = 'VeinOfStars',
    atlas = "add_atlas",
    pos = { x = 1, y = 6 },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    loc_txt = {
        name = 'Vein of Stars',
        text = {
            'When using {C:planet}Jupiter{}, {C:planet}Saturn{},',
            'or {C:planet}Neptune{}, upgrade all',
            'their respective {C:attention}poker hands{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_jupiter
        info_queue[#info_queue+1] = G.P_CENTERS.c_saturn
        info_queue[#info_queue+1] = G.P_CENTERS.c_neptune
        return {}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Planet" then
            if context.consumeable.ability.hand_type == 'Straight' or context.consumeable.ability.hand_type == 'Flush' or context.consumeable.ability.hand_type == 'Straight Flush' then
                local hand_types = {'Straight', 'Flush', 'Straight Flush'}
                for _, hand_type in pairs(hand_types) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', func = function()
                            if hand_type ~= context.consumeable.ability.hand_type then
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand_type, 'poker_hands'),chips = G.GAME.hands[hand_type].chips, mult = G.GAME.hands[hand_type].mult, level=G.GAME.hands[hand_type].level})
                                level_up_hand(card, hand_type)
                                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                            end
                            return true
                        end
                    }))
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'silent_explosion',
    name = 'SilentExplosion',
    atlas = "add_atlas",
    pos = { x = 2, y = 6 },
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { odds = 2 } },
    loc_txt = {
        name = 'Silent Explosion',
        text = {
            'If {C:attention}first{} hand of round does',
            'not contain a {C:attention}Straight Flush{},',
            '{C:attention}scored{} cards have a {C:green}1 in 2{}',
            'chance to be {C:red}destroyed{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card and not next(context.poker_hands['Straight Flush']) and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            if pseudorandom('silver_dollar') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return true
            end
        end
    end
}

SMODS.Joker {
    key = 'magic_forest',
    name = 'MagicForest',
    atlas = "add_atlas",
    pos = { x = 3, y = 6 },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    loc_txt = {
        name = 'Magic Forest',
        text = {
            'If played hand contains a',
            '{C:attention}Flush{} and an {C:attention}Ace{}, all played',
            'cards become a {C:attention}10{} through {C:attention}6{}'
        }
    },
    calculate = function(self, card, context)
        local activated = false
        if context.full_hand and context.poker_hands then
            for i = 1, #context.full_hand do
                if SMODS.Ranks[context.full_hand[i].base.value].key == "Ace" then
                    activated = true
                end
            end
            activated = next(context.poker_hands['Flush']) and activated
        end
        if context.after and activated then
            local ranks = {'10', '9', '8', '7', '6'}
            for i = 1, #context.full_hand do
                    local percent = 1.15 - (i - 0.999) / (#context.full_hand - 0.998) * 0.3
			        G.E_MANAGER:add_event(Event({
				        trigger = "after",
			            delay = 0.15,
			            func = function()
                            context.full_hand[i]:flip()
                            play_sound('card1', percent)
                            context.full_hand[i]:juice_up(0.3,0.3)
                            return true
                        end,
                    }))
                end
                delay(0.2)
                for i = 1, #context.full_hand do
                    local percent = 0.85 - (i - 0.999) / (#context.full_hand - 0.998) * 0.3
			        G.E_MANAGER:add_event(Event({
				        trigger = "after",
			            delay = 0.15,
			            func = function()
                            context.full_hand[i] = SMODS.change_base(context.full_hand[i], nil, ranks[i])
                            context.full_hand[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            context.full_hand[i]:juice_up(0.3,0.3)
                        return true
                    end,
                }))
            end
        end
        if context.after and context.cardarea == G.jokers and activated then
            return {
                message = "All figured out!"
            }
        end
    end
}

SMODS.Joker {
    key = 't_s_b_unicorns',
    name = 'ThereShouldBeUnicorns',
    atlas = "add_atlas",
    pos = { x = 4, y = 6 },
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { active = false, h_size = 4 } },
    loc_txt = {
        name = 'Purple-Eyed Unicorn',
        text = {
            '{C:attention}+#1#{} hand size once a',
            '{C:attention}Straight Flush{} is played',
            'while this is owned'
            
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            G.hand:change_size(card.ability.extra.h_size)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            G.hand:change_size(-card.ability.extra.h_size)
        end
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands ~= nil and not context.blueprint then
            if not card.ability.extra.active and next(context.poker_hands['Straight Flush']) then
                card.ability.extra.active = true
                G.hand:change_size(card.ability.extra.h_size)
                return { 
                    message = "Active!"
                }
            end
        end
    end
}