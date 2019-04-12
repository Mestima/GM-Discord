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

net.Receive("DiscordToGmod", function()
	local username = net.ReadString()
	local message = net.ReadString()
	chat.AddText(Color(66, 140, 244, 255), "[Discord] ", Color(145, 191, 255, 255), username, Color(255, 255, 255, 255), ": ", Color(255, 255, 255, 255), message)
end)

local function OpenDiscordSettings(ply)
	if !ply:IsSuperAdmin() then return end
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(700, 390)
	frame:SetPos(ScrW()/2-350, ScrH()/2-250)
	frame:SetTitle("Discord Settings")
	frame:MakePopup()
	frame.Paint = function(s,w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200)) end

	local mode = vgui.Create("DComboBox", frame)
	mode:SetSize(335, 25)
	mode:SetPos(10, 25)
	mode:SetValue("Select Mode")
	mode:AddChoice("Sandbox")
	mode:AddChoice("DarkRP")

	local type = vgui.Create("DComboBox", frame)
	type:SetSize(335, 25)
	type:SetPos(355, 25)
	type:SetValue("Select Type")
	type:AddChoice("Embed")
	type:AddChoice("Simple")

	local whook = vgui.Create("DTextEntry", frame)
	whook:SetSize(680, 25)
	whook:SetPos(10, 55)
	whook:SetText("Webhook Link")

	local col = vgui.Create("DTextEntry", frame)
	col:SetSize(680, 25)
	col:SetPos(10, 85)
	col:SetText("HTML Color")
	
	local tok = vgui.Create("DTextEntry", frame)
	tok:SetSize(680, 25)
	tok:SetPos(10, 115)
	tok:SetText("Discord App token")
	
	local chan = vgui.Create("DTextEntry", frame)
	chan:SetSize(680, 25)
	chan:SetPos(10, 145)
	chan:SetText("Discord Channel")

	local butts = {
		{
			name = "Set Mode",
			f = function()
				val = mode:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("mode")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord mode has been set to " .. val)
			end
		},
		{
			name = "Set Type",
			f = function()
				local val = type:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("type")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord type has been set to " .. val)
			end
		},
		{
			name = "Set Webhook",
			f = function()
				local val = whook:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("webhook")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord webhook has been set to " .. val)
			end
		},
		{
			name = "Set Color",
			f = function()
				local val = col:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("color")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord embed color has been set to " .. val)
			end
		},
		{
			name = "Set Discord App token",
			f = function()
				local val = tok:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("token")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord App token has been set to " .. val)
			end
		},
		{
			name = "Set Discord Channel",
			f = function()
				local val = chan:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("channel")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("Discord Channel has been set to " .. val)
			end
		},
		{
			name = "Set All",
			f = function()
				local val = col:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("color")
					net.WriteString(col:GetValue())
				net.SendToServer()
				local val = whook:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("webhook")
					net.WriteString(whook:GetValue())
				net.SendToServer()
				local val = type:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("type")
					net.WriteString(val)
				net.SendToServer()
				val = mode:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("mode")
					net.WriteString(val)
				net.SendToServer()
				local val = chan:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("channel")
					net.WriteString(val)
				net.SendToServer()
				local val = tok:GetValue()
				net.Start("DiscordUpdate")
					net.WriteString("token")
					net.WriteString(val)
				net.SendToServer()
				chat.AddText("All Discord settings was updated!")
			end
		}
	}
	local panel = vgui.Create("DScrollPanel", frame)
	panel:SetPos(10, 175)
	panel:SetSize(680, 210)
	for k,v in pairs(butts) do
		local butt = panel:Add("DButton")
		butt:SetText(v.name)
		butt:SetSize(680, 25)
		butt:Dock(TOP)
		butt:DockMargin(0, 0, 0, 5)
		butt.DoClick = v.f
	end
end
concommand.Add("Discord", OpenDiscordSettings)
