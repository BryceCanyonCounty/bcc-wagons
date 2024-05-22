Wagons = {                                          -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
    {
        name  = 'Buggies',
        types = { -- Only Players with Specified Job will See that Wagon to Purchase in the Menu
            ['buggy01'] = { label = 'Buggy 1', cashPrice = 150, goldPrice = 7,  invLimit = 50, job = {} }, -- Job Example: {'police', 'doctor'}
            ['buggy02'] = { label = 'Buggy 2', cashPrice = 200, goldPrice = 10, invLimit = 50, job = {} },
            ['buggy03'] = { label = 'Buggy 3', cashPrice = 250, goldPrice = 12, invLimit = 50, job = {} },
        }
    },
    {
        name = 'Coaches',
        types = {
            ['coach3'] = { label = 'Coach 3', cashPrice = 400, goldPrice = 19, invLimit = 100, job = {} },
            ['coach4'] = { label = 'Coach 4', cashPrice = 300, goldPrice = 14, invLimit = 100, job = {} },
            ['coach5'] = { label = 'Coach 5', cashPrice = 350, goldPrice = 17, invLimit = 100, job = {} },
            ['coach6'] = { label = 'Coach 6', cashPrice = 300, goldPrice = 14, invLimit = 100, job = {} },
        }
    },
    {
        name = 'Carts',
        types = {
            ['cart01']       = { label = 'Cart 1',      cashPrice = 450, goldPrice = 22, invLimit = 200, job = {} },
            ['cart02']       = { label = 'Cart 2',      cashPrice = 100, goldPrice = 5,  invLimit = 200, job = {} },
            ['cart03']       = { label = 'Cart 3',      cashPrice = 450, goldPrice = 22, invLimit = 200, job = {} },
            ['cart04']       = { label = 'Cart 4',      cashPrice = 550, goldPrice = 26, invLimit = 200, job = {} },
            ['cart06']       = { label = 'Cart 6',      cashPrice = 650, goldPrice = 31, invLimit = 200, job = {} },
            ['cart07']       = { label = 'Cart 7',      cashPrice = 400, goldPrice = 19, invLimit = 200, job = {} },
            ['cart08']       = { label = 'Cart 8',      cashPrice = 400, goldPrice = 19, invLimit = 200, job = {} },
            ['huntercart01'] = { label = 'Hunter Cart', cashPrice = 650, goldPrice = 31, invLimit = 200, job = {} },
        }
    },
    {
        name = 'Wagons',
        types = {
            ['supplywagon']       = { label = 'Supply Wagon',  cashPrice = 950,  goldPrice = 46, invLimit = 400, job = {} },
            ['wagontraveller01x'] = { label = 'Travel Wagon',  cashPrice = 1950, goldPrice = 94, invLimit = 400, job = {} },
            ['wagon02x']          = { label = 'Wagon 2',       cashPrice = 1250, goldPrice = 60, invLimit = 400, job = {} },
            ['wagon03x']          = { label = 'Wagon 3',       cashPrice = 1050, goldPrice = 51, invLimit = 400, job = {} },
            ['wagon04x']          = { label = 'Wagon 4',       cashPrice = 1250, goldPrice = 60, invLimit = 400, job = {} },
            ['wagon05x']          = { label = 'Wagon 5',       cashPrice = 1050, goldPrice = 51, invLimit = 400, job = {} },
            ['wagon06x']          = { label = 'Wagon 6',       cashPrice = 1250, goldPrice = 60, invLimit = 400, job = {} },
            ['chuckwagon000x']    = { label = 'Chuck Wagon 1', cashPrice = 1500, goldPrice = 73, invLimit = 400, job = {} },
            ['chuckwagon002x']    = { label = 'Chuck Wagon 2', cashPrice = 1500, goldPrice = 73, invLimit = 400, job = {} },
        }
    }
}