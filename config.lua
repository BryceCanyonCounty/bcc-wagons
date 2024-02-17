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

-- Distance from Wagon to Allow Inventory Access
Config.invDist = 3 -- Default: 3
Config.inventory = {
    -- Buggies
    buggy01 = { slots = 50 },
    buggy02 = { slots = 50 },
    buggy03 = { slots = 50 },
    cart02  = { slots = 50 },
    -- Coaches
    coach3 = { slots = 100 },
    coach4 = { slots = 100 },
    coach5 = { slots = 100 },
    coach6 = { slots = 100 },
    -- Carts
    cart01       = { slots = 200 },
    cart03       = { slots = 200 },
    cart04       = { slots = 200 },
    cart06       = { slots = 200 },
    cart07       = { slots = 200 },
    cart08       = { slots = 200 },
    huntercart01 = { slots = 200 },
    -- Wagons
    supplywagon       = { slots = 400 },
    wagontraveller01x = { slots = 400 },
    wagon03x          = { slots = 400 },
    wagon05x          = { slots = 400 },
    wagon02x          = { slots = 400 },
    wagon04x          = { slots = 400 },
    wagon06x          = { slots = 400 },
    chuckwagon000x    = { slots = 400 },
    chuckwagon002x    = { slots = 400 },
}
-----------------------------------------------------

