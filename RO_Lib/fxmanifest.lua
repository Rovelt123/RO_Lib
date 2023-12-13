fx_version 'cerulean'
game 'gta5'
author 'Rovelt'
description "Rovelt's lab script!"

this_is_a_map 'yes'

client_scripts{
    'Client/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts{
    'Server/*.lua',
}



lua54 'yes'