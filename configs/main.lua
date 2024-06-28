Config = {}

-- Set Language
Config.defaultlang = 'en_lang'
-----------------------------------------------------

-- Which currancy type is allowed?
-- 0 = Cash Only
-- 1 = Gold Only
-- 2 = Both
Config.currencyType = 2 -- Default: 2
-----------------------------------------------------

Config.keys = {
    shop        = 0x760A9C6F, -- [G] Open Wagon Shop Menu
    ret         = 0xD9D0E1C0, -- [spacebar] Return Wagon at Shop
    call        = 0xF3830D8E, -- [J] Call Selected Wagon
    inv         = 0xD8F73058, -- [U] Open Wagon Inventory
    targetRet   = 0x760A9C6F, -- [G] Target Menu Wagon Return
    targetTrade = 0x620A6C5E, -- [V] Target Menu Start Wagon Trade
    trade       = 0x27D1C284, -- [R] Complete Wagon Trade
    loot        = 0x760A9C6F, -- [G] Loot Wagon
}
-----------------------------------------------------

-- Change / Translate Wagons Commands
Config.commands = {
    wagonEnter  = 'wagonEnter', -- Enter Wagon if Unable to Access
    wagonReturn = 'wagonReturn' -- Return Wagon to Shop if 'returnEnabled' is true
}
-----------------------------------------------------

-- Sell Price is 60% of cashPrice (shown below)
Config.sellPrice = 0.60 -- Default: 0.60
-----------------------------------------------------

-- Max Number of Wagons per Player
Config.maxPlayerWagons = 5      -- Default: 5
Config.maxWainwrightWagons = 10 -- Default: 10
-----------------------------------------------------

-- Players Can Remote Call and Return Their Wagon
Config.callEnabled = true -- Default: true / Set to false to Spawn Wagon from Menu Only
Config.returnEnabled = true -- Defauly: true / Set to false to Return at Wagon Dealer Only
Config.callDist = 100 -- Default: 100 / Distance from Wagon to Call for Respawn
-----------------------------------------------------

-- Places Wagon Name Above Wagon When Wagon is Empty
Config.wagonTag = true --Default: true / Set to false to disable
Config.tagDistance = 15 -- Default: 15 / Distance from Wagon to Show Tag
-----------------------------------------------------

-- Set a Blip on your Spawned Wagon
Config.wagonBlip = true --Default: true / Set to false to disable
Config.wagonBlipSprite = 'blip_mp_player_wagon' -- Default: 'blip_mp_player_wagon'
-----------------------------------------------------

-- Distance from Wagon to Allow Target Prompts(right-click)
Config.targetDist = 5 -- Default: 5
-----------------------------------------------------

-- Set Player in Wagon on Spawn from Menu
Config.seated = true -- Default: true / Set to false to have Player Walk to Wagon
-----------------------------------------------------

-- Wainwright Job
Config.wainwrightOnly = false -- *Not Currently Used*
Config.wainwrightJob = {
    { name = 'wainwright', grade = 0 },
}
-----------------------------------------------------

Config.inventory = {
    distance = 3,     -- Default: 3 / Distance from Wagon to Allow Inventory Access
    shared   = false, -- Default: false / Set to true to Share with ALL Players (Allows Looting)
    weapons  = true   -- Default: true / Allow Weapons in Inventory
}

-----------------------------------------------------

Config.BlipColors = {
    LIGHT_BLUE    = 'BLIP_MODIFIER_MP_COLOR_1',
    DARK_RED      = 'BLIP_MODIFIER_MP_COLOR_2',
    PURPLE        = 'BLIP_MODIFIER_MP_COLOR_3',
    ORANGE        = 'BLIP_MODIFIER_MP_COLOR_4',
    TEAL          = 'BLIP_MODIFIER_MP_COLOR_5',
    LIGHT_YELLOW  = 'BLIP_MODIFIER_MP_COLOR_6',
    PINK          = 'BLIP_MODIFIER_MP_COLOR_7',
    GREEN         = 'BLIP_MODIFIER_MP_COLOR_8',
    DARK_TEAL     = 'BLIP_MODIFIER_MP_COLOR_9',
    RED           = 'BLIP_MODIFIER_MP_COLOR_10',
    LIGHT_GREEN   = 'BLIP_MODIFIER_MP_COLOR_11',
    TEAL2         = 'BLIP_MODIFIER_MP_COLOR_12',
    BLUE          = 'BLIP_MODIFIER_MP_COLOR_13',
    DARK_PUPLE    = 'BLIP_MODIFIER_MP_COLOR_14',
    DARK_PINK     = 'BLIP_MODIFIER_MP_COLOR_15',
    DARK_DARK_RED = 'BLIP_MODIFIER_MP_COLOR_16',
    GRAY          = 'BLIP_MODIFIER_MP_COLOR_17',
    PINKISH       = 'BLIP_MODIFIER_MP_COLOR_18',
    YELLOW_GREEN  = 'BLIP_MODIFIER_MP_COLOR_19',
    DARK_GREEN    = 'BLIP_MODIFIER_MP_COLOR_20',
    BRIGHT_BLUE   = 'BLIP_MODIFIER_MP_COLOR_21',
    BRIGHT_PURPLE = 'BLIP_MODIFIER_MP_COLOR_22',
    YELLOW_ORANGE = 'BLIP_MODIFIER_MP_COLOR_23',
    BLUE2         = 'BLIP_MODIFIER_MP_COLOR_24',
    TEAL3         = 'BLIP_MODIFIER_MP_COLOR_25',
    TAN           = 'BLIP_MODIFIER_MP_COLOR_26',
    OFF_WHITE     = 'BLIP_MODIFIER_MP_COLOR_27',
    LIGHT_YELLOW2 = 'BLIP_MODIFIER_MP_COLOR_28',
    LIGHT_PINK    = 'BLIP_MODIFIER_MP_COLOR_29',
    LIGHT_RED     = 'BLIP_MODIFIER_MP_COLOR_30',
    LIGHT_YELLOW3 = 'BLIP_MODIFIER_MP_COLOR_31',
    WHITE         = 'BLIP_MODIFIER_MP_COLOR_32'
}
