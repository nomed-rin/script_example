-- this is First Version That mean is just Beta script lol 
---------------------------------------------------------------- Start Of Macro


local toggle = true 
local MultiboxFramework = require(game:GetService("ReplicatedStorage").MultiboxFramework)
local Network = MultiboxFramework["Network"].Fire
local RecordTable = {}
repeat
	wait()
until game:IsLoaded()
local Lobby = game:GetService("ReplicatedStorage").IsLobby.Value
local function toVector3(String, Separator)
	local Separator = Separator or ','
	local axes = {}
	for axis in String:gmatch('[^' .. Separator .. ']+') do
		axes[#axes + 1] = axis
	end
	return Vector3.new(axes[1], axes[2], axes[3])
end
-- Update log 9/10/23 Suscess with record
local function tprint (tbl, indent)
	if not indent then
		indent = 0
	end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end



local function  GetPrice(Methods, Troops)
	for i, v in pairs(game:GetService("ReplicatedStorage").FrameworkDependencies:GetChildren()) do
		if v:FindFirstChild("TroopDatas") then
			TroopsSTR = tostring(Troops)
			if Methods == "PlaceTroop" then
				return require(v["TroopDatas"][TroopsSTR]).Price
			elseif Methods == "UpgradeTroop" then
				return require(v["TroopDatas"][TroopsSTR]).GetNextLevelPrice(tonumber(Troops.TroopLevel.Value))
			elseif Methods == "GetOrder" then
				return require(v["TroopDatas"][TroopsSTR]).Order
			else
				return "nil"
			end
		end
	end
end

local Reverse_Position 
if not Lobby then 
    local Reverse_Position  = "Mafuck"
end

local function CheckUnit(UnitName, UnitPosition)
	for i, v in pairs(game.Workspace.Troops:GetChildren()) do
		if v.Name == UnitName then
			if v.HumanoidRootPart.Position == UnitPosition or (v.HumanoidRootPart.Position - UnitPosition).magnitude  < 3 then
				return v
			end
		end
	end
end
local function ToggleRecord(filesname)
	MultiboxFramework["Network"].Fire = function(Method, Instance, Positions, Order)
		if Lobby then
			return
		end
		if Method == "PlaceTroop" or  Method == "UpgradeTroop" or  Method == "SellTroop" or  Method == "ChangeTargetting" then
			local price = GetPrice(Method, (Instance))
			print(price)
			if  (Method == "PlaceTroop" or Method == "UpgradeTroop") and game.Players.LocalPlayer.leaderstats.Money.Value > tonumber(price)   then
				local Reverse_Pos
				if Positions then
					Reverse_Pos = Positions - Reverse_Position
				else
					Reverse_Pos = Instance["HumanoidRootPart"].Position - Reverse_Position
				end
				table.insert(RecordTable, {
					["Method"] = Method,
					["Price"] = price or "nil",
					["Instance"] = tostring(Instance),
					["Positions"] = Reverse_Pos or "nil",
					["Order"] = Order or "nil"
				})
			elseif Method == "SellTroop" or  Method == "ChangeTargetting" then
				local Reverse_Pos
				if Positions then
					Reverse_Pos = Positions - Reverse_Position
				else
					Reverse_Pos = Instance["HumanoidRootPart"].Position - Reverse_Position
				end
				table.insert(RecordTable, {
					["Method"] = Method,
					["Price"] = price or "nil",
					["Instance"] = tostring(Instance),
					["Positions"] = Reverse_Pos or "nil",
					["Order"] = Order or "nil"
				})

			end
			if not  filesname then
				return game.Players.LocalPlayer:Kick("Pls Enter FileName")
			end
			writefile("Royx_Toilet/" .. filesname .. ".lua", "local Royx = function()  \n return " .. tprint(RecordTable) .. "end \n return Royx()" )
		end
		return Network(Method, Instance, Positions, Order)
	end
end
local function Plays(FilePath)
	local Macro = loadfile("Royx_Toilet/" .. FilePath)()
	if Lobby then
		return
	end
	for i, v in pairs(Macro) do
		wait(0.5)
		print(i)
		local RealPositions = toVector3(v.Positions) + Reverse_Position
		if v.Method == "PlaceTroop" then
			repeat
				local unit = CheckUnit(v.Instance, RealPositions)
				task.wait()
				if game.Players.LocalPlayer.leaderstats.Money.Value > v.Price then
					MultiboxFramework["Network"].Fire(v.Method, v.Instance, RealPositions, v.Order)
				end
			until game.Players.LocalPlayer.leaderstats.Money.Value > v.Price and unit
		elseif  v.Method == "UpgradeTroop" then
			repeat
				local unit = CheckUnit(v.Instance, RealPositions)
				task.wait()
				if unit  and game.Players.LocalPlayer.leaderstats.Money.Value > v.Price then
					MultiboxFramework["Network"].Fire(v.Method, unit)
				end
			until game.Players.LocalPlayer.leaderstats.Money.Value > v.Price and unit
		else
			repeat
				local unit = CheckUnit(v.Instance, RealPositions)
				task.wait()
				if unit then
					MultiboxFramework["Network"].Fire(v.Method, unit)
				end
			until unit
		end
	end
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/nomed-rin/Royx_Utlis/main/Auto%20Find%20Unit%20Id"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/nomed-rin/Royx_Utlis/main/Auto%20sell"))()

