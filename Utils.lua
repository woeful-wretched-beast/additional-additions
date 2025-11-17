-- resizes the shop without making it wide
function Addadd_Funcs.resize_shop()
    if (#G.shop_jokers.cards > 4) then
        G.shop_jokers.T.w = 4.04*G.CARD_W
    else
        G.shop_jokers.T.w = #G.shop_jokers.cards*1.01*G.CARD_W
    end
    G.shop:recalculate()
end

-- forces the shop into a free reroll
-- mostly just taken from the source code
function Addadd_Funcs.force_reroll()
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1
            for i = #G.shop_jokers.cards,1, -1 do
                local c = G.shop_jokers:remove_card(G.shop_jokers.cards[i])
                c:remove()
                c = nil
            end
            G.shop_jokers.config.card_limit = G.GAME.shop.joker_max 
            if (G.GAME.shop.joker_max > 4) then
                G.shop_jokers.T.w = 4.04*G.CARD_W
            else
                G.shop_jokers.T.w = G.GAME.shop.joker_max*1.01*G.CARD_W
            end
            G.shop:recalculate()
            play_sound('other1')
            for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do 
                local new_shop_card = create_card_for_shop(G.shop_jokers)
                G.shop_jokers:emplace(new_shop_card)
                new_shop_card:juice_up()
            end
            return true
        end }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.CONTROLLER.interrupt.focus = false
                    G.CONTROLLER.locks.shop_reroll = false
                    G.CONTROLLER:recall_cardarea_focus('shop_jokers')
                    for i = 1, #G.jokers.cards do
                        G.jokers.cards[i]:calculate_joker({reroll_shop = true})
                    end
                return true
            end }))
        return true
    end }))
    Addadd_Funcs.resize_shop()
end

-- stocks a consumable or joker
function Addadd_Funcs.stock_card(card_amount, card_set, card_edition, card_key)
    for i = 1, card_amount do
        G.shop_jokers.config.card_limit = #G.shop_jokers.cards + 1
        local stock_card = SMODS.create_card({ set = card_set, area = G.shop_jokers, edition = card_edition, key = card_key })
        for key, sticker in pairs(SMODS.Stickers) do
            stock_card.ability[key] = false
        end
        stock_card:set_cost(stock_card.cost)
        create_shop_card_ui(stock_card)
        G.shop_jokers:emplace(stock_card)
        Addadd_Funcs.resize_shop()
    end
end

-- i'm glad i didnt write my own stock booster/voucher functions before realizing steammodded just has those lol

-- stocks a playing card
function Addadd_Funcs.stock_playing_card(card_amount, card_suit, card_rank, card_enhancement, card_seal, card_edition)
    for i = 1, card_amount do
        G.shop_jokers.config.card_limit = #G.shop_jokers.cards + 1
        local stock_card = create_playing_card({ area = G.shop_jokers, center = card_enhancement, suit = card_suit, rank = card_rank, stocked = true })
        stock_card:set_seal(card_seal, false, true)
        stock_card:set_edition(card_edition, true)
        create_shop_card_ui(stock_card)
        G.shop_jokers:emplace(stock_card)
        Addadd_Funcs.resize_shop()
    end
end

-- stocks a copy of an existing playing card
function Addadd_Funcs.stock_playing_card_copy(copied_card)
    G.shop_jokers.config.card_limit = #G.shop_jokers.cards + 1
    local stock_card = copy_card(copied_card, nil, nil, G.playing_card)
    create_shop_card_ui(stock_card)
    G.shop_jokers:emplace(stock_card)
    Addadd_Funcs.resize_shop()
end