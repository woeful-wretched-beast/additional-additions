SMODS.Back {
    name = "Additional Deck",
    key = "additional_deck",
    atlas = "additional_backs",
    pos = {x = 0, y = 0},
    config = { },
    loc_txt = {
        name = "Additional Deck",
        text = {

            '{C:role}Additional Additions{}',
            'jokers are',
            '{C:green}more common{}'
        },
    }
}

SMODS.Back {
    name = "Steady Deck",
    key = "steady_deck",
    atlas = "additional_backs",
    pos = {x = 1, y = 0},
    config = { ante_scaling = 0.5, extra = { win_ante = 3 } },
    loc_txt = {
        name = "Steady Deck",
        text = {

            '{C:attention}+#2# antes{} to win,',
            '{C:green}X#1#{} base Blind size,',
            'start at {C:attention}ante 0{}'
        },
    },
    loc_vars = function(self)
		return { vars = { self.config.ante_scaling, self.config.extra.win_ante } }
	end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.win_ante = G.GAME.win_ante + self.config.extra.win_ante
                ease_ante(-1)
                G.GAME.round_resets.blind_ante = 0
                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Bejeweled Deck",
    key = "bejeweled_deck",
    atlas = "additional_backs",
    pos = {x = 2, y = 0},
    config = { ante_scaling = 1.5 },
    loc_txt = {
        name = "Bejeweled Deck",
        text = {
            '{C:spades}Spade{} {C:attention}Face Cards{} are {C:enhanced,T:m_addadd_tin}Tin{}',
            '{C:hearts}Heart{} {C:attention}Face Cards{} are {C:enhanced,T:m_steel}Steel{}',
            '{C:clubs}Club{} {C:attention}Face Cards{} are {C:enhanced,T:m_addadd_bronze}Bronze{}',
            '{C:diamonds}Diamond{} {C:attention}Face Cards{} are {C:enhanced,T:m_gold}Gold{}',
            '{C:red}X1.5{} base Blind size'
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i]:is_face() then
                        if G.playing_cards[i].config.card.suit == "Spades" then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_addadd_tin)
                        elseif G.playing_cards[i].config.card.suit == "Hearts" then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_steel)
                        elseif G.playing_cards[i].config.card.suit == "Clubs" then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_addadd_bronze)
                        elseif G.playing_cards[i].config.card.suit == "Diamonds" then
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_gold)
                        else
                            G.playing_cards[i]:set_ability(G.P_CENTERS.m_glass)
                        end
                    end
                end
                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Paisley Deck",
    key = "paisley_deck",
    atlas = "additional_backs",
    pos = {x = 3, y = 0},
    loc_txt = {
        name = "Paisley Deck",
        text = {
            '{C:attention}2s{} through {C:attention}Kings{} alternate',
            'Suits, {C:attention}Aces{} are {C:enhanced,T:m_wild}Wild Cards{},',
            '{C:planet}Flush House{} base value',
            'is {C:red}decreased{}'
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    local card_id = G.playing_cards[i]:get_id()
                    if card_id == 2 or card_id == 6 or card_id == 10 then
                        G.playing_cards[i]:change_suit("Spades")
                    elseif card_id == 3 or card_id == 7 or card_id == 11 then
                        G.playing_cards[i]:change_suit("Hearts")
                    elseif card_id == 4 or card_id == 8 or card_id == 12 then
                        G.playing_cards[i]:change_suit("Clubs")
                    elseif card_id == 5 or card_id == 9 or card_id == 13 then
                        G.playing_cards[i]:change_suit("Diamonds")
                    else
                        G.playing_cards[i]:set_ability(G.P_CENTERS.m_wild)
                    end
                end
                G.GAME.hands["Flush House"].s_mult = 6
                G.GAME.hands["Flush House"].s_chips = 60
                G.GAME.hands["Flush House"].mult = 6
                G.GAME.hands["Flush House"].chips = 60
                --G.GAME.hands["Flush House"].l_mult = 4
                --G.GAME.hands["Flush House"].l_chips = 40
                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Dragon Deck",
    key = "dragon_deck",
    atlas = "additional_backs",
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "Dragon Deck",
        text = {
            'Start run with',
            '{C:attention,T:v_magic_trick}#1#{},',
            '{C:enhanced,T:v_illusion}#2#{}, and',
            '{C:matchbox_type,T:v_addadd_torch}#3#{}'
        },
    },
    config = { vouchers = { 'v_magic_trick', 'v_illusion', 'v_addadd_torch' } },
    loc_vars = function(self, info_queue, back)
        return {
            vars = { 
                localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
                localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' },
                localize { type = 'name_text', key = self.config.vouchers[3], set = 'Voucher' }
            }
        }
    end,
}

SMODS.Back {
    name = "Corporate Deck",
    key = "corporate_deck",
    atlas = "additional_backs",
    pos = {x = 5, y = 0},
    loc_txt = {
        name = "Corporate Deck",
        text = {
            'Start run with',
            '{C:role,T:v_addadd_bexpansion}#1#{},',
            '{C:attention,T:v_reroll_surplus}#2#{}, and {C:attention}1{}',
            'copy of {C:role,T:c_addadd_executive}#3#{}'
        },
    },
    config = { vouchers = { 'v_addadd_bexpansion', 'v_reroll_surplus' }, consumables = { 'c_addadd_executive' } },
    loc_vars = function(self, info_queue, back)
        return {
            vars = { 
                localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
                localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' },
                localize { type = 'name_text', key = self.config.consumables[1], set = 'Role' }
            }
        }
    end,
}

SMODS.Back {
    name = "irradiateddeck",
    key = "irradiated_deck",
    atlas = "additional_backs",
    pos = {x = 0, y = 1},
    config = {  },
    loc_txt = {
        name = "Irradiated Deck",
        text = {

            '{C:attention}+1{} voucher slot,',
            '{C:attention}+1{} booster slot,',
            'reroll cost increase',
            'is {C:red}doubled{}'
        },
    },
    loc_vars = function(self)
		return { vars = {  } }
	end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(1)
                SMODS.change_booster_limit(1)
                return true
            end
        }))
    end
}