-- Wagon Shops
Config.shops = {
    valentine = {
        shop = {
            name        = 'Valentine Wagons',               -- Name of Shop on Menu
            prompt      = 'Valentine Wagons',               -- Text Below the Prompt Button
            distance    = 2.0,                              -- Distance from NPC to Get Menu Prompt
            jobsEnabled = false,                            -- Allow Shop Access to Specified Jobs Only
            jobs = {                                        -- Insert Job to limit access - ex. allowedJobs = {{name = 'police', grade = 1},{name = 'doctor', grade = 3}}
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,                             -- Shop uses Open and Closed Hours
                open   = 7,                                 -- Shop Open Time / 24 Hour Clock
                close  = 21                                 -- Shop Close Time / 24 Hour Clock
            }
        },
        blip = {
            show       = true,                              -- Show Blip On Map
            showClosed = true,                              -- Show Blip On Map when Closed
            name       = 'Valentine Wagons',                -- Name of Blip on Map
            sprite     = 1012165077,                        -- Default: 1258184551
            color = {
                open   = 'WHITE',                           -- Shop Open - Default: White - Blip Colors Shown Below
                closed = 'RED',                             -- Shop Closed - Deafault: Red - Blip Colors Shown Below
                job    = 'YELLOW_ORANGE'                    -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
            }
        },
        npc = {
            active   = true,                                -- Turns NPC On / Off
            model    = 's_m_m_coachtaxidriver_01',          -- Model Used for NPC
            coords   = vector3(-383.46, 792.91, 115.81),    -- NPC and Shop Blip Positions
            heading  = 14.37,                               -- NPC Heading
            distance = 100.0                                -- Distance Between Player and Shop for NPC to Spawn
        },
        wagon = {
            coords  = vector3(-392.81, 800.65, 115.86),     -- Wagon Spawn and Return Positions
            heading = 266.14,                               -- Wagon Spawn Heading
            camera  = vector3(-391.07, 794.49, 115.94)      -- Camera Location to View Wagon When In-Menu
        },
        wainwrightBuy = false,                              -- Only Wainwrights can Buy Wagons from this Shop
        wagons = {                                          -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    strawberry = {
        shop = {
            name        = 'Strawberry Wagons',
            prompt      = 'Strawberry Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Strawberry Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(-1831.53, -596.45, 154.48),
            heading  = 277.22,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(-1824.36, -601.47, 154.47),
            heading = 180.8,
            camera  = vector3(-1830.89, -604.33, 154.36),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    vanhorn = {
        shop = {
            name        = 'Van Horn Wagons',
            prompt      = 'Van Horn Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Van Horn Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(2993.25, 783.33, 50.23),
            heading  = 97.4,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(2984.43, 780.76, 50.11),
            heading = 50.9,
            camera  = vector3(2989.72, 785.28, 50.13),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    lemoyne = {
        shop = {
            name        = 'Lemoyne Wagons',
            prompt      = 'Lemoyne Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Lemoyne Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(1219.46, -195.59, 101.29),
            heading  = 295.81,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(1230.39, -198.39, 101.29),
            heading = 255.99,
            camera  = vector3(1227.33, -204.34, 100.89),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    saintdenis = {
        shop = {
            name        = 'Saint Denis Wagons',
            prompt      = 'Saint Denis Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Saint Denis Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(2653.01, -1030.38, 44.87),
            heading  = 145.95,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(2657.36, -1038.59, 45.54),
            heading = 95.3,
            camera  = vector3(2653.01, -1032.47, 45.08),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    blackwater = {
        shop = {
            name        = 'Blackwater Wagons',
            prompt      = 'Blackwater Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Blackwater Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(-876.06, -1374.64, 43.56),
            heading  = 180.44,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(-876.22, -1383.45, 43.48),
            heading = 98.35,
            camera  = vector3(-879.41, -1376.95, 43.58),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    },
    tumbleweed = {
        shop = {
            name        = 'Tumbleweed Wagons',
            prompt      = 'Tumbleweed Wagons',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            show       = true,
            showClosed = true,
            name       = 'Tumbleweed Wagons',
            sprite     = 1012165077,
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 's_m_m_coachtaxidriver_01',
            coords   = vector3(-5539.02, -3021.74, -1.32),
            heading  = 23.06,
            distance = 100.0
        },
        wagon = {
            coords  = vector3(-5547.98, -3020.25, -1.56),
            heading = 39.58,
            camera  = vector3(-5541.83, -3017.31, -1.23),
        },
        wainwrightBuy = false,
        wagons = {
            {
                name  = 'Buggies',
                types = {
                    ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7  },
                    ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10 },
                    ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12 },
                    ['cart02']  = { label = 'Buggy 4', cashPrice = 100, goldPrice = 5  },
                }
            },
            {
                name = 'Coaches',
                types = {
                    ['coach3'] = { label = 'Coach 1', cashPrice = 400, goldPrice = 19 },
                    ['coach4'] = { label = 'Coach 2', cashPrice = 300, goldPrice = 14 },
                    ['coach5'] = { label = 'Coach 3', cashPrice = 350, goldPrice = 17 },
                    ['coach6'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14 },
                }
            },
            {
                name = 'Carts',
                types = {
                    ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22 },
                    ['cart03']       = { label = 'Cart 2',      cashPrice = 450, goldPrice = 22 },
                    ['cart04']       = { label = 'Cart 3',      cashPrice = 550, goldPrice = 26 },
                    ['cart06']       = { label = 'Cart 4',      cashPrice = 650, goldPrice = 31 },
                    ['cart07']       = { label = 'Cart 5',      cashPrice = 400, goldPrice = 19 },
                    ['cart08']       = { label = 'Cart 6',      cashPrice = 400, goldPrice = 19 },
                    ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31 },
                }
            },
            {
                name = 'Wagons',
                types = {
                    ['supplywagon']       = { label = 'Supply Wagon',    cashPrice = 950,  goldPrice = 46 },
                    ['wagontraveller01x'] = { label = 'Travel Wagon',    cashPrice = 1950, goldPrice = 94 },
                    ['wagon03x']          = { label = 'Open Wagon 1',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon05x']          = { label = 'Open Wagon 2',    cashPrice = 1050, goldPrice = 51 },
                    ['wagon02x']          = { label = 'Covered Wagon 1', cashPrice = 1250, goldPrice = 60 },
                    ['wagon04x']          = { label = 'Covered Wagon 2', cashPrice = 1250, goldPrice = 60 },
                    ['wagon06x']          = { label = 'Covered Wagon 3', cashPrice = 1250, goldPrice = 60 },
                    ['chuckwagon000x']    = { label = 'Chuck Wagon 1',   cashPrice = 1500, goldPrice = 73 },
                    ['chuckwagon002x']    = { label = 'Chuck Wagon 2',   cashPrice = 1500, goldPrice = 73 },
                }
            }
        }
    }
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
