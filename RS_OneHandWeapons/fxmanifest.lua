shared_script "@ReaperV4/imports/bypass.lua"
shared_script "@ReaperV4/imports/bypass_s.lua"
shared_script "@ReaperV4/imports/bypass_c.lua"
lua54 "yes" -- needed for Reaper


fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'ResolveScripts'
version '2.0'

client_scripts {
    'config.lua',
    'client/main.lua'
    
}

server_scripts {
    'server/main.lua'
}

escrow_ignore{
    'config.lua'
}
dependency '/assetpacks'
