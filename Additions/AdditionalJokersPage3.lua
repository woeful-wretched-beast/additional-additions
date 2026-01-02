SMODS.Joker {
    key = 'barrow_fog',
    name = 'BarrowFog',
    atlas = "add_atlas",
    pos = { x = 0, y = 7 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { odds = 3 } },
    loc_txt = {
        name = 'Barrow Fog',
        text = {
            'This has a {C:green}#1# in #2#{} chance',
            'to create a {C:role}role{} card',
            'when a {C:attention}joker{} is sold'
        }
    },
    loc_vars = function(self, info_queue, card)
        local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'barrow_fog')
        return { vars = { numer, denom } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and SMODS.pseudorandom_probability(card, 'barrow_fog', 1, card.ability.extra.odds) then
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
}

SMODS.Joker {
    key = 'c_b_luis',
    name = 'ConsumablesByLuis',
    atlas = "add_atlas",
    pos = { x = 1, y = 7 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { poker_hand = 'Straight', achieved = false } },
    loc_txt = {
        name = 'Consumables by Luis',
        text = {
            'If played hand is a {C:attention}#1#{},',
            'create a {C:role}role{} card, poker',
            'hand changes when achieved',
            'or at end of round otherwise'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.poker_hand } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
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
        if (context.before and context.scoring_name == card.ability.extra.poker_hand) or
          (context.end_of_round and context.game_over == false and context.main_eval and not card.ability.extra.achieved) 
          and not context.blueprint then
            if (context.before and context.scoring_name == card.ability.extra.poker_hand) then
                card.ability.extra.achieved = true
            end
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand
                  and handname ~= 'High Card' and handname ~= 'Pair' then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'luis')
            return {
                message = localize('k_reset')
            }
        end
        if (context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint) then
            card.ability.extra.achieved = false
        end
    end
}

SMODS.Joker {
    key = 'centurion',
    name = 'Centurion',
    atlas = "add_atlas",
    pos = { x = 2, y = 7 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { } },
    loc_txt = {
        name = 'Centurion',
        text = {
            'When the {C:attention}shop{} is entered,',
            'stock a random {C:role}identity pack{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.addadd_shop_start then
            G.shop_booster.config.card_limit = G.shop_booster.config.card_limit + 1 
            local booster = pseudorandom_element({G.P_CENTERS.p_addadd_role_booster_normal_1, G.P_CENTERS.p_addadd_role_booster_normal_2,
              G.P_CENTERS.p_addadd_role_booster_jumbo, G.P_CENTERS.p_addadd_role_booster_mega}, 'zone')
            local card = Card(G.shop_booster.T.x + G.shop_booster.T.w / 2, G.shop_booster.T.y, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty, booster)
            create_shop_card_ui(card, "Booster", G.shop_booster)
            card.ability.booster_pos = G.shop_booster.config.card_limit
            G.shop_booster:emplace(card)
        end
    end
}

SMODS.Joker {
    key = 'bigspender',
    name = 'BigSpender',
    atlas = "add_atlas",
    pos = { x = 3, y = 7 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { Xmult = 1, mult_gain = 0.2, cost = 25, spent_money = 25 } },
    loc_txt = {
        name = 'Big Spender',
        text = {
            'This joker gains {X:mult,C:white}X#1#{} Mult',
            'for every {C:money}$#2#{} spent',
            '{C:inactive}(currently {X:mult,C:white}X#3#{C:inactive} Mult, {C:money}$#4#{C:inactive} left){}',
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.cost, card.ability.extra.Xmult, card.ability.extra.spent_money } }
    end,
    calculate = function(self, card, context)
        if context.addadd_money_spent and context.money_mod <= 0 and not context.blueprint then
            spent = context.money_mod
            card.ability.extra.spent_money = card.ability.extra.spent_money + spent
            if card.ability.extra.spent_money <= 0 then
                while card.ability.extra.spent_money <= 0 do
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.mult_gain
                    card.ability.extra.spent_money = card.ability.extra.spent_money + card.ability.extra.cost
                end
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'X'..card.ability.extra.Xmult..' Mult'})
                    return true
                end)}))
            end
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
}

local ref_ease_dollars = ease_dollars
function ease_dollars(mod, instant)
    local original = ref_ease_dollars(mod, instant)
    for _, v in ipairs(G.jokers.cards) do
        if not v.debuff then
            v:calculate_joker({addadd_money_spent = true, money_mod = mod})
        end
    end
    return original
end

