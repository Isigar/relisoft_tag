fx_version 'adamant'
games {'common'}

client_scripts {
    'utils/client/callback.lua',
    'client/main.lua',
}

server_scripts {
    'utils/server/callback.lua',
    'server/main.lua',
}

shared_scripts {
    'utils/const.lua',
    'config.lua',
    'utils/shared.lua',
    'locales/*.lua',
}