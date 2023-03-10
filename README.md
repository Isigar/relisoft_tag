# relisoft_tag
### ESX Tag for mods/admin

**Our discord with more scripts: https://discord.gg/F28PfsY**

Eazy tag system with configuration

**Installation**
1) Put into relisoft_tag folder into your resource folder
2) Start after es_extended/qbcore in your server.cfg
3) Edit config.lua file to fit your needs

**Configurations**

`Config.SeeOwnLabel = true/false`
- if true you will be see your own tag above yourself

`Config.TextSize = 1.5`
- font size for tags more is bigger

`Config.ZOffset = 1.2`
- offset for tag that determinate how much will be tag above player

`Config.NearCheckWait = 500`
- miliseconds to check if player is near any admin


- You can change your labels for admin groups in here
```
Config.GroupLabels = {
    ESX = {
        -- group system that used to work on numbers only
        [1] = {
            [1] = "HELPER",
            [2] = "~g~MODERATOR",
            [3] = "~b~ADMINISTRATOR",
            [4] = "~r~GOD",
            [5] = "~r~GOD",
        },
        -- group system that works on name
        [1] = {
            helper = "HELPER",
            mod = "~g~MODERATOR",
            admin = "~b~ADMINISTRATOR",
            superadmin = "~r~GOD",
        },
    },

    QBCore = {
        -- group system that works on ACE
        [1] = {
            god = "~r~GOD",
            admin = "~b~ADMINISTRATOR",
            mod = "~g~MODERATOR",
        },
    }
}
```
- Settings for tag labels, key in table is for group or permission level, you can change it 
to fit your needs.