SMODS.Joker {
    key = 'sleepy_joker',
    name = "Sleepy Joker",
    atlas = "add_atlas",
    pos = { x = 0, y = 1 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { Xmult = 2, nap_time = 5, time_napping = 0 } },
    loc_txt = {
        name = 'Sleepy Joker',
        text = {
            "{X:mult,C:white}X#1#{} Mult after",
            "{C:attention}#2#{} rounds played",
            "{C:inactive}(Currently {C:attention}#3#{C:inactive}/#2#){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.nap_time, card.ability.extra.time_napping } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.time_napping == card.ability.extra.nap_time then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
        if context.end_of_round and card.ability.extra.time_napping ~= card.ability.extra.nap_time and not (context.individual or context.repetition) and not context.game_over then
            card.ability.extra.time_napping = card.ability.extra.time_napping + 1
            if card.ability.extra.time_napping < card.ability.extra.nap_time then
                return { 
                    message = { card.ability.extra.time_napping..'/'..card.ability.extra.nap_time }
                }
            else
                return { 
                    message = 'Powernap Over!'
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'brain_worm',
    name = 'Brain Worm',
    atlas = "add_atlas",
    pos = { x = 1, y = 1 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { mult = 0, plus = 1 } },
    loc_txt = {
        name = 'Brain Worm',
        text = {
            'This joker gains {C:mult}+#2#{} Mult',
            'for each scoring {C:attention}9{}',
            '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.plus } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 9 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.plus
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

SMODS.Joker {
    key = 'hot_shit',
    name = 'Hot Shit',
    atlas = "add_atlas",
    pos = { x = 2, y = 1 },
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { Xmult = 1, plus = 0.5 } },
    loc_txt = {
        name = 'Hot Shit',
        text = {
            'This joker gains',
            '{X:mult,C:white}X#2#{} Mult for each',
            '{C:attention}consecutive{} hand that',
            'does not win in one',
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
        
        if context.after and math.floor(hand_chips * mult) >= G.GAME.blind.chips and not context.blueprint then
            card.ability.extra.Xmult = 1
            return {
                message = 'Reset',
                card = card
            }
        elseif context.after and math.floor(hand_chips * mult) < G.GAME.blind.chips and not context.blueprint then
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
    key = 'high_tech_authority',
    name = 'High-Tech Authority',
    atlas = "add_atlas",
    pos = { x = 3, y = 1 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { money = 6 } },
    loc_txt = {
        name = 'High-Tech Authority',
        text = {
            'Earn {C:money}#1#${} if {C:attention}2{} or more',
            '{C:attention}Aces{} are played'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and not context.before and context.after and context.scoring_hand then
            local aces = 0
            for i = 1, #context.scoring_hand do
				if SMODS.Ranks[context.scoring_hand[i].base.value].key == "Ace" then
					aces = aces + 1
				end
			end
            if aces >= 2 then
                ease_dollars(card.ability.extra.money)
				return { 
                    message = "$" .. card.ability.extra.money,
                    colour = G.C.MONEY 
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jill',
    name = 'Jill',
    atlas = "add_atlas",
    pos = { x = 4, y = 1 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    config = { extra = { chips = 0, plus = 3 } },
    loc_txt = {
        name = 'Jill',
        text = {
            'This Joker gains {C:chips}+#2#{}',
            'Chips for each {C:attention}Jack{}',
            'held in hand',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.plus } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
        if context.cardarea == G.hand and context.individual and not context.end_of_round then
            if context.other_card:get_id() == 11 and not context.other_card.debuff then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.plus
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
            elseif context.other_card:get_id() == 11 then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'silver_dollar',
    name = 'Silver Dollar',
    atlas = "add_atlas",
    pos = { x = 0, y = 2 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    enhancement_gate = 'm_lucky',
    config = { extra = { retriggers = 1, odds = 3, evens = 3} },
    loc_txt = {
        name = 'Silver Dollar',
        text = {
            '{C:attention}Lucky{} cards have two',
            '{C:green}#2# in #4#{} chances to',
            'be retriggered'
        }
        -- text = {
        --     '{C:attention}Lucky{} cards have a',
        --     '{C:green}#2# in #3#{} & a {C:green}#2# in #4#{} chance',
        --     'of being retriggered'
        -- }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.evens} }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card.ability.effect == 'Lucky Card' then
                local hits = 0
                if pseudorandom('silver_dollar') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    hits = hits + 1
                end
                if pseudorandom('silver_dollar') < G.GAME.probabilities.normal / card.ability.extra.evens then
                    hits = hits + 1
                end
                if hits >= 1 then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retriggers * hits,
                        card = card
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'lamb_chops',
    name = 'Lamb Chops',
    atlas = "add_atlas",
    pos = { x = 1, y = 2 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { money = 33 } },
    loc_txt = {
        name = 'Lamb Chops',
        text = {
            'If played hand is a',
            '{C:attention}Three of a Kind{} that\'s',
            'composed of {C:attention}6s{}, earn {C:money}#1#${}',
            'and destroy this card'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and not context.before and context.after and context.scoring_hand then
            if G.GAME.current_round.current_hand.handname == 'Three of a Kind' then
                local sixes = 0
                    for i = 1, #context.scoring_hand do
		        		if SMODS.Ranks[context.scoring_hand[i].base.value].key == "6" then
				        	sixes = sixes + 1
        				end
		        	end
                if sixes == 3 then
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
                    ease_dollars(card.ability.extra.money)
				    return { 
                        message = "Sacrificed!",
                        colour = G.C.MONEY 
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'lemonade',
    name = 'Lemonade',
    atlas = "add_atlas",
    pos = { x = 2, y = 2 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { sips = 5, sips_left = 5 } },
    loc_txt = {
        name = 'Lemonade',
        text = {
            'Played non-scoring cards are',
            'given a random enhancement,',
            'this card is destroyed after',
            '{C:attention}#1#{} enhanced cards are scored',
            '{C:inactive}({C:attention}#2#{C:inactive} left)'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sips, card.ability.extra.sips_left } }
    end,
    calculate = function(self, card, context)
        if context.before and not card.getting_sliced then
            for i = 1, #context.full_hand do
                local scoring = false
                for j = 1, #context.scoring_hand do
                    if context.full_hand[i] == context.scoring_hand[j] then
                        scoring = true
                    end
                end
				if not scoring then 
                    local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
					G.E_MANAGER:add_event(Event({
                        trigger = "after",
			            delay = 0.15,
			            func = function()
                            G.play.cards[i]:flip()
                            play_sound('card1', percent)
                            G.play.cards[i]:juice_up(0.3,0.3)
                            G.play.cards[i]:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = 'lemonade'})])
                            return true
                        end,
                    }))
                    delay(0.75)
                    local percent = 0.85 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			        G.E_MANAGER:add_event(Event({
				        trigger = "after",
			            delay = 0.15,
			            func = function()
                            G.play.cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            G.play.cards[i]:juice_up(0.3,0.3)
                            return true
                        end,
                    }))
				end
			end
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.effect ~= "Base" then
                card.ability.extra.sips_left = card.ability.extra.sips_left - 1
                if card.ability.extra.sips_left ~= 0 then
                    return {
                        extra = { message = "Sipped!" },
                        card = card
                    }
                else
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
                        extra = { message = "Gulped!" }
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'chocolate_coin',
    name = 'Chocolate Coin',
    atlas = "add_atlas",
    pos = { x = 3, y = 2 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { money = 8, bite_size = 2 } },
    loc_txt = {
        name = 'Chocolate Coin',
        text = {
            'Earn {C:money}#1#${} at end of',
            'round, {C:money}-#2#${} per reroll.'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.bite_size } }
    end,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then 
            return bonus 
        end
    end,
    calculate = function(self, card, context)
        if context.reroll_shop then
            card.ability.extra.money = card.ability.extra.money - card.ability.extra.bite_size
            if card.ability.extra.money == 0 then
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
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Eaten!'})
                    return true
                end)}))
            else 
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = '-'..card.ability.extra.bite_size..'$', colour = G.C.MONEY})
                    return true
                end)}))
            end
        end
    end
}

SMODS.Joker {
    key = 'inkwell',
    name = 'Inkwell',
    atlas = "add_atlas",
    pos = { x = 4, y = 2 },
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    blueprint_compat = false,
    loc_txt = {
        name = 'Inkwell',
        text = {
            'If {C:attention}1st{} played hand of round contains',
            'a {C:attention}Flush{}, converts cards held in hand',
            'to the first played card\'s {C:attention}suit{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and not card.getting_sliced and G.GAME.current_round.hands_played == 0 then
            if next(context.poker_hands['Flush']) then
                local suit = context.scoring_hand[1].config.card.suit
                for i = 1, #G.hand.cards do
                    local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			        G.E_MANAGER:add_event(Event({
				        trigger = "after",
			            delay = 0.15,
			            func = function()
                            G.hand.cards[i]:flip()
                            play_sound('card1', percent)
                            G.hand.cards[i]:juice_up(0.3,0.3)
                            return true
                        end,
                    }))
                end
                delay(0.2)
                for i = 1, #G.hand.cards do
                    local percent = 0.85 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			        G.E_MANAGER:add_event(Event({
				        trigger = "after",
			            delay = 0.15,
			            func = function()
                            G.hand.cards[i]:change_suit(suit)
                            G.hand.cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            G.hand.cards[i]:juice_up(0.3,0.3)
                            return true
                        end,
                    }))
                end
                return {
                    message = "Recolored!"
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'additional_joker',
    name = 'Additional Joker',
    atlas = "add_atlas",
    pos = { x = 0, y = 3 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { mult_add = 2, chips_add = 25 } },
    loc_txt = {
        name = 'Additional Joker',
        text = {
            'Round\'s first played {C:attention}poker hand{}',
            'gains {C:mult}+#1#{} Mult on {C:attention}odd{} rounds and',
            '{C:chips}+#2#{} Chips on {C:attention}even{} rounds'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_add, card.ability.extra.chips_add } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.cardarea == G.jokers and context.before then
            if G.GAME.current_round.hands_played == 0 then
                if G.GAME.round % 2 == 1 then
                    G.GAME.hands[context.scoring_name].s_mult = G.GAME.hands[context.scoring_name].s_mult + card.ability.extra.mult_add
                    G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].s_mult + G.GAME.hands[context.scoring_name].l_mult*(G.GAME.hands[context.scoring_name].level - 1)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                        play_sound('tarot1')
                        card:juice_up(0.8, 0.5)
                        return true 
                    end }))
                    update_hand_text({delay = 0}, {mult = '+'..card.ability.extra.mult_add, StatusText = true})
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                        play_sound('tarot1')
                        card:juice_up(0.8, 0.5)
                        return true 
                    end }))
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = G.GAME.hands[context.scoring_name].mult})
                else
                    G.GAME.hands[context.scoring_name].s_chips = G.GAME.hands[context.scoring_name].s_chips + card.ability.extra.chips_add
                    G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].s_chips + G.GAME.hands[context.scoring_name].l_chips*(G.GAME.hands[context.scoring_name].level - 1)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                        play_sound('tarot1')
                        card:juice_up(0.8, 0.5)
                        return true 
                    end }))
                    update_hand_text({delay = 0}, {chips = '+'..card.ability.extra.chips_add, StatusText = true})
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                        play_sound('tarot1')
                        card:juice_up(0.8, 0.5)
                        return true 
                    end }))
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {chips = G.GAME.hands[context.scoring_name].chips})
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'cavalier',
    name = 'Cavalier',
    atlas = "add_atlas",
    pos = { x = 1, y = 3 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    config = { extra = { consumables_used = 0, copied_at = 5 } },
    loc_txt = {
        name = 'Cavalier',
        text = {
            'Every {C:attention}#2# consumeables{} used,',
            'create a copy of the most',
            'recently used {C:tarot}Tarot{} or {C:planet}Planet{}',
            '{C:inactive}(Currently {C:attention}#1#{C:inactive}, must have room)'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.consumables_used, card.ability.extra.copied_at } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            card.ability.extra.consumables_used = card.ability.extra.consumables_used + 1
            if card.ability.extra.consumables_used == card.ability.extra.copied_at then
                card.ability.extra.consumables_used = 0
                if not (context.consumeable.ability.set == "Tarot" or context.consumeable.ability.set == "Planet") then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, G.GAME.last_tarot_planet, 'cava')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                            end
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local card = copy_card(context.consumeable)
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                            end
                            return true
                        end
                    }))
                end
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Copied!'})
                    return true
                end)}))
            else
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.consumables_used..'/'..card.ability.extra.copied_at})
                    return true
                end)}))
            end
        end
    end
}