---------------------------------------------------------------- End Of Macro


---------------------------------------------------------------- Auto Play

local function AutoPlays()
-- Snipped
end





---------------------------------------------------------------- end of Auto Play
local function loadUI()
	repeat
		wait()
	until game:IsLoaded()
	wait(2.5)
	local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
	local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
	local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
	local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
	if not isfolder("Royx_Toilet") then
		makefolder("Royx_Toilet")
	end
	local plr = game.Players.LocalPlayer
	local MultiboxFramework = require(game:GetService("ReplicatedStorage"):WaitForChild("MultiboxFramework"))
	MultiboxFramework["Network"].Fired("QueueLeaderChanged"):Connect(function(a1, a2, a3, a4, a5)
		if a5 == plr and a3 == 1 and Toggles.Join.Value then -- a3 คือ จำนวน Player ในห้องเวลาเราไปยืน
			MultiboxFramework["Network"].Fire("StartTeleport", a1)
		end
	end)
	local Junk_Meme = {
		"หมาสี่แม่มึง.com",
		"เช่ายศ Instant Whitelist เพื่อลุงรอยไปเปย์ สาวแว่น",
		"Royx เป็นสายตำรวจ",
		"ไอภูมิชอบไปล้างจานดาวเทียม",
		"กลับไทยรอบเดียวได้สาวกลับไป 10 คนไม่เกินจริง",
		"โดนเมดล่อซื้อ 2500 อย่าให้รู้นะใคร",
		" บอก @Royx เลิกบิดไปคุยกับสาวแว่น",
		"Royx จะเดินตามรอยของพ่อ",
		"Royx บอกเธอไปเลิกกับผัวแล้วมานัวกับผม",
	}
	local Map_Data = {
		"ToiletCity",
		"Desert",
		"CameramanHQ",
		"ToiletHQ"
	}
	local Window = Library:CreateWindow({
        -- Set Center to true if you want the menu to appear in the center
        -- Set AutoShow to true if you want the menu to appear when it is created
        -- Position and Size are also valid options here
        -- but you do not need to define them unless you are changing them :)
		Title = 'Royx Hub',
		Center = true,
		AutoShow = true,
		TabPadding = 8,
		MenuFadeTime = 0.2
	})
	local Tabs = {
        -- Creates a new tab titled Main
		Main = Window:AddTab('Main'),
		['UI Settings'] = Window:AddTab('UI Settings'),
	}
	local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Macro')
	LeftGroupBox:AddDropdown('Mode', {
		Values = {
			'Record',
			'PlayMacro',
			"AutoPlay"
		},
		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		Text = 'Mode',
		Callback = function(Value)
		end
	})
	LeftGroupBox:AddToggle('Enable', {
		Text = 'Enable'
	});
	local LeftGroupBox = Tabs.Main:AddRightGroupbox('File System')
	LeftGroupBox:AddDropdown('Record', {
		Values = listfiles("Royx_Toilet"),
		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		Text = 'Record File',
		Callback = function(Value)
		end
	})
	LeftGroupBox:AddButton('Refresh', function()
		Options.Record:SetValues(listfiles("Royx_Toilet"))
	end)
	LeftGroupBox:AddDropdown('MarcoFile', {
		Values = listfiles("Royx_Toilet"),
		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		Text = 'Macro Profile',
		Callback = function(Value)
		end
	})
	LeftGroupBox:AddButton('Refresh', function()
		Options.MarcoFile:SetValues(listfiles("Royx_Toilet"))
	end)
	LeftGroupBox:AddInput('FileName', {
		Default = '',
		Numeric = false, -- true / false, only allows numbers
		Finished = false, -- true / false, only calls callback when you press enter
		Text = 'File Name',
	})
	LeftGroupBox:AddButton('Create File', function()
		writefile("Royx_Toilet/" .. Options.FileName.Value, Junk_Meme[math.random(1, #Junk_Meme)])
	end)
	local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Auto join')
	LeftGroupBox2:AddDropdown('Select', {
		Values = Map_Data or {},
		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		Text = 'Select Map',
	})
	LeftGroupBox2:AddToggle('Join', {
		Text = 'Auto Join'
	});
	LeftGroupBox:AddDropdown('DifMode', {
		Values = {
			'Easy',
			'Medium',
			"Hard",
			"Nightmare"
		},
		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		Text = 'Mode',
	})
	LeftGroupBox2:AddToggle('difficult', {
		Text = 'Auto select Difficult'
	});
	LeftGroupBox2:AddToggle('SkipVote', {
		Text = 'Auto Skip'
	});
	LeftGroupBox2:AddSlider('SkipVoteXWave', {
		Text = 'Stop Skip Wave at',
		Default = 0,
		Min = 0,
		Max = 30,
		Rounding = 20,
		Compact = true,

	})
	LeftGroupBox2:AddToggle('StopSkipVote', {
		Text = 'Stop Skip after Wave'
	});
	LeftGroupBox2:AddSlider('LeavePing', {
		Text = 'Leave After Ping',
		Default = 500,
		Min = 500,
		Max = 2000,
		Rounding = 0.1,
		Compact = true,

	})
	LeftGroupBox2:AddToggle('LeaveHighPing', {
		Text = 'Leave when high ping'
	});
	local RightGroupBox = Tabs.Main:AddRightGroupbox('Auto Sell')

	RightGroupBox:AddDropdown('AutoSell', {
		Values = {
		    'None',
			'Basic',
			'Uncommon',
			"Rare",
			"Epic",
			"Legendary",
			"Mythic",
			"Exclusive"
		},
		Default = 1, -- number index of the value / string
		Multi = true, -- true / false, allows multiple choices to be selected
		Text = 'Raraity to sell',
	})
	RightGroupBox:AddButton('Sell', function()
		AutoSell(Options.AutoSell.Value)
	end)
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
    
    -- Ignore keys that are used by ThemeManager.
    -- (we dont want configs to save themes, do we?)
	SaveManager:IgnoreThemeSettings()
    
    -- Adds our MenuKeybind to the ignore list
    -- (do you want each config to have a different menu key? probably not.)
	SaveManager:SetIgnoreIndexes({
		'MenuKeybind'
	})
    
    -- use case for doing it this way:
    -- a script hub could have themes in a global folder
    -- and game configs in a separate folder per game
	ThemeManager:SetFolder('Royx_ToiletThemeManager')
	SaveManager:SetFolder('Royx_ToiletSaveManager')
    
    -- Builds our config menu on the right side of our tab
	SaveManager:BuildConfigSection(Tabs['UI Settings'])
    
    -- Builds our theme menu (with plenty of built in themes) on the left side
    -- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
	ThemeManager:ApplyToTab(Tabs['UI Settings'])
    
    -- You can use the SaveManager:LoadAutoloadConfig() to load a config
    -- which has been marked to be one that auto loads!
	SaveManager:LoadAutoloadConfig()
    -------------------------------- Extra functions --------------------------------
	task.spawn(function()

			if not Lobby and Toggles.SkipVote.Value and game:GetService("ReplicatedStorage").MatchData.CanSkip.Value then
				MultiboxFramework["Network"].Fire("VoteSkipWave")

	end)
    -------------------------------- Auto Join --------------------------------
	local function AutoJoin()
		if Lobby then
			for i, v in pairs(game:GetService("Workspace").Lifts:GetChildren()) do
				if Toggles.Join.Value and v.Name == Options.Select.Value  then -- Lazy loll
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Base.CFrame 
				end
			end
		end
	end

	Toggles.Join:OnChanged(function()
		AutoJoin()
	end)
	Toggles.Enable:OnChanged(function()
		if Options.Mode.Value == "PlayMacro" then
			Plays(Options.MarcoFile.Value:split([[\]])[2])
		elseif Options.Mode.Value == "Record" then
			ToggleRecord(Options.Record.Value:split([[\]])[2])
		elseif Options.Mode.Value == "AutoPlay" then 
			AutoPlays()
			print("AutoPlay is Testing Beta")
		end
	end)
	Toggles.difficult:OnChanged(function()
			MultiboxFramework["Network"].Fire("VoteMap", Options.DifMode.Value)

	end)
    task.spawn(function()
		while true do
			wait()
			if Toggles.LeaveHighPing.Value and  game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() > Options.LeavePing.Value then
				game:GetService("TeleportService"):Teleport(13775256536, game.Players.LocalPlayer)
			end
		end
	end)
end
local status, err = pcall(loadUI)

if not status then
	loadUI()
end
