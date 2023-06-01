# bcc-wagons

#### Description

Whether you're a hardworking farmer tending to your crops, a family embarking on a scenic countryside picnic, or a successful businessman looking to make an impression, these wagons will revolutionize the way you travel.

#### Features

- Buy and sell wagons through the wagon shops
- Cash and/or gold may be used for payments in the menu
- Individual inventory for owned wagons
- Shop hours may be set individually for each shop or disabled to allow the shop to remain open
- Shop blips are colored and changeable per shop location
- Blips can change color reflecting if shop is open, closed or job locked
- Shop access can be limited by job and jobgrade
- Wagons can be returned at any shop location via prompt
- Give your wagon a special name at purchase time (rename wagon using the menu)
- Set a max number of wagons per player in the config
- Call your selected wagon using the `J` key
- More to come!

#### Commands

- Command `/wagonReturn` to return wagon when away from a shop

#### Configuration

Settings can be changed in the `config.lua` file. Here is an example of one shop:

```lua
    -- Which currancy type is allowed?
    -- 0 = Cash Only
    -- 1 = Gold Only
    -- 2 = Both
    Config.currencyType = 2 -- Default: 2

    Config.shops = {
    valentine = {
        shopName = "Valentine Wagons",                               -- Name of Shop on Menu
        promptName = "Valentine Wagons",                             -- Text Below the Prompt Button
        blipAllowed = true,                                          -- Turns Blips On / Off
        blipName = "Valentine Wagons",                               -- Name of the Blip on the Map
        blipSprite = 1012165077,                                     -- wagon wheel
        blipColorOpen = "WHITE",                                     -- Shop Open - Default: White - Blip Colors Shown Below
        blipColorClosed = "RED",                                     -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipColorJob = "YELLOW_ORANGE",                              -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
        npc = { x = -383.46, y = 792.91, z = 115.81, h = 14.37 },    -- Location for NPC and Shop
        spawn = { x = -392.81, y = 800.65, z = 115.86, h = 266.14 }, -- Wagon Spawn and Return Positions
        wagonCam = { x = -391.07, y = 794.49, z = 115.94 },          -- Camera Location to View Wagon When In-Menu
        distanceShop = 2.0,                                          -- Distance from NPC to Get Menu Prompt
        npcAllowed = true,                                           -- Turns NPCs On / Off
        npcModel = "s_m_m_coachtaxidriver_01",                       -- Sets Model for NPCs
        allowedJobs = {},                                            -- Empty, Everyone Can Use / Insert Job to limit access - ex. "police"
        jobGrade = 0,                                                -- Enter Minimum Rank / Job Grade to Access Shop
        shopHours = false,                                           -- If You Want the Shops to Use Open and Closed Hours
        shopOpen = 7,                                                -- Shop Open Time / 24 Hour Clock
        shopClose = 21,                                              -- Shop Close Time / 24 Hour Clock
        wagons = {                                                   -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
            {
                name  = "Buggies",
                types = {
                    ["buggy01"] = { label = "Buggy 1", cashPrice = 150, goldPrice = 7,  sellPrice = 90  },
                    ["buggy02"] = { label = "Buggy 2", cashPrice = 200, goldPrice = 10, sellPrice = 120 },
                    ["buggy03"] = { label = "Buggy 3", cashPrice = 250, goldPrice = 12, sellPrice = 150 },
                    ["cart02"]  = { label = "Buggy 4", cashPrice = 100, goldPrice = 5,  sellPrice = 60  },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "Coach 1", cashPrice = 400, goldPrice = 19, sellPrice = 240 },
                    ["coach4"] = { label = "Coach 2", cashPrice = 300, goldPrice = 14, sellPrice = 180 },
                    ["coach5"] = { label = "Coach 3", cashPrice = 350, goldPrice = 17, sellPrice = 210 },
                    ["coach6"] = { label = "Coach 4", cashPrice = 300, goldPrice = 14, sellPrice = 180 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"]       = { label = "Cart 1",      cashPrice = 450, goldPrice = 22, sellPrice = 270 },
                    ["cart03"]       = { label = "Cart 2",      cashPrice = 450, goldPrice = 22, sellPrice = 270 },
                    ["cart04"]       = { label = "Cart 3",      cashPrice = 550, goldPrice = 26, sellPrice = 330 },
                    ["cart06"]       = { label = "Cart 4",      cashPrice = 650, goldPrice = 31, sellPrice = 390 },
                    ["cart07"]       = { label = "Cart 5",      cashPrice = 400, goldPrice = 19, sellPrice = 240 },
                    ["cart08"]       = { label = "Cart 6",      cashPrice = 400, goldPrice = 19, sellPrice = 240 },
                    ["huntercart01"] = { label = "Hunter Cart", cashPrice = 650, goldPrice = 31, sellPrice = 390 },
                }
            },
            {
                name = "Wagons",
                types = {
                    ["supplywagon"]       = { label = "Supply Wagon",    cashPrice = 950,  goldPrice = 46, sellPrice = 570  },
                    ["wagontraveller01x"] = { label = "Travel Wagon",    cashPrice = 1950, goldPrice = 94, sellPrice = 1170 },
                    ["wagon03x"]          = { label = "Open Wagon 1",    cashPrice = 1050, goldPrice = 51, sellPrice = 630  },
                    ["wagon05x"]          = { label = "Open Wagon 2",    cashPrice = 1050, goldPrice = 51, sellPrice = 630  },
                    ["wagon02x"]          = { label = "Covered Wagon 1", cashPrice = 1250, goldPrice = 60, sellPrice = 750  },
                    ["wagon04x"]          = { label = "Covered Wagon 2", cashPrice = 1250, goldPrice = 60, sellPrice = 750  },
                    ["wagon06x"]          = { label = "Covered Wagon 3", cashPrice = 1250, goldPrice = 60, sellPrice = 750  },
                    ["chuckwagon000x"]    = { label = "Chuck Wagon 1",   cashPrice = 1500, goldPrice = 73, sellPrice = 900  },
                    ["chuckwagon002x"]    = { label = "Chuck Wagon 2",   cashPrice = 1500, goldPrice = 73, sellPrice = 900  },
                }
            }
        }
    },


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
```

#### Dependencies

- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)

#### Installation

- Ensure that the dependancies are added and started
- Add `bcc-wagons` folder to your resources folder
- Add `ensure bcc-wagons` to your `resources.cfg`
- Run the included database file `wagons.sql`

#### GitHub

- https://github.com/BryceCanyonCounty/bcc-wagons
