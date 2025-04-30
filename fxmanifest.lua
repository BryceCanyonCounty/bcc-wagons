fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'BCC Team'

shared_scripts {
    'configs/*.lua',
    'locale.lua',
    'languages/*.lua'
}

client_scripts {
    'client/client.lua',
    'client/menu.lua',
    '@vorp_character/client/creator_functions.lua',
    'client/menuOutfits.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page {
    "ui/dist/index.html"
}

files {
    "ui/dist/index.html",
    "ui/dist/js/*.*",
    "ui/dist/css/*.*",
    "ui/dist/fonts/*.*",
    "ui/dist/img/*.*",
    "ui/dist/style.css"
}

version '1.3.1'