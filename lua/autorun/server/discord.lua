--[[
	COPYRIGHT:
		Made by Mestima © 2019
	
		if (this addon using api.nilored server) then
			I don't allow you to modify this addon.
			I don't allow you to share this addon.
			This addon using MY API server. I don't want billions of people to use my api server.
			If you want to modify this addon, please contact me before or get the source code from my GitHub.
		else
			If you're reading this at the GitHub, you need to know
			that this script is licensed under the GPLv3 License (https://www.gnu.org/licenses/gpl-3.0.html)
			Copyright removing is NOT allowed!
			
			If you're using this type of GM-Discord addon that licensed under GPLv3 license,
			you are NOT allowed to use api.nilored server.
		end
		
		http://steamcommunity.com/id/mestima
		http://github.com/Mestima
]]

DiscordSettings = {
	settings = {
		mode = "Sandbox", -- Sandbox/DarkRP
		type = "Simple", -- Embed or Simple
		webhook = "https://discordapp.com/api/webhooks/GuildID/TOKEN",
		color = 15258703, -- Decimal color (https://convertingcolors.com/decimal-color-15258703.html)
		token = "TOKEN",
		channel = "channel_id",
		admins = {} -- Supports ULX admin mode! (ULX only!)
	}
}

function DiscordSettings:Save()
	file.Write("discord.txt", util.TableToJSON(self.settings))
end
function DiscordSettings:Load()
	if !file.Exists("discord.txt", "DATA") then self:Save() end
	self.settings = util.JSONToTable(file.Read("discord.txt", "DATA"))
end

local function SaveDiscordStorage(tbl)
	file.Write("discord_storage.txt", util.TableToJSON(tbl))
end
if !file.Exists("discord_storage.txt", "DATA") then
	local init = {
		last = 1,
		msg = {}
	}
	SaveDiscordStorage(init)
end

--[[ Network ]]
util.AddNetworkString("DiscordToGmod")
util.AddNetworkString("DiscordUpdate")
net.Receive("DiscordUpdate", function(len,ply)
	if !ply:IsSuperAdmin() then return end
	local type	= net.ReadString()
	local var	= net.ReadString()
	DiscordSettings.settings[type] = var
	DiscordSettings:Save()
end)

--[[ Load Data ]]
DiscordSettings:Load()
DiscordStorage = util.JSONToTable(file.Read("discord_storage.txt", "DATA"))

--[[ Discord Messages ]]
local function GetFromDiscord(body, len, headers, code) -- yeah, I know, so shitty function
	local content = util.JSONToTable(body)
	for i = DiscordStorage.last, #content do
		if content[i].author.bot == true then goto skip end
		for k,v in pairs(DiscordStorage.msg) do if v == content[i].id then goto skip end end
		
		table.insert(DiscordStorage.msg, content[i].id)
		local tbl = {
			last = i, -- Don't forget to make small oprimization :)
			msg = DiscordStorage.msg
		}
		SaveDiscordStorage(tbl)
		local username = content[i].author.username
		local msg = content[i].content
		local uid = tostring(content[i].author.id)
		
		local len = string.len(msg)
		if len > 4 then
			if string.sub(msg,1,1) == "!" then
				if DiscordSettings.settings.admins[uid] then
					local command = string.sub(msg, 2, len)
					game.ConsoleCommand("ulx "..command.."\n")
					goto skip
				end
			end
		end
		
		net.Start("DiscordToGmod")
			net.WriteString(username)
			net.WriteString(msg)
		net.Broadcast()
		::skip:: -- why don't I use 'continue' operator?
	end
end
timer.Create("DiscordMessageGetter", 3, 0, function()
	if not DiscordSettings then return end
	if not DiscordSettings.settings then return end
	if DiscordSettings.settings.token == "TOKEN" or DiscordSettings.settings.channel == "channel_id" then return end
	http.Fetch("http://yourwebserver.com/request.php?channel="..DiscordSettings.settings.channel.."&token="..DiscordSettings.settings.token, GetFromDiscord) -- CHANGE URL HERE
end)

--[[ Avatar Loading ]]
DiscordAvatar = {}
local function GetSteamAvatar(ply)
	http.Fetch("https://steamcommunity.com/profiles/".. ply:SteamID64() .."?xml=1", function(body)
		local p1,p2 = string.find(body, "<avatarFull><!%[CDATA%[.-%]%]></avatarFull>")
		if (p1 && p2) then
			p1 = p1+21
			p2 = p2-16
			local id = ply:SteamID()
			if !DiscordAvatar[id] then
				DiscordAvatar[id] = string.sub(body, p1, p2)
			end
		end
	end,
		function()
			error("Error. Steam api is down.")
		end
	)
end

--[[ Message Filtering Functions ]]
local SendFunctions = {
	DarkRP = function(p,m,t)
		local msg = m
		if string.len(msg) < 4 then return false end
		if string.sub(msg,1,3) == "///" then return false end
		if string.sub(msg,1,3) == "/ad" then return false end
		if string.sub(msg,1,2) ~= "//" && string.sub(msg,1,2) ~= "/a" && string.sub(msg,1,4) ~= "/ooc" then return false end
		
		msg = string.gsub(msg,"// ","")
		msg = string.gsub(msg,"/a ","")
		msg = string.gsub(msg,"/ooc ","")
		local name = ""
		
		if t == true then name = name .. "(TEAM) " end
		if p:Alive() == false then name = name .. "*DEAD* " end
		name = name .. p:Nick()
		return true, msg, name
	end,
	Sandbox = function(p,m,t)
		local msg = m
		local name = ""
		
		if t == true then name = name .. "(TEAM) " end
		if p:Alive() == false then name = name .. "*DEAD* " end
		name = name .. p:Nick()
		return true, msg, name
	end
}

--[[ Transfer Function ]]
local function DiscordRelay(ply, text, team)
	if !IsValid(ply) || !ply:IsPlayer() then return end
	if !DiscordSettings || !DiscordSettings.settings then return end

	local flag, msg, uname = SendFunctions[DiscordSettings.settings.mode](ply, text, team)
	if !flag then return end

	local data = {
		username = uname,
		avatar_url = DiscordAvatar[ply:SteamID()],
		content = msg
	}

	if DiscordSettings.settings.type == "Embed" then -- Embed settings
		data = {
			username = uname,
			avatar_url = DiscordAvatar[ply:SteamID()],
			embeds = {
				{
					author = {
						name = msg
					},
					color = DiscordSettings.settings.color
				}
			}
		}
	end

	http.Post("http://yourwebserver.com/send.php", { -- CHANGE URL HERE
		webhook = DiscordSettings.settings.webhook,
		content = util.TableToJSON(data),
	})
end

--[[ Garbage Collector ]]
local function ClearCache(ply)
	local id = ply:SteamID()
	if !DiscordAvatar[id] then return end
	DiscordAvatar[id] = nil
end
hook.Add("PlayerSay", "DiscordRelay", DiscordRelay)
hook.Add("PlayerDisconnected", "DiscordClearCache", ClearCache)
hook.Add("PlayerInitialSpawn", "DiscordAvatarInit", GetSteamAvatar)

concommand.Add("Discord_AddAdmin", function(ply, cmd, args)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end
	if !args[1] then return end
	DiscordSettings.settings.admins[tostring(args[1])] = true
	DiscordSettings:Save()
end)
concommand.Add("Discord_RemoveAdmin", function(ply, cmd, args)
	if IsValid(ply) and !ply:IsSuperAdmin() then return end
	if !args[1] then return end
	DiscordSettings.settings.admins[tostring(args[1])] = nil
	DiscordSettings:Save()
end)
