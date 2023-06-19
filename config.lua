Config = {}

-- Set Language
Config.defaultlang = "en_lang"
-----------------------------------------------------

Config.keys = {
    shop = 0x760A9C6F, --[G] Open Wagon Shop Menu
    ret  = 0xD9D0E1C0  --[spacebar] Return Wagon to Shop at Prompt
}
-----------------------------------------------------

-- Limit Number of Wagons per Player
Config.maxWagons = 5 -- Default: 5
-----------------------------------------------------

-- Can Players Call Their Selected Wagon? (Key: J)
Config.callAllowed = true -- Default: true / Set to false to Disable
-----------------------------------------------------

-- Sell Price is 60% of cashPrice (shown below)
Config.sellPrice = 0.60 -- Default: 0.60
-----------------------------------------------------

-- Which currancy type is allowed?
-- 0 = Cash Only
-- 1 = Gold Only
-- 2 = Both
Config.currencyType = 2 -- Default: 2
-----------------------------------------------------

-- Show or Remove Blip when Closed
Config.blipOnClosed = true -- If true, will show colored blip when shop is closed
-----------------------------------------------------

-- Inventory Limit per Wagon Model
Config.inventory = {
    -- Buggies
    buggy01 = { invLimit = 50 },
    buggy02 = { invLimit = 50 },
    buggy03 = { invLimit = 50 },
    cart02  = { invLimit = 50 },
    -- Coaches
    coach3 = { invLimit = 100 },
    coach4 = { invLimit = 100 },
    coach5 = { invLimit = 100 },
    coach6 = { invLimit = 100 },
    -- Carts
    cart01       = { invLimit = 200 },
    cart03       = { invLimit = 200 },
    cart04       = { invLimit = 200 },
    cart06       = { invLimit = 200 },
    cart07       = { invLimit = 200 },
    cart08       = { invLimit = 200 },
    huntercart01 = { invLimit = 200 },
    -- Wagons
    supplywagon       = { invLimit = 400 },
    wagontraveller01x = { invLimit = 400 },
    wagon03x          = { invLimit = 400 },
    wagon05x          = { invLimit = 400 },
    wagon02x          = { invLimit = 400 },
    wagon04x          = { invLimit = 400 },
    wagon06x          = { invLimit = 400 },
    chuckwagon000x    = { invLimit = 400 },
    chuckwagon002x    = { invLimit = 400 },
}
-----------------------------------------------------

