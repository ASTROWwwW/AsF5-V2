fx_version 'cerulean'
game 'gta5'

description 'Astrxw Unicorn'
version '1.0.0'




client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

}

files {
    'stream/*.ytd'
}

shared_scripts {'config.lua'}
server_scripts {
    '@es_extended/locale.lua',
    
    'config.lua',
    'server/*.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    
    'config.lua',
    'client/*.lua'
}

dependencies {
    'es_extended',
    'esx_skin',
    'esx_billing'
}
