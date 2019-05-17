# GM-Discord
![alt text](https://i.imgur.com/L22htpB.jpg)

Message transfering system. Discord messages to Garry's Mod game server, Garry's Mod game server chat messages to Discord channel. Also it allows Garry's Mod server admins to run ULX admin commands via Discord.

## Installation Guide:
1. Go to your web-server and upload send.php and request.php

- `http://yoursite.com/send.php`

- `http://yoursite.com/request.php`

2. Go to the `GM-Discord/lua/autorun/server/discord.lua` and replace all API links with your website addresses.

3. Upload the addon to your server.

4. Go to your Discord account settings and enable developer mode.
![alt text](https://i.imgur.com/mdwS4sR.gif)

5. Go to your discord server settings and create a webhook, copy webhook url then write somewhere.

6. Create a new text channel, then right click at the channel name and copy channel id then write somewhere.
![alt text](https://i.imgur.com/RVyzR4U.gif)

7. Go to `https://discordapp.com/developers/applications/me` and create a new application.
Give it a name like "OOC Chat" or something else. Create a bot user, and reveal its token.
Copy token then write somewhere.
![alt text](https://i.imgur.com/T9CMjuI.gif)

8. Go back to your application (`https://discordapp.com/developers/applications/me`) and generate OAuth2 URL. Open generated url in your web browser and invite your discord bot to your discord server. Your bot must have permissions to read and send messages at selected channel. Your discord bot will be offline. It will be working fine.
![alt text](https://i.imgur.com/vglOGl1.gif)

9. Go to your Garry's Mod game server and type `Discord` into your game console. Set up all parameters you have into appropriate fields then click `Set` for every parameter you've changed.


### About `type` parameter
You can choose `Embed` or `Simple` type. I recommend to use `Simple` type if you don't know what is `Embed`.

### About `mode` parameter
Mode is just your gamemode name. For example: `Sandbox` mode will resend all the messages from game chatbox to your discord server. `DarkRP` mode will resend only OOC chat messages. You can add your own mode at the `/lua/autorun/server/discord.lua` file.

### About the `color`
Color is needed with `Embed` type only. It will be message box color. I'm using decimal color in this addon, you can use whatever you want (for example: HTML color). Or use decimal color like me `https://convertingcolors.com/decimal-color-65535.html`

### Game Console Commands
- `Discord` > opens settings menu

- `Discord_AddAdmin id` > adds a new admin to GM-Discord. Where id it is the discord user id (right click to user and copy id in developer mode)

- `Discord_RemoveAdmin id` > removes an admin from GM-Discord.

> Warning! All GM-Discord admins will be allowed to use ALL your ULX commands. !rcon, !ban, !unban etc.
