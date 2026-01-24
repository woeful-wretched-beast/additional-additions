SMODS.Consumable {
    key = "life",
    set = "Spectral",
    atlas = "add_consumables",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 4,
    loc_txt = {
        name = "Life",
        text = {
            'Enhance {C:attention}all held{}',
            'unenhanced cards',
            'to a single random',
            'enhancement'
        },
    },
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        local enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'life'})
        G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].ability.effect == 'Base' then 
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        play_sound("card1", percent)
                        G.hand.cards[i]:flip()
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true 
                    end,
                }))
                G.hand.cards[i]:set_ability(G.P_CENTERS[enhancement], nil, true)
            end
        end
        for i = 1, #G.hand.cards do
            percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    if G.hand.cards[i].facing == "back" then
                        play_sound("tarot2", percent)
                        G.hand.cards[i]:flip()
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                    end
                    return true 
                end,
            }))
        end
    end
}

SMODS.Consumable {
    key = "fortitude",
    set = "Tarot",
    atlas = "add_consumables",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "Fortitude",
        text = {
            'Enhance {C:attention}1{} selected card',
            'into a {C:attention}Bronze Card{}'
        },
    },
    config = { mod_conv = 'm_addadd_bronze', max_highlighted = 1},
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.m_addadd_bronze
        return { vars = { self.config.max_highlighted, localize{type = name_text, set = 'Enhanced', key = self.config.mod_conv} } }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge("Minchiate Tarot", G.C.SECONDARY_SET.Tarot, nil, 1.2 )
    end,
}

SMODS.Consumable {
    key = "time",
    set = "Tarot",
    atlas = "add_consumables",
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 3,
    loc_txt = {
        name = "Time",
        text = {
            'Enhance {C:attention}1{} selected card',
            'into a {C:attention}Tin Card{}'
        },
    },
    config = { mod_conv = 'm_addadd_tin', max_highlighted = 1},
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.m_addadd_tin
        return { vars = { self.config.max_highlighted, localize{type = name_text, set = 'Enhanced', key = self.config.mod_conv} } }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges+1] = create_badge("Minchiate Tarot", G.C.SECONDARY_SET.Tarot, nil, 1.2 )
    end,
}