-- Wagon Shops
Config.shops = {
    valentine = {
        shopName = "Valentine Wagons", -- Name of Shop on Menu
        promptName = "Valentine Wagons", -- Text Below the Prompt Button
        blipOn = true, -- Turns Blips On / Off
        blipName = "Valentine Wagons", -- Name of the Blip on the Map
        blipSprite = 1012165077, -- wagon wheel
        blipColorOpen = "WHITE", -- Shop Open - Default: White - Blip Colors Shown Below
        blipColorClosed = "RED", -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipColorJob = "YELLOW_ORANGE", -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
        npc = { x = -383.46, y = 792.91, z = 115.81, h = 14.37 }, -- Location for NPC and Shop
        spawn = { x = -392.81, y = 800.65, z = 115.86, h = 266.14 }, -- Wagon Spawn and Return Positions
        wagonCam = { x = -391.07, y = 794.49, z = 115.94 }, -- Camera Location to View Wagon When In-Menu
        nDistance = 100.0, -- Distance from Shop for NPC to Spawn
        sDistance = 2.0, -- Distance from NPC to Get Menu Prompt
        npcOn = true, -- Turns NPCs On / Off
        npcModel = "s_m_m_coachtaxidriver_01", -- Sets Model for NPCs
        allowedJobs = {}, -- Empty, Everyone Can Use / Insert Job to limit access - ex. "police"
        jobGrade = 0, -- Enter Minimum Rank / Job Grade to Access Shop
        shopHours = false, -- If You Want the Shops to Use Open and Closed Hours
        shopOpen = 7, -- Shop Open Time / 24 Hour Clock
        shopClose = 21, -- Shop Close Time / 24 Hour Clock
        wagons = { -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    strawberry = {
        shopName = "Strawberry Wagons",
        promptName = "Strawberry Wagons",
        blipOn = true,
        blipName = "Strawberry Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = -1831.53, y = -596.45, z = 154.48, h = 277.22 },
        spawn = { x = -1824.36, y = -601.47, z = 154.47, h = 180.8 },
        wagonCam = { x = -1830.89, y = -604.33, z = 154.36 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = {
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    vanhorn = {
        shopName = "Van Horn Wagons",
        promptName = "Van Horn Wagons",
        blipOn = true,
        blipName = "Van Horn Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = 2993.25, y = 783.33, z = 50.23, h = 97.4 },
        spawn = { x = 2984.43, y = 780.76, z = 50.11, h = 50.9 },
        wagonCam = { x = 2989.72, y = 785.28, z = 50.13 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    lemoyne = {
        shopName = "Lemoyne Wagons",
        promptName = "Lemoyne Wagons",
        blipOn = true,
        blipName = "Lemoyne Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = 1219.46, y = -195.59, z = 101.29, h = 295.81 },
        spawn = { x = 1230.39, y = -198.39, z = 101.29, h = 255.99 },
        wagonCam = { x = 1227.33, y = -204.34, z = 100.89 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    saintdenis = {
        shopName = "Saint Denis Wagons",
        promptName = "Saint Denis Wagons",
        blipOn = true,
        blipName = "Saint Denis Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = 2653.01, y = -1030.38, z = 44.87, h = 145.95 },
        spawn = { x = 2657.36, y = -1038.59, z = 45.54, h = 95.3 },
        wagonCam = { x = 2653.01, y = -1032.47, z = 45.08 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    blackwater = {
        shopName = "Blackwater Wagons",
        promptName = "Blackwater Wagons",
        blipOn = true,
        blipName = "Blackwater Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = -876.06, y = -1374.64, z = 43.56, h = 180.44 },
        spawn = { x = -876.22, y = -1383.45, z = 43.48, h = 98.35 },
        wagonCam = { x = -879.41, y = -1376.95, z = 43.58 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    tumbleweed = {
        shopName = "Tumbleweed Wagons",
        promptName = "Tumbleweed Wagons",
        blipOn = true,
        blipName = "Tumbleweed Wagons",
        blipSprite = 1012165077,
        blipColorOpen = "WHITE",
        blipColorClosed = "RED",
        blipColorJob = "YELLOW_ORANGE",
        npc = { x = -5539.02, y = -3021.74, z = -1.32, h = 23.06 },
        spawn = { x = -5547.98, y = -3020.25, z = -1.56, h = 39.58 },
        wagonCam = { x = -5541.83, y = -3017.31, z = -1.23 },
        nDistance = 100.0,
        sDistance = 2.0,
        npcOn = true,
        npcModel = "s_m_m_coachtaxidriver_01",
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        wagons = { -- Change ONLY These Values: boatType, label, cashPrice, goldPrice and sellPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46 },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51 },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60 },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60 },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60 },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73 },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    }
}
-----------------------------------------------------

Config.BlipColors = {
    LIGHT_BLUE    = "BLIP_MODIFIER_MP_COLOR_1",
    DARK_RED      = "BLIP_MODIFIER_MP_COLOR_2",
    PURPLE        = "BLIP_MODIFIER_MP_COLOR_3",
    ORANGE        = "BLIP_MODIFIER_MP_COLOR_4",
    TEAL          = "BLIP_MODIFIER_MP_COLOR_5",
    LIGHT_YELLOW  = "BLIP_MODIFIER_MP_COLOR_6",
    PINK          = "BLIP_MODIFIER_MP_COLOR_7",
    GREEN         = "BLIP_MODIFIER_MP_COLOR_8",
    DARK_TEAL     = "BLIP_MODIFIER_MP_COLOR_9",
    RED           = "BLIP_MODIFIER_MP_COLOR_10",
    LIGHT_GREEN   = "BLIP_MODIFIER_MP_COLOR_11",
    TEAL2         = "BLIP_MODIFIER_MP_COLOR_12",
    BLUE          = "BLIP_MODIFIER_MP_COLOR_13",
    DARK_PUPLE    = "BLIP_MODIFIER_MP_COLOR_14",
    DARK_PINK     = "BLIP_MODIFIER_MP_COLOR_15",
    DARK_DARK_RED = "BLIP_MODIFIER_MP_COLOR_16",
    GRAY          = "BLIP_MODIFIER_MP_COLOR_17",
    PINKISH       = "BLIP_MODIFIER_MP_COLOR_18",
    YELLOW_GREEN  = "BLIP_MODIFIER_MP_COLOR_19",
    DARK_GREEN    = "BLIP_MODIFIER_MP_COLOR_20",
    BRIGHT_BLUE   = "BLIP_MODIFIER_MP_COLOR_21",
    BRIGHT_PURPLE = "BLIP_MODIFIER_MP_COLOR_22",
    YELLOW_ORANGE = "BLIP_MODIFIER_MP_COLOR_23",
    BLUE2         = "BLIP_MODIFIER_MP_COLOR_24",
    TEAL3         = "BLIP_MODIFIER_MP_COLOR_25",
    TAN           = "BLIP_MODIFIER_MP_COLOR_26",
    OFF_WHITE     = "BLIP_MODIFIER_MP_COLOR_27",
    LIGHT_YELLOW2 = "BLIP_MODIFIER_MP_COLOR_28",
    LIGHT_PINK    = "BLIP_MODIFIER_MP_COLOR_29",
    LIGHT_RED     = "BLIP_MODIFIER_MP_COLOR_30",
    LIGHT_YELLOW3 = "BLIP_MODIFIER_MP_COLOR_31",
    WHITE         = "BLIP_MODIFIER_MP_COLOR_32"
}