SMODS.Joker {
    key = 'auctioneer',
    name = 'Auctioneer',
    atlas = "add_atlas",
    pos = { x = 4, y = 7 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { chips = 0, chip_gain = 40 } },
    loc_txt = {
        name = 'Auctioneer',
        text = {
            '{C:chips}+#1#{} chips for each',
            'card {C:attention}sold{} this round',
            '{C:inactive}(currently {C:chips}+#2#{C:inactive} chips){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and G.GAME.blind.in_blind and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
        end
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.chips = 0
            return {
                message = localize('k_reset')
            }
        end
    end
}

SMODS.Joker {
    key = 'tardy_joker',
    name = 'TardyJoker',
    atlas = "add_atlas",
    pos = { x = 0, y = 8 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { mult = 3 } },
    loc_txt = {
        name = 'Tardy Joker',
        text = {
            '{C:mult}+#1#{} Mult for each hand',
            '{C:attention}played{} this round,',
            '{C:attention}doubled{} on final hand',
            '{C:inactive}(currently {C:mult}+#2#{C:inactive} Mult){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        local provided_mult = card.ability.extra.mult * G.GAME.current_round.hands_played
        if G.GAME.current_round.hands_left == 1 then
            provided_mult = provided_mult * 2
        end
        if G.GAME.blind then
            if not G.GAME.blind.in_blind then
                provided_mult = 0
            end
        end
        return { vars = { card.ability.extra.mult, provided_mult } }
    end,
    calculate = function(self, card, context)
        if context.hand_drawn and G.GAME.current_round.hands_left == 1 then
            local eval = function() return G.GAME.current_round.hands_left == 1 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.joker_main then
            local provided_mult = card.ability.extra.mult * G.GAME.current_round.hands_played
            if G.GAME.current_round.hands_left == 0 then
                provided_mult = provided_mult * 2
            end
            if provided_mult > 0 then
                return {
                    mult_mod = provided_mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { provided_mult } }
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'swinger',
    name = 'swinger',
    atlas = "add_atlas",
    pos = { x = 1, y = 8 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { mult = 10 } },
    loc_txt = {
        name = 'Swinger',
        text = {
            '{C:mult}+#1#{} Mult if hand hasn\'t',
            'been {C:attention}played{} this round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round == 1 then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

SMODS.Joker {
    key = 'commoncents',
    name = 'Common_Cents',
    atlas = "add_atlas",
    pos = { x = 2, y = 8 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { money = 2 } },
    loc_txt = {
        name = 'Common Cents',
        text = {
            'Earn {C:money}$#1#{} for every other',
            'owned {C:common}Common{} joker',
            'at end of round'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        local commons = -1
        for _, jker in ipairs(G.jokers.cards) do
            if jker.config.center.rarity == 1 then
                commons = commons + 1
            end
        end
        local bonus = card.ability.extra.money * commons
        if bonus > 0 then 
            return bonus 
        end
    end
}

SMODS.Joker {
    key = 'recyclingbin',
    name = 'Recycling_Bin',
    atlas = "add_atlas",
    pos = { x = 3, y = 8 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { chips = 0 } },
    loc_txt = {
        name = 'Recycling Bin',
        text = {
            'Provides the total {C:chips}chips{}',
            'of all {C:attention}playing cards{} in the',
            'most recent {C:red}discard{}',
            '{C:inactive}(currently {C:chips}+#1#{C:inactive} chips){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    chip_mod = card.ability.extra.chips,
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                }
            end
        end
        if context.pre_discard and not context.blueprint then
            card.ability.extra.chips = 0
            return {
                message = localize('k_reset')
            }
        end
        if context.discard and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + context.other_card:get_chip_bonus()
        end
    end
}

SMODS.Joker {
    key = 'bluerazcherry',
    name = 'Blue_Raz-Cherry_Slush',
    atlas = "add_atlas",
    pos = { x = 4, y = 8 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { conversions = 10 } },
    loc_txt = {
        name = 'Blue Raz-Cherry Slushie',
        text = {
            'The next {C:attention}#1#{} numbered, scoring',
            'cards become {C:mult}Mult{} cards if {C:attention}odd{}',
            'or {C:chips}Bonus{} cards if {C:attention}even{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.conversions } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local sipped = false
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() <= 10 and card.ability.extra.conversions > 0 then 
                    sipped = true
                    card.ability.extra.conversions = card.ability.extra.conversions - 1
                    if v:get_id()%2 == 0 then
                        v:set_ability(G.P_CENTERS.m_bonus, nil, true)
                    else
                        v:set_ability(G.P_CENTERS.m_mult, nil, true)
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
            end
            if card.ability.extra.conversions == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up()
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = 'Slurped!'
                }
            else 
                if sipped then
                    return {
                        message = 'Sipped!',
                        card = card
                    }
                end
            end
        end
    end
}