SMODS.Joker {
    key = 'zero_of_NAdes',
    name = '0 of N/Ades',
    atlas = "add_atlas",
    pos = { x = 2, y = 3 },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { charges = 2, increase = 2 } },
    loc_txt = {
        name = '0 of N/Ades',
        text = {
            'The next {C:attention}#1#{} scoring card(s)',
            'are destroyed, increasing by',
            '{C:attention}#2#{} whenever a {C:attention}playing card{} is',
            'added to your deck'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.charges, card.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.playing_card_added and not card.getting_sliced then
            card.ability.extra.charges = card.ability.extra.charges + #context.cards * card.ability.extra.increase
            G.E_MANAGER:add_event(Event({
                func = (function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = '+'..#context.cards * card.ability.extra.increase})
                return true
            end)}))
        end
        if context.destroying_card and not context.blueprint and not (card.ability.extra.charges <= 0) then
            card.ability.extra.charges = card.ability.extra.charges - 1
            return true
        end
    end
}

SMODS.Joker {
    key = 'The_Stars',
    name = 'The Stars',
    atlas = "add_atlas",
    pos = { x = 3, y = 3 },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { planets = 3 } },
    loc_txt = {
        name = 'The Stars',
        text = {
            'When the {C:attention}shop{} is entered,',
            'stock {C:attention}#1#{} {C:planet}Planet{} cards'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.planets } }
    end,
    calculate = function(self, card, context)
        if context.addadd_shop_start then
            Addadd_Funcs.stock_card(card.ability.extra.planets, 'Planet')
        end
    end
}

SMODS.Joker {
    key = 'Certainty',
    name = 'Certainty',
    atlas = "add_atlas",
    pos = { x = 4, y = 3 },
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = { extra = { money_div = 3 } },
    loc_txt = {
        name = 'Certainty',
        text = {
            'When the {C:attention}shop{} is entered,',
            'stock a {C:tarot}Death{} card and lose',
            '{C:attention}1/#1#{} of your current {C:money}money{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_death
        return { vars = { card.ability.extra.money_div } }
    end,
    calculate = function(self, card, context)
        if context.addadd_shop_start then
            Addadd_Funcs.stock_card(1, 'Tarot', nil, 'c_death')
            local nayout = math.floor(G.GAME.dollars/card.ability.extra.money_div) * -1
            ease_dollars(nayout)
			return { 
                message = "-$" .. nayout,
                colour = G.C.MONEY 
            }
        end
    end
}