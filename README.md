# relisoft_tag
### ESX Tag for mods/admin

**Our discord with more scripts: https://discord.gg/F28PfsY**

Eazy tag system with configuration

**Installation**
1) Put into relisoft_tag folder into your resource folder
2) Start after es_extended in your server.cfg
3) Edit config.lua file to fit your needs

**Configurations**

`Config.SeeOwnLabel = true/false`
- if true you will be see your own tag above yourself

`Config.SeeDistance = 100`
- distance on which will other player will see your tag

`Config.TextSize = 1.5`
- font size for tags more is bigger

`Config.ZOffset = 1.2`
- offset for tag that determinate how much will be tag above player

`Config.NearCheckWait = 500`
- miliseconds to check if player is near any admin

`Config.TagByPermission = true`
- with this option tag system will use xPlayer.getPermission() function
and labels for tags will be get by permission level not group, you have to have
older ESX to have this function, its deprecated in newer versions.
```
Config.GroupLabels = {
    helper = "HELPER",
    mod = "~g~MODERATOR",
    admin = "~b~ADMINISTRATOR",
    superadmin = "~r~GOD",
}

Config.PermissionLabels = {
    [1] = "HELPER",
    [2] = "~g~MODERATOR",
    [3] = "~b~ADMINISTRATOR",
    [4] = "~r~GOD",
    [5] = "~r~GOD",
}
```
- Settings for tag labels, key in table is for group or permission level, you can change it 
to fit your needs.

**Dependency**
- es_extended
