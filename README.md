# Wagons

#### Description

This is a wagons script for RedM servers using the [VORP framework](https://github.com/VORPCORE). Wagons can be bought and sold through shops. There are 7 shops configured, more shop locations may be added using the `config.lua` file.

#### Features

- Buy and sell wagons through the wagon shops
- Cash or gold may be used for payments in the menu
- Individual inventory for owned wagons
- Shop hours may be set individually for each shop or disabled to allow the shop to remain open
- Shop blips are colored and changeable per shop location
- Blips can change color reflecting if shop is open, closed or job locked
- Shop access can be limited by job and jobgrade
- Wagons can be returned at any shop location via prompt
- Give your wagon a special name at purchase time (rename wagon using the menu)
- Set a max number of wagons per player in the config
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

    valentine = {
        shopName = "Valentine Wagons", -- Name of Shop on Menu
        promptName = "Valentine Wagons", -- Text Below the Prompt Button
        blipAllowed = true, -- Turns Blips On / Off
        blipName = "Valentine Wagons", -- Name of the Blip on the Map
        blipSprite = 1012165077, -- wagon wheel
        blipColorOpen = "WHITE", -- Shop Open - Default: White - Blip Colors Shown Below
        blipColorClosed = "RED", -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipColorJob = "YELLOW_ORANGE", -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
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
                name = "Buggies",
                types = {
                    ["buggy01"] = { label = "buggy01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["buggy02"] = { label = "buggy02", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["buggy03"] = { label = "buggy03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart02"]  = { label = "cart02",  cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                }
            },
            {
                name = "Coaches",
                types = {
                    ["coach3"] = { label = "coach3", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["coach4"] = { label = "coach4", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["coach5"] = { label = "coach5", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["coach6"] = { label = "coach6", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                }
            },
            {
                name = "Carts",
                types = {
                    ["cart01"] = { label = "cart01", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart03"] = { label = "cart03", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart04"] = { label = "cart04", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart06"] = { label = "cart06", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart07"] = { label = "cart07", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                    ["cart08"] = { label = "cart08", cashPrice = 1, goldPrice = 1, sellPrice = 1 },
                }
            },
            {
                name = "Wagons",
                types = {
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

- https://github.com/JusCampin/bcc-wagons
