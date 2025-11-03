SMODS.Atlas({ 
    key = "add_atlas",
    path = "additional_atlas.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "additional_backs",
    path = "additional_backs.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "add_enhancements",
    path = "additional_enhancements.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "add_consumables",
    path = "additional_consumables.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "add_roles",
    path = "additional_roles.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "add_vouchers",
    path = "additional_vouchers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "match_atlas",
    path = "additional_matches.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "additional_blinds",
    path = "additional_blinds.png",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})

SMODS.Atlas({ 
    key = "add_boosters",
    path = "additional_boosters.png",
    px = 71,
    py = 95
})

SMODS.Atlas({ 
    key = "wiz",
    path = "additional_wizard.png",
    px = 71,
    py = 95
})

Addadd_Funcs = {}

NFS.load(SMODS.current_mod.path..'Utils.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalJokers.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalJokersPage2.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalDecks.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalEnhancements.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalConsumeables.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalRoles.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalBoosters.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalBlinds.lua')()
NFS.load(SMODS.current_mod.path..'Additions/AdditionalVouchers.lua')()

