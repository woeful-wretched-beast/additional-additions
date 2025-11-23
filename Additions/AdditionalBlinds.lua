SMODS.Blind {
    key = 'light',
    pos = {y=1},
    atlas = 'additional_blinds',
    boss = {min=3},
    discovered = true,
    boss_colour = HEX('FA9558'),
    loc_txt = {
        name = 'The Light',
        text = {
            'Non-base cards are',
            'drawn face down'
        }
    },
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for k, v in pairs(G.playing_cards) do
            v.ability.wheel_flipped = nil
        end
    end,
    stay_flipped = function(self, area, card)
        if area == G.hand and (card.config.center.set == "Enhanced" or card.seal or card.edition) then
            return true
        end
    end
}

SMODS.Blind {
    key = 'silent',
    pos = {y=2},
    atlas = 'additional_blinds',
    boss = {min=3},
    discovered = true,
    boss_colour = HEX('855791'),
    loc_txt = {
        name = 'The Silent',
        text = {
            'Most common suit is',
            'drawn face down'
        }
    },
    config = { common = {'Spades', 0} },
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for k, v in pairs(G.playing_cards) do
            v.ability.wheel_flipped = nil
        end
    end,
    set_blind = function(self)
        local suits = {}
        for k, card in pairs(G.playing_cards) do
            if not SMODS.has_no_rank(card) then
                suits[card.base.suit] = (suits[card.base.suit] or 0) + 1
            end
        end
        for k, v in pairs(suits) do
            if v > self.config.common[2] then
                self.config.common = {k, v}
            end
        end
    end,
    stay_flipped = function(self, area, card)
        if area == G.hand and (card.config.card.suit == self.config.common[1]) then
            return true
        end
    end
}

SMODS.Blind {
    key = 'bottle',
    pos = {y=3},
    atlas = 'additional_blinds',
    boss = {min=4},
    discovered = true,
    boss_colour = HEX('54A5B3'),
    loc_txt = {
        name = 'The Bottle',
        text = {
            'If hand would overscore,',
            'it instead scores 60%',
            'of blind requirements'
        }
    },
}

SMODS.Blind {
    key = 'wind',
    pos = {y=4},
    atlas = 'additional_blinds',
    boss = {min=2},
    discovered = true,
    boss_colour = HEX('4297EB'),
    loc_txt = {
        name = 'The Wind',
        text = {
            'When discarding,',
            'discard all held',
            'cards'
        }
    },
}

-- Code heavily referenced from Greener Jokers by A Buff Zucchini
-- Said code being by Vitellary 
-- https://github.com/ABuffZucchini/Greener-Jokers
-- I have no clue how I would do this otherwise
local discard_ref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    discard_ref(e, hook)
    if G.GAME.blind and G.GAME.blind.name == 'bl_addadd_wind' and not G.GAME.blind.disabled then
        local held_cards = {}
		for _, v in ipairs(G.hand.cards) do
			if not v.highlighted then
				table.insert(held_cards, v)
			end
		end
        SMODS.calculate_context({ pre_discard = true, full_hand = held_cards, hook = true })
        local destroyed = {}
		for i, v in ipairs(held_cards) do
			v:calculate_seal({ discard = true })
			local effects = {}
			SMODS.calculate_context({ discard = true, other_card = v, full_hand = held_cards, ignore_other_debuff = true }, effects)
            SMODS.trigger_effects(effects)
            for _, eval in pairs(effects) do
				if type(eval) == 'table' then
					for key, eval2 in pairs(eval) do
						if key == 'remove' or (type(eval2) == 'table' and eval2.remove) then 
                            removed = true 
                        end
					end
				end
			end
            if removed then 
				table.insert(destroyed, v)
				if SMODS.shatters(v) then
					v:shatter()
				else
					v:start_dissolve()
				end
			else
                v.ability.discarded = true
				draw_card(G.hand, G.discard, i * 100 / #held_cards, 'down', false, v)
			end
        end
		if #destroyed > 0 then
			SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed })
        end
	end
end