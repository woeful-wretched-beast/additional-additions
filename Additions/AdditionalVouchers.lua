SMODS.Voucher {
    key = 'bexpansion',
    atlas = 'add_vouchers', 
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    requires = {},
    loc_txt = {
        name = 'Bonus Expansion',
        text = {
            '{C:role}Role{} cards can appear',
            'in the shop'
        }
    },
    config = { extra = { rate = 5 } },
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.role_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}

SMODS.Voucher {
    key = 'coven_dlc',
    atlas = 'add_vouchers', 
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    requires = { 'v_addadd_bexpansion' },
    loc_txt = {
        name = 'Coven DLC',
        text = {
            'Up to {C:attention}2{} {C:role}Role{} cards',
            'can be bought',
            'without room'
        }
    },
}

local buy_space_ref = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == "Role" and next(SMODS.find_card("v_addadd_coven_dlc")) then
        if (#G.consumeables.cards) < G.consumeables.config.card_limit + 2 then
            return true
        end
    end
    return buy_space_ref(card)
end

SMODS.ConsumableType {
    key = "matchbox_type",
    primary_colour = HEX('DE4D31'),
    secondary_colour = HEX('DE4D31'),
    loc_txt = {
        name = 'Matchbox',
        collection = 'Matchboxes',
        text = {
            '{C:red}Destroy{} all copies of',
            'a random {C:attention}playing card{}',
            'in deck'
        },
    },
    no_collection = true,
    collection_rows = {1, 1},
    shop_rate = 0,
    default = 'c_addadd_Matchbox',
}

SMODS.Consumable {
    key = "Matchbox",
    set = "matchbox_type",
    atlas = "match_atlas",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    cost = 1,
    loc_txt = {
        name = "Matchbox",
        text = {
            '{C:red}Destroy{} all copies of',
            'the {C:attention}#2#{} of {V:1}#1#{}',
            'in deck',
            '{s:0.8}card is randomly chosen{}'
        },
    },
    config = { extra = { suit = 'Spades', rank = 'Ace', reroll_cost = 1, reroll_increase = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.suit, card.ability.extra.rank, colours = {G.C.SUITS[card.ability.extra.suit]} } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if G.playing_cards then
            local torchable_cards = {}
            for k, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(v) then
                    torchable_cards[#torchable_cards+1] = v
                end
            end
            if torchable_cards[1] then 
                local victim = pseudorandom_element(torchable_cards, pseudoseed('burn the witch!!!'..G.GAME.round_resets.ante))
                card.ability.extra.suit = victim.base.suit
                card.ability.extra.rank = victim.base.value
            end
        end
    end,
    can_reroll_matchbox = function(self, card)
        return G.GAME.dollars >= card.ability.extra.reroll_cost 
    end,
    reroll_matchbox = function(self, card)
        ease_dollars(-card.ability.extra.reroll_cost)
        card.ability.extra.reroll_cost = card.ability.extra.reroll_cost + card.ability.extra.reroll_increase
        card.config.center.set_ability(nil, card)
        card:juice_up()
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit(card.ability.extra.suit) and v.base.value == card.ability.extra.rank then
                SMODS.destroy_cards(v)
            end
        end
    end,
    set_sprites = function(self, card, front)
        G.suit_display = Sprite(0, 0, 71, 95, G.ASSET_ATLAS[card.config.center.atlas], {x = 3, y = 3})
        G.rank_display = Sprite(0, 0, 71, 95, G.ASSET_ATLAS[card.config.center.atlas], {x = 4, y = 3})
    end,
    set_card_type_badge = function(self, card, badges)
        badges = {}
    end
}

SMODS.DrawStep{
    key = 'addadd_Matchbox',
    order = 33,
    func = function(card, layer)
        if not G.suit_display then 
            return nil 
        end
        if card.config.center.key == 'c_addadd_Matchbox' then
            G.suit_display.role.draw_major = card
            G.rank_display.role.draw_major = card
            local soot = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
            local runk = {
                {'Ace', '2', '3', '4', '5'},
                {'6', '7', '8', '9', '10'},
                {'Jack', 'Queen', 'King'}
            }
            local display_suit = {x = 3, y = 3}
            local display_rank = {x = 4, y = 3}
            if card.ability then
                for i = 1, #soot do
                    if card.ability.extra.suit == soot[i] then
                        display_suit.x = i
                        display_suit.y = 0
                    end
                end
                for i = 1, #runk do
                    for j, rank in ipairs(runk[i]) do
                        if card.ability.extra.rank == rank then
                            display_rank.x = j-1
                            display_rank.y = i
                        end
                    end
                end
            end
            G.suit_display:set_sprite_pos(display_suit)
            G.suit_display:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.rank_display:set_sprite_pos(display_rank)
            G.rank_display:draw_shader('dissolve', nil, nil, nil, card.children.center)
        end
    end,
    conditions = { facing = 'front' }
}

SMODS.Voucher {
    key = 'torch',
    atlas = 'add_vouchers', 
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    requires = {},
    loc_txt = {
        name = 'Torch',
        text = {
            '{C:matchbox_type}Matchboxes{}',
            'can appear',
            'in the shop'
        }
    },
    config = { extra = { rate = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_addadd_Matchbox
        return 
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.matchbox_type_rate = card.ability.extra.rate
                return true
            end
        }))
    end
}

SMODS.Voucher {
    key = 'hellfire',
    atlas = 'add_vouchers', 
    pos = { x = 3, y = 0 },
    unlocked = true,
    discovered = true,
    requires = { 'v_addadd_torch' },
    loc_txt = {
        name = 'Hellfire',
        text = {
            '{C:matchbox_type}Matchboxes{} can',
            'have which card',
            'they destroy',
            '{C:green}rerolled{}'
        }
    }
}

local use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local t = use_and_sell_buttons_ref(card)
    if card.ability.set == "matchbox_type" and next(SMODS.find_card("v_addadd_hellfire")) then
        reroll_button = {
        n=G.UIT.R, config={align = 'tm'}, 
        nodes={
            n=G.UIT.C, config={align = "tm"}, 
                nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "cm", maxw = 1, padding = 0.1, r=0.08, minw = 1, minh = 0.2, maxh = 0.2, hover = true, shadow = true, colour = G.C.GREEN, one_press = false, button = 'reroll_matchbox', func = 'can_reroll_matchbox'}, 
                    nodes={
                        {n=G.UIT.R, config={align = "cm"}, 
                        nodes={
                            {n=G.UIT.B, config = {w=0.25,h=0.2}},
                            {n=G.UIT.T, config={text = "REROLL", align='cm',colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}},
                        }},
                        {n=G.UIT.R, config={align = "tm"}, 
                        nodes={
                            {n=G.UIT.T, config={text = localize('$'), align = 'cm', colour = G.C.WHITE, scale = 0.3, shadow = true}},
                            {n=G.UIT.T, config={ref_table = card.ability.extra, ref_value = 'reroll_cost', align = 'cm', colour = G.C.WHITE, scale = 0.4, shadow = true}},
                        }},
                    }},
                }
            },
        }
        t.nodes[1].nodes[1].nodes[1].nodes[1].config.maxh = 0.5
        t.nodes[1].nodes[1].nodes[1].nodes[1].config.align = 'lm'
        t.nodes[1].nodes[1].nodes[1].nodes[1].nodes[1].config.h = 0.3
        t.nodes[1].nodes[2].nodes[1].nodes[1].config.minh = 0.4
		t.nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].config.h = 0.4
        table.insert(t.nodes[1].nodes, reroll_button.nodes)
    end
    return t
end

G.FUNCS.can_reroll_matchbox = function(e)
    local card = e.config.ref_table
    if card.config.center.can_reroll_matchbox(nil, card) then 
        e.config.colour = G.C.GREEN
        e.config.button = 'reroll_matchbox'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.reroll_matchbox = function(e)
    local card = e.config.ref_table
    card.config.center.reroll_matchbox(nil, card)
end
