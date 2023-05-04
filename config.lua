Config = {}

-- Set Language
Config.defaultlang = "en_lang"

-- Open Wagon Shop Menu
Config.shopKey = 0x760A9C6F --[G]

-- Return Wagon to Shop at Prompt
Config.returnKey = 0xD9D0E1C0 --[spacebar]

-- Limit Number of Wagons per Player
Config.maxWagons = 5 -- Default: 5

-- Number of Items Allowed in Wagon Inventory
Config.invLimit = 200 -- Default: 200

-- Show or Remove Blip when Closed
Config.blipAllowedClosed = true -- If true, will show colored blip when shop is closed

-- Wagon Shops
Config.wagonShops = {
    valentine = {
        shopName = "Valentine Wagons", -- Name of Shop on Menu
        promptName = "Valentine Wagons", -- Text Below the Prompt Button
        blipAllowed = true, -- Turns Blips On / Off
        blipName = "Valentine Wagons", -- Name of the Blip on the Map
        blipSprite = 1012165077, -- wagon wheel
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32", -- Shop Open - Default: White - Blip Colors Shown Below
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10", -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23", -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
        npc = {x = -383.46, y = 792.91, z = 115.81, h = 14.37}, -- Location for NPC and Shop
        spawn = {x = -392.81, y = 800.65, z = 115.86, h = 266.14}, -- Wagon Spawn and Return Positions
        wagonCam = {x = -391.07, y = 794.49, z = 115.94}, -- Camera Location to View Wagon When In-Menu
        distanceShop = 2.0, -- Distance from NPC to Get Menu Prompt
        npcAllowed = true, -- Turns NPCs On / Off
        npcModel = "A_M_M_UniBoatCrew_01", -- Sets Model for NPCs
        allowedJobs = {}, -- Empty, Everyone Can Use / Insert Job to limit access - ex. "police"
        jobGrade = 0, -- Enter Minimum Rank / Job Grade to Access Shop
        shopHours = false, -- If You Want the Shops to Use Open and Closed Hours
        shopOpen = 7, -- Shop Open Time / 24 Hour Clock
        shopClose = 21, -- Shop Close Time / 24 Hour Clock
        wagons = { -- Change ONLY These Values: wagonType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    strawberry = {
        shopName = "Strawberry Wagons",
        promptName = "Strawberry Wagons",
        blipAllowed = true,
        blipName = "Strawberry Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = -1831.53, y = -596.45, z = 154.48, h = 277.22},
        spawn = {x = -1824.36, y = -601.47, z = 154.47, h = 180.8},
        wagonCam = {x = -1830.89, y = -604.33, z = 154.36},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = {
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    vanhorn = {
        shopName = "Van Horn Wagons",
        promptName = "Van Horn Wagons",
        blipAllowed = true,
        blipName = "Van Horn Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = 2993.25, y = 783.33, z = 50.23, h = 97.4},
        spawn = {x = 2984.43, y = 780.76, z = 50.11, h = 50.9},
        wagonCam = {x = 2989.72, y = 785.28, z = 50.13},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    lemoyne = {
        shopName = "Lemoyne Wagons",
        promptName = "Lemoyne Wagons",
        blipAllowed = true,
        blipName = "Lemoyne Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = 1219.46, y = -195.59, z = 101.29, h = 295.81},
        spawn = {x = 1230.39, y = -198.39, z = 101.29, h = 255.99},
        wagonCam = {x = 1227.33, y = -204.34, z = 100.89},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    saintdenis = {
        shopName = "Saint Denis Wagons",
        promptName = "Saint Denis Wagons",
        blipAllowed = true,
        blipName = "Saint Denis Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = 2653.01, y = -1030.38, z = 44.87, h = 145.95},
        spawn = {x = 2657.36, y = -1038.59, z = 45.54, h = 95.3},
        wagonCam = {x = 2653.01, y = -1032.47, z = 45.08},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    blackwater = {
        shopName = "Blackwater Wagons",
        promptName = "Blackwater Wagons",
        blipAllowed = true,
        blipName = "Blackwater Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = -876.06, y = -1374.64, z = 43.56, h = 180.44},
        spawn = {x = -876.22, y = -1383.45, z = 43.48, h = 98.35},
        wagonCam = {x = -879.41, y = -1376.95, z = 43.58},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    },
    tumbleweed = {
        shopName = "Tumbleweed Wagons",
        promptName = "Tumbleweed Wagons",
        blipAllowed = true,
        blipName = "Tumbleweed Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32",
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10",
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23",
        npc = {x = -5539.02, y = -3021.74, z = -1.32, h = 23.06},
        spawn = {x = -5547.98, y = -3020.25, z = -1.56, h = 39.58},
        wagonCam = {x = -5541.83, y = -3017.31, z = -1.23},
        distanceShop = 2.0,
        npcAllowed = true,
        npcModel = "A_M_M_UniBoatCrew_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                wagonType = "Buggies",
                ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Coaches",
                ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Carts",
                ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            },
            {
                wagonType = "Wagons",
                ["huntercart01"]      = { label = "huntercart01",      cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["supplywagon"]       = { label = "supplywagon",       cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon02x"]          = { label = "wagon02x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon03x"]          = { label = "wagon03x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon04x"]          = { label = "wagon04x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon05x"]          = { label = "wagon05x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagon06x"]          = { label = "wagon06x",          cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon000x"]    = { label = "chuckwagon000x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["chuckwagon002x"]    = { label = "chuckwagon002x",    cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                ["wagontraveller01x"] = { label = "wagontraveller01x", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
            }
        }
    }
}

--[[--------BLIP_COLORS----------
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
WHITE         = 'BLIP_MODIFIER_MP_COLOR_32']]
