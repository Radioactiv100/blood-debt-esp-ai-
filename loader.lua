local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Rayfield GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ESP state
local ESPEnabled = false

-- Distance settings
local MaxItemsDistance = 75

-- Define weapon lists
local killerWeapons = {"K1911", "HWISSH-KP9", "RR-LightCompactPistol", "HEARDBALLA", "JS2-Derringy" , "JS1-Cyclops", "WISP", "Jolibri", "Rosen-Obrez", "Mares Leg", "Sawn-off", "JTS225-Obrez", "Mandols-5", "ZOZ-106", "SKORPION", "ZZ-90", "MAK-10", "Micro KZI", "LUT-E 'KRUS'", "Hammer n Bullet", "Comically Large Spoon", "JS-44", "RR-Mark2", "JS-22", "AGM22", "JS1-Competitor", "Doorbler", "JAVELIN-OBREZS", "Whizz", "Kensington", "THUMPA", "Merretta 486", "Palubu,ZOZ-106", "Kamatov", "RR-LightCompactPistolS","Meretta486Palubu Sawn-Off","Wild Mandols-5","MAK-1020","CharcoalSteel JS-22", "ChromeSlide Turqoise RR-LCP", "Skeleton Rosen-Obrez", "Dual LCPs", "Mares Leg10", "JTS225-Obrez Partycannon", "CharcoalSteel JS-44", "corrodedmetal JS-22", "KamatovS", "JTS225-Obrez Monochrome", "Door'bler", "Clothed SKORPION", "K1911GILDED", "Kensington20", "WISP Pearl", "JS2-BondsDerringy", "JS1-CYCLOPS", "Dual SKORPS", "Clothed Rosen-Obrez", "GraySteel K1911", "Rosen-ObrezGILDED", "PLASTIC JS-22", "CharcoalSteel SKORPION", "Clothed Sawn-off", "Pretty Pink RR-LCP", "Whiteout RR-LightCompactPistolS", "Sawn-off10", "Whiteout Rosen-Obrez", "SKORPION10", "Katya's 'Memories'", "JS2-DerringyGILDED", "JS-22GILDED", "Nikolai's 'Dented'", "JTS225-Obrez Poly", "SilverSteel K1911", "RR-LCP", "DarkSteel K1911", "Door'bler TIGERSTRIPES", "HEARBALLA", "RR-LCP10", "KamatovDRUM", "Charcoal Steel SKORPION", "SKORPION 'AMIRNOV", "Rosen Nagan", "M-1020"}
local sheriffWeapons = {"IZVEKH-412", "J9-Meretta", "RR-Snubby", "Beagle", "HW-M5K", "DRICO", "ZKZ-Obrez", "Buxxberg-COMPACT", "JS-5A-OBREZ", "Dual Elites", "HWISSH-226", "GG-17", "Pretty Pink Buxxberg-COMPACT","GG-1720", "JS-5A-Obrez", "Case Hardened DRICO", "GG-17 TAN", "Dual GG-17s", "CharcoalSteel I412", "ZKZ-Obrez10", "SilverSteel RR-Snubby", "Clothed ZKZ-Obrez", "Pretty Pink GG-17", "GG-17GILDED", "RR-Snubby10"} 

-- Convert weapon lists to dictionaries for faster lookup
local killerWeaponsLookup = {}
local sheriffWeaponsLookup = {}

for _, weapon in ipairs(killerWeapons) do
    killerWeaponsLookup[weapon] = true
end

for _, weapon in ipairs(sheriffWeapons) do
    sheriffWeaponsLookup[weapon] = true
end

-- Define teams and their members with unique colors
local teamColors = {
    ["Street Gang"] = Color3.fromRGB(255, 0, 0),
    ["Bratva"] = Color3.fromRGB(0, 0, 255),
    ["Nubagami"] = Color3.fromRGB(0, 255, 0),
    ["Heist crew"] = Color3.fromRGB(255, 255, 0),
    ["Politsiya"] = Color3.fromRGB(0, 255, 255),
    ["The Zoo"] = Color3.fromRGB(255, 0, 255),
    ["The Trinity"] = Color3.fromRGB(255, 165, 0),
    ["Hoboes"] = Color3.fromRGB(128, 0, 128),
    ["Hooligans"] = Color3.fromRGB(165, 42, 42),
    ["The Noobic Union"] = Color3.fromRGB(0, 128, 128),
    ["NETO"] = Color3.fromRGB(128, 128, 128),
    ["Juggernaut"] = Color3.fromRGB(139, 0, 0),
    ["Robbers"] = Color3.fromRGB(255, 140, 0)
}

local teams = {
    ["Street Gang"] = {
        "Svetlan Orlova", "Ayatasy Vedenina", "Boris Sokolov", "Ksenia Rodionova", "Nikolai Malakov", "Artem Kuzmin"
    },
    ["Bratva"] = {
        "Brigori Yuhan", "Eketerina Mirova", "Grigori Orlaov", "Irina Gromovi", "Polina Volkova"
    },
    ["Nubagami"] = {
        "Asuka Kahashi", "Baim Tsukada", "Emi Takanashi", "Emiko Yoshida", "Ryioji Saito", "Takeshi Tanaka"
    },
    ["Heist crew"] = {
        "Aleksandr Morozov", "Jekaterina Gamova", "Mikhail Logunov", "Nikon Kuzmin", "Oleksa Klimenko", "Yuliian Sorokhtei"
    },
    ["Politsiya"] = {
        "Alan Tuaev", "Artur Tolstoyanovsky", "Emil Gasanbek", "Ilya Barkov", "Said Rasul", "Vadim Korolev",
        "Politsiya1", "Politsiya2", "Politsiya3", "Politsiya4", "Politsiya5", "Politsiya6", 
        "Politsiya7", "Politsiya8", "Politsiya9", "Politsiya10", "Politsiya11", "Joe", "Joe, S"
    },
    ["The Zoo"] = {
        "Danila Fillipov", "Ignati Suslekov", "Kirill Prokhorov", "Lyev Prokhorov", "Tikhon Shepkin", "Timyr Zlenov"
    },
    ["The Trinity"] = {
        "Bai Shirong", "Cheng Qiaolian", "Duan Zhaohui", "Jia Wenqian", "Lu Jianhao", "Shao Chunhua"
    },
    ["Hoboes"] = {
        "Andrei Voronin", "Anna Trusova", "Boris Kirsanov", "Ivan Ivanov", "Snezana Yashina", "Stepan Rudnikov"
    },
    ["Hooligans"] = {
        "Alena Lebedevskaya", "Artur Ustinov", "Daniel Zaytsev", "Diana Myshkina", "Masha Ryabinovich", "Yura Leshev"
    },
    ["The Noobic Union"] = {
        "Tsezar Bortsov", "Aleksai Solovev", "Nikolai Gerasimov", "Hasyan Sunayev", "Marko Glaz"
    },
    ["NETO"] = {
        "Andrew Murphy", "Marshall Fletcher", "Jenson Barnes", "Aaron Knight", "Marco Hughes", "Michael Cooper"
    },
    ["Juggernaut"] = {
        "Stanislav", "Veronika Kazakova"
    },
    ["Robbers"] = {
        "Anastasya Revyakina", "Angela Korzhakova", "Denis Zhuka", "Katya Bykov", "Klara Ivazova", 
        "Matvei Bykov", "Pyotr Turbin", "Viktor Vodoleyev", "Vitaliy Malikov", "Yaroslav Kaditsyn", "Konstantin Krupin"
    }
}

-- Create lookup tables for team members
local teamLookup = {}
local characterToTeam = {}

for teamName, members in pairs(teams) do
    teamLookup[teamName] = {}
    for _, memberName in ipairs(members) do
        local cleanName = memberName:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
        teamLookup[teamName][cleanName] = true
        characterToTeam[cleanName] = teamName
    end
end

-- =============================================================================
-- IMPROVED HINT SYSTEM
-- =============================================================================

local playersMatchingHints = {}
local hintTextConnection = nil
local NPCSFolder = Workspace:FindFirstChild("NPCSFolder")
local lastHintCheck = 0
local HINT_CHECK_INTERVAL = 1

-- Function to parse a single hint
local function parseSingleHint(hintContent)
    local hintType = "invalid"
    local hintValue = nil
    local cleanedContent = hintContent:match("^%s*(.-)%s*$") or ""

    if string.len(cleanedContent) == 0 then
        return hintType, hintValue
    end

    -- Check for task hint format
    local taskMatch = cleanedContent:match("^Is often seen%s*(.*)$")
    if taskMatch then
        hintType = "task"
        hintValue = taskMatch:match("^%s*(.-)%s*$")
        return hintType, hintValue
    end

    -- Check for trait hint format
    local traitBracketMatch = cleanedContent:match("^%[.-%]$")
    if traitBracketMatch then
        local cleanClue = traitBracketMatch:gsub("[%[%]]", ""):match("^%s*(.-)%s*$") or ""
        if string.len(cleanClue) > 0 and cleanClue:lower() ~= "assigned task" and cleanClue:lower() ~= "seen" then
            hintType = "trait"
            hintValue = cleanClue
            return hintType, hintValue
        end
    end

    -- If neither format matched, treat as unbracketed trait
    if hintType == "invalid" then
        hintType = "trait"
        hintValue = cleanedContent
    end

    return hintType, hintValue
end

-- Function to update players matching hints
local function updateMatchingHintPlayers()
    local previousMatches = {}
    for player in pairs(playersMatchingHints) do
        previousMatches[player] = true
    end
    
    playersMatchingHints = {}

    local PlayerGui = localPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end

    local TargetHintLabel = PlayerGui:FindFirstChild("RESETONDEATHStatusGui") and 
                           PlayerGui.RESETONDEATHStatusGui:FindFirstChild("TARGETHINT")

    if not TargetHintLabel or not TargetHintLabel:IsA("TextLabel") then
        return
    end

    local hintText = TargetHintLabel.Text

    -- Check if local player is killer
    local hintPrefix = "Hints : "
    local lowerHintText = string.lower(hintText)
    local lowerHintPrefix = string.lower(hintPrefix)

    if lowerHintText:sub(1, string.len(lowerHintPrefix)) ~= lowerHintPrefix then
        return
    end

    -- Remove prefix and parse hints
    local actualHintContent = hintText:sub(string.len(hintPrefix) + 1):match("^%s*(.-)%s*$")
    
    if string.len(string.gsub(actualHintContent, "%s", "")) == 0 then
        return
    end

    -- Split hint content by " + "
    local individualHintParts = {}
    local currentPos = 1
    while currentPos <= string.len(actualHintContent) do
        local nextPlus = string.find(actualHintContent, " + ", currentPos, true)
        if nextPlus then
            local hintPart = string.sub(actualHintContent, currentPos, nextPlus - 1)
            table.insert(individualHintParts, hintPart)
            currentPos = nextPlus + string.len(" + ")
        else
            local hintPart = string.sub(actualHintContent, currentPos)
            table.insert(individualHintParts, hintPart)
            break
        end
    end

    if #individualHintParts == 0 and string.len(actualHintContent) > 0 then
        table.insert(individualHintParts, actualHintContent)
    end

    local targetConditions = {}

    for i, hintPartContent in ipairs(individualHintParts) do
        local targetNumberMatch = hintPartContent:match("^%[%s*(%d+)%s*%]")
        local targetNumber = tonumber(targetNumberMatch) or 1
        local cleanedHintPartContent = hintPartContent:gsub("^%[%s*%d+%s*%]%s*", ""):match("^%s*(.-)%s*$") or ""

        local hintType, hintValue = parseSingleHint(cleanedHintPartContent)

        if hintType ~= "invalid" and hintValue and string.len(hintValue) > 0 then
            if not targetConditions[targetNumber] then
                targetConditions[targetNumber] = {}
            end
            table.insert(targetConditions[targetNumber], { type = hintType, value = hintValue })
        end
    end

    -- Check each player against hint conditions
    if not NPCSFolder or next(targetConditions) == nil then
        return
    end

    for _, player in Players:GetPlayers() do
        if player ~= localPlayer then
            local playerNPCModel = NPCSFolder:FindFirstChild(player.Name)

            if playerNPCModel then
                local configObject = playerNPCModel:FindFirstChild("Configuration")
                local playerMatchesAnyTarget = false

                for targetNumber, conditionsForTarget in pairs(targetConditions) do
                    local playerMatchesAllConditionsForTarget = true

                    for _, condition in ipairs(conditionsForTarget) do
                        local conditionMet = false

                        if condition.type == "task" then
                            local assignedTaskObject = playerNPCModel:FindFirstChild("AssignedTask")
                            if assignedTaskObject and assignedTaskObject:IsA("StringValue") and 
                               assignedTaskObject.Value == condition.value then
                                conditionMet = true
                            end
                        elseif condition.type == "trait" then
                            if configObject then
                                for _, configChild in ipairs(configObject:GetChildren()) do
                                    if configChild:IsA("StringValue") and configChild.Value == condition.value then
                                        conditionMet = true
                                        break
                                    end
                                end
                            end
                        end

                        if not conditionMet then
                            playerMatchesAllConditionsForTarget = false
                            break
                        end
                    end

                    if playerMatchesAllConditionsForTarget then
                        playerMatchesAnyTarget = true
                        break
                    end
                end

                if playerMatchesAnyTarget then
                    playersMatchingHints[player] = true
                end
            end
        end
    end
    
    -- Force ESP update if hint matches changed
    local hintsChanged = false
    for player in pairs(playersMatchingHints) do
        if not previousMatches[player] then
            hintsChanged = true
            break
        end
    end
    
    if not hintsChanged then
        for player in pairs(previousMatches) do
            if not playersMatchingHints[player] then
                hintsChanged = true
                break
            end
        end
    end
    
    if hintsChanged and ESPEnabled then
        updateAllESPDisplays()
    end
end

-- Function to connect hint text signal
local function connectHintTextSignal()
    if hintTextConnection then
        hintTextConnection:Disconnect()
        hintTextConnection = nil
    end

    local PlayerGui = localPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end

    local statusGui = PlayerGui:WaitForChild("RESETONDEATHStatusGui", 10)
    if not statusGui then return end

    local TargetHintLabel = statusGui:WaitForChild("TARGETHINT", 5)
    if not TargetHintLabel or not TargetHintLabel:IsA("TextLabel") then
        return
    end

    hintTextConnection = TargetHintLabel:GetPropertyChangedSignal("Text"):Connect(function()
        updateMatchingHintPlayers()
    end)
    updateMatchingHintPlayers()
end

-- =============================================================================
-- ESP SYSTEM
-- =============================================================================

-- Cache variables for optimization
local rolesChecked = false
local lastRoleCheck = 0
local ROLE_CHECK_INTERVAL = 10

-- Function to check if roles are present in the game
local function checkForRoles()
    local currentTime = tick()
    if currentTime - lastRoleCheck < ROLE_CHECK_INTERVAL then
        return rolesChecked
    end
    
    lastRoleCheck = currentTime
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local textLabel = obj:FindFirstChildOfClass("TextLabel")
            if textLabel and textLabel.Text then
                local text = textLabel.Text:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                
                for teamName in pairs(teams) do
                    if text:find(teamName, 1, true) then
                        rolesChecked = true
                        return true
                    end
                end
            end
        end
    end
    
    local npcsFolder = Workspace:FindFirstChild("NPCSfolders")
    if npcsFolder then
        for _, npc in ipairs(npcsFolder:GetChildren()) do
            if npc:IsA("Model") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.DisplayName then
                    local displayName = humanoid.DisplayName:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                    
                    if characterToTeam[displayName] then
                        rolesChecked = true
                        return true
                    end
                end
            end
            break
        end
    end
    
    rolesChecked = false
    return false
end

-- Function to check if a tool is equipped by any player
local function isToolEquippedByPlayer(tool)
    if tool.Parent and tool.Parent:IsA("Model") then
        local humanoid = tool.Parent:FindFirstChildOfClass("Humanoid")
        return humanoid ~= nil
    end
    return false
end

-- Cache for player weapons
local playerWeaponsCache = {}
local WEAPONS_CACHE_TIME = 1

-- Function to get a player's weapons
local function getPlayerWeapons(player)
    local currentTime = tick()
    local cache = playerWeaponsCache[player]
    
    if cache and currentTime - cache.time < WEAPONS_CACHE_TIME then
        return cache.weapons
    end
    
    local weapons = {}
    local character = player.Character
    
    if character then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(weapons, tool.Name)
                end
            end
        end

        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(weapons, tool.Name)
            end
        end
    end
    
    playerWeaponsCache[player] = {
        weapons = weapons,
        time = currentTime
    }
    
    return weapons
end

-- Function to get player's health information
local function getPlayerHealth(player)
    local character = player.Character
    if not character then
        return 0, 0
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return 0, 0
    end
    
    return math.floor(humanoid.Health), math.floor(humanoid.MaxHealth)
end

-- Function to determine weapon type and color
local function getWeaponColor(weapons)
    if #weapons == 0 then
        return Color3.fromRGB(0, 255, 0)
    end

    for _, weaponName in ipairs(weapons) do
        if killerWeaponsLookup[weaponName] then
            return Color3.fromRGB(255, 0, 0)
        end

        if sheriffWeaponsLookup[weaponName] then
            return Color3.fromRGB(0, 0, 255)
        end
    end

    return Color3.fromRGB(0, 255, 0)
end

-- Function to get player's team
local function getPlayerTeam(player)
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.DisplayName then
            local displayName = humanoid.DisplayName:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
            return characterToTeam[displayName]
        end
    end
    return nil
end

-- Function to determine player color with hint support
local function getPlayerColor(player)
    if playersMatchingHints[player] then
        local weapons = getPlayerWeapons(player)
        
        local hasKillerOrSheriffWeapon = false
        for _, weaponName in ipairs(weapons) do
            if killerWeaponsLookup[weaponName] or sheriffWeaponsLookup[weaponName] then
                hasKillerOrSheriffWeapon = true
                break
            end
        end
        
        if hasKillerOrSheriffWeapon then
            return Color3.fromRGB(128, 0, 128)
        else
            return Color3.fromRGB(255, 255, 0)
        end
    end
    
    local rolesFound = checkForRoles()
    
    if rolesFound then
        local playerTeam = getPlayerTeam(player)
        if playerTeam and teamColors[playerTeam] then
            return teamColors[playerTeam]
        else
            return Color3.fromRGB(255, 255, 255)
        end
    else
        local weapons = getPlayerWeapons(player)
        return getWeaponColor(weapons)
    end
end

-- Function to check distance between players
local function getDistanceToPlayer(player)
    if not localPlayer.Character then return math.huge end
    
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if not localRoot or not playerRoot then return math.huge end
    
    return (localRoot.Position - playerRoot.Position).Magnitude
end

-- Function to format weapons list
local function formatWeaponsList(weapons, distance)
    if distance > MaxItemsDistance then
        return "..."
    end
    
    if #weapons == 0 then
        return "No items"
    else
        return table.concat(weapons, ", ")
    end
end

-- Function to create display text with hint indicator
local function createDisplayText(playerName, weapons, distance, currentHealth, maxHealth)
    local weaponText = formatWeaponsList(weapons, distance)
    local healthText = "HP: " .. currentHealth .. "/" .. maxHealth
    
    local player = Players:FindFirstChild(playerName)
    local hintIndicator = ""
    if player and playersMatchingHints[player] then
        hintIndicator = " [HINT]"
    end
    
    if player then
        local playerTeam = getPlayerTeam(player)
        if playerTeam then
            return playerName .. " [" .. playerTeam .. "]" .. hintIndicator .. "\n" .. weaponText .. "\n" .. healthText
        end
    end
    
    return playerName .. hintIndicator .. "\n" .. weaponText .. "\n" .. healthText
end

-- Table to store active ESP elements
local activeESPGuis = {}
local activeWeaponHighlights = {}

-- Function to update all ESP displays
local function updateAllESPDisplays()
    for player, espData in pairs(activeESPGuis) do
        if player and player.Character and espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
            local weapons = getPlayerWeapons(player)
            local distance = getDistanceToPlayer(player)
            local currentHealth, maxHealth = getPlayerHealth(player)
            local displayText = createDisplayText(player.Name, weapons, distance, currentHealth, maxHealth)
            local color = getPlayerColor(player)
            
            local textLabel = espData.billboardGui:FindFirstChildOfClass("TextLabel")
            if textLabel then
                textLabel.Text = displayText
                textLabel.TextColor3 = color
            end
            
            if espData.highlight then
                espData.highlight.FillColor = color
                espData.highlight.OutlineColor = color
            end
        end
    end
end

-- Function to create ESP for a player
local function createPlayerESP(player)
    if not ESPEnabled then return end
    if player == localPlayer then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local weapons = getPlayerWeapons(player)
    local distance = getDistanceToPlayer(player)
    local currentHealth, maxHealth = getPlayerHealth(player)
    local displayText = createDisplayText(player.Name, weapons, distance, currentHealth, maxHealth)
    local color = getPlayerColor(player)

    if activeESPGuis[player] then
        local espData = activeESPGuis[player]
        
        if espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
            local textLabel = espData.billboardGui:FindFirstChildOfClass("TextLabel")
            if textLabel then
                textLabel.Text = displayText
                textLabel.TextColor3 = color
            end
        end
        
        if espData.highlight and espData.highlight:IsDescendantOf(game) then
            espData.highlight.FillColor = color
            espData.highlight.OutlineColor = color
            espData.createTime = tick()
        end
        
        return
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 200, 0, 70)
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Enabled = true
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = displayText
    textLabel.TextColor3 = color
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextWrapped = true
    textLabel.ZIndex = 10
    textLabel.Parent = billboardGui

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    activeESPGuis[player] = {
        billboardGui = billboardGui,
        highlight = highlight,
        createTime = tick()
    }
end

-- Function to handle character added event
local function onCharacterAdded(character, player)
    if not ESPEnabled then return end
    
    if activeESPGuis[player] then
        if activeESPGuis[player].billboardGui then
            activeESPGuis[player].billboardGui:Destroy()
        end
        if activeESPGuis[player].highlight then
            activeESPGuis[player].highlight:Destroy()
        end
        activeESPGuis[player] = nil
    end
    
    playerWeaponsCache[player] = nil
    createPlayerESP(player)
end

-- Function to handle player added
local function onPlayerAdded(player)
    if not ESPEnabled then return end
    
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
    
    if player.Character then
        onCharacterAdded(player.Character, player)
    end
end

-- Function to clean up when player leaves
local function onPlayerRemoving(player)
    if activeESPGuis[player] then
        if activeESPGuis[player].billboardGui then
            activeESPGuis[player].billboardGui:Destroy()
        end
        if activeESPGuis[player].highlight then
            activeESPGuis[player].highlight:Destroy()
        end
        activeESPGuis[player] = nil
    end
    playerWeaponsCache[player] = nil
    playersMatchingHints[player] = nil
end

-- Function to highlight dropped weapons
local function highlightDroppedWeapon(tool)
    if not ESPEnabled then return end
    if not tool:IsA("Tool") then return end
    if activeWeaponHighlights[tool] then return end
    
    if tool:IsDescendantOf(Workspace) and not isToolEquippedByPlayer(tool) then
        local weaponColor = Color3.fromRGB(0, 255, 0)
        
        if killerWeaponsLookup[tool.Name] then
            weaponColor = Color3.fromRGB(255, 0, 0)
        elseif sheriffWeaponsLookup[tool.Name] then
            weaponColor = Color3.fromRGB(0, 0, 255)
        else
            return
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Adornee = tool
        highlight.FillColor = weaponColor
        highlight.OutlineColor = weaponColor
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0.0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = tool
        
        activeWeaponHighlights[tool] = {
            highlight = highlight,
            createTime = tick()
        }
        
        local function cleanupWeaponESP()
            local data = activeWeaponHighlights[tool]
            if data then
                data.highlight:Destroy()
                activeWeaponHighlights[tool] = nil
            end
        end
        
        tool.Destroying:Connect(cleanupWeaponESP)
        tool.AncestryChanged:Connect(function()
            if not tool:IsDescendantOf(Workspace) or isToolEquippedByPlayer(tool) then
                cleanupWeaponESP()
            end
        end)
    end
end

-- Function to monitor workspace for weapons
local function monitorWorkspaceForWeapons()
    if not ESPEnabled then return end
    
    local tools = {}
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool)
        end
    end
    
    for i = 1, #tools, 10 do
        for j = i, math.min(i + 9, #tools) do
            highlightDroppedWeapon(tools[j])
        end
        wait(0.05)
    end
    
    local weaponConnection
    weaponConnection = Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Tool") then
            task.wait(0.1)
            highlightDroppedWeapon(descendant)
        end
    end)
    
    return weaponConnection
end

-- =============================================================================
-- ESP CONTROL FUNCTIONS
-- =============================================================================

local eventConnections = {}
local mainLoopConnection = nil
local fastScanConnection = nil
local weaponMonitorConnection = nil

-- Function to enable ESP
local function enableESP()
    if ESPEnabled then return end
    ESPEnabled = true
    
    print("ESP Enabled")
    
    connectHintTextSignal()
    
    eventConnections.playerAdded = Players.PlayerAdded:Connect(onPlayerAdded)
    eventConnections.playerRemoving = Players.PlayerRemoving:Connect(onPlayerRemoving)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            onPlayerAdded(player)
        end
    end
    
    weaponMonitorConnection = monitorWorkspaceForWeapons()
    
    local updateCounter = 0
    local hintCheckCounter = 0
    
    mainLoopConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not ESPEnabled then return end
        
        updateCounter = updateCounter + deltaTime
        hintCheckCounter = hintCheckCounter + deltaTime
        
        if updateCounter >= 1 then
            updateCounter = 0
            
            for player, _ in pairs(activeESPGuis) do
                if player and player.Parent and player.Character then
                    createPlayerESP(player)
                end
            end
        end
        
        if hintCheckCounter >= 2 then
            hintCheckCounter = 0
            updateMatchingHintPlayers()
        end
    end)
    
    fastScanConnection = RunService.Heartbeat:Connect(function()
        if not ESPEnabled then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and not activeESPGuis[player] and player.Character then
                createPlayerESP(player)
            end
        end
    end)
end

-- Function to disable ESP
local function disableESP()
    if not ESPEnabled then return end
    ESPEnabled = false
    
    print("ESP Disabled")
    
    if hintTextConnection then
        hintTextConnection:Disconnect()
        hintTextConnection = nil
    end
    
    for _, connection in pairs(eventConnections) do
        connection:Disconnect()
    end
    eventConnections = {}
    
    if mainLoopConnection then
        mainLoopConnection:Disconnect()
        mainLoopConnection = nil
    end
    
    if fastScanConnection then
        fastScanConnection:Disconnect()
        fastScanConnection = nil
    end
    
    if weaponMonitorConnection then
        weaponMonitorConnection:Disconnect()
        weaponMonitorConnection = nil
    end
    
    for player, espData in pairs(activeESPGuis) do
        if espData.billboardGui then
            espData.billboardGui:Destroy()
        end
        if espData.highlight then
            espData.highlight:Destroy()
        end
    end
    activeESPGuis = {}
    
    for tool, weaponData in pairs(activeWeaponHighlights) do
        if weaponData.highlight then
            weaponData.highlight:Destroy()
        end
    end
    activeWeaponHighlights = {}
    
    playerWeaponsCache = {}
    playersMatchingHints = {}
end

-- =============================================================================
-- AIMBOT SYSTEM
-- =============================================================================

local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    WallCheck = true,
    HealthCheck = true,
    MinHealth = 5,
    TriggerKey = "MouseButton2",
    LockPart = "Head",
    FOV = 90,
    Smoothness = 0.0,
    
    SwitchEnabled = false,
    SwitchInterval = {Min = 2, Max = 8},
    SwitchParts = {"Head", "Torso"},
    
    MaxDistance = 1000,
}

local AimbotEnabled = false
local CurrentTarget = nil
local LastSwitchTime = tick()
local NextSwitchTime = math.random(AimbotSettings.SwitchInterval.Min, AimbotSettings.SwitchInterval.Max)
local CurrentLockPart = AimbotSettings.LockPart
local VisibilityCache = {}
local LastWallCheckTime = 0
local LastTargetUpdateTime = 0
local renderSteppedConnection = nil

local CameraViewportSize = Camera.ViewportSize

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = AimbotSettings.FOV
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(CameraViewportSize.X / 2, CameraViewportSize.Y / 2)

local function GetCurrentLockPart()
    if AimbotSettings.SwitchEnabled then
        return CurrentLockPart
    else
        return AimbotSettings.LockPart
    end
end

local function IsVisible(target)
    if not AimbotSettings.WallCheck then return true end
    if not target or not target.Character then return false end
    
    local currentTime = tick()
    
    if VisibilityCache[target] and currentTime - VisibilityCache[target].time < 0.1 then
        return VisibilityCache[target].visible
    end
    
    local origin = Camera.CFrame.Position
    local targetPart = target.Character:FindFirstChild(GetCurrentLockPart())
    if not targetPart then 
        VisibilityCache[target] = {visible = false, time = currentTime}
        return false 
    end
    
    local targetPosition = targetPart.Position
    local direction = (targetPosition - origin)
    local distance = direction.Magnitude
    
    if distance > AimbotSettings.MaxDistance then
        VisibilityCache[target] = {visible = false, time = currentTime}
        return false
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character, target.Character}
    
    local result = workspace:Raycast(origin, direction.Unit * distance, raycastParams)
    
    local isVisible = (result == nil)
    
    VisibilityCache[target] = {visible = isVisible, time = currentTime}
    return isVisible
end

local function CleanupVisibilityCache()
    local currentTime = tick()
    local cleanupThreshold = 0.5
    
    for player, cache in pairs(VisibilityCache) do
        if not player.Parent or currentTime - cache.time > cleanupThreshold then
            VisibilityCache[player] = nil
        end
    end
end

task.spawn(function()
    while task.wait(10) do
        CleanupVisibilityCache()
    end
end)

local function getPlayerWeaponType(player)
    local weapons = getPlayerWeapons(player)
    
    if #weapons == 0 then
        return "unarmed"
    end

    for _, weaponName in ipairs(weapons) do
        if killerWeaponsLookup[weaponName] then
            return "killer"
        end

        if sheriffWeaponsLookup[weaponName] then
            return "sheriff"
        end
    end

    return "unarmed"
end

local function canAimAtTarget(localPlayer, targetPlayer)
    local localTeam = getPlayerTeam(localPlayer)
    local targetTeam = getPlayerTeam(targetPlayer)
    
    if localTeam then
        if targetTeam and localTeam == targetTeam then
            return false
        end
        return true
    end
    
    local localWeaponType = getPlayerWeaponType(localPlayer)
    local targetWeaponType = getPlayerWeaponType(targetPlayer)
    
    if localWeaponType == "unarmed" or localWeaponType == "sheriff" then
        if targetWeaponType == "unarmed" or targetWeaponType == "sheriff" then
            return false
        end
        return targetWeaponType == "killer"
    elseif localWeaponType == "killer" then
        return true
    end
    
    return true
end

local function IsValidTarget(player)
    if not player.Character then return false end
    
    if AimbotSettings.HealthCheck then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health < AimbotSettings.MinHealth then
            return false
        end
    end
    
    local targetPart = player.Character:FindFirstChild(GetCurrentLockPart())
    if targetPart then
        local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
        if distance > AimbotSettings.MaxDistance then
            return false
        end
    else
        return false
    end
    
    if AimbotSettings.TeamCheck then
        return canAimAtTarget(localPlayer, player)
    end
    
    return true
end

local function GetClosestTarget()
    if not AimbotSettings.Enabled then return nil end
    
    local closestTarget = nil
    local shortestDistance = AimbotSettings.FOV
    local currentTime = tick()
    
    local mousePos = UserInputService:GetMouseLocation()
    local cameraPos = Camera.CFrame.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if not IsValidTarget(player) then
                continue
            end
            
            local targetPart = player.Character:FindFirstChild(GetCurrentLockPart())
            if targetPart then
                local distanceToTarget = (targetPart.Position - cameraPos).Magnitude
                if distanceToTarget > AimbotSettings.MaxDistance then
                    continue
                end
                
                local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance and distance <= AimbotSettings.FOV then
                        if IsVisible(player) then
                            shortestDistance = distance
                            closestTarget = player
                        end
                    end
                end
            end
        end
    end
    
    if closestTarget then
        FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    else
        FOVCircle.Color = Color3.fromRGB(0, 255, 0)
    end
    
    return closestTarget
end

local function SwitchLockPart()
    if not AimbotSettings.SwitchEnabled then return end
    
    local currentIndex = table.find(AimbotSettings.SwitchParts, CurrentLockPart) or 1
    local nextIndex = (currentIndex % #AimbotSettings.SwitchParts) + 1
    CurrentLockPart = AimbotSettings.SwitchParts[nextIndex]
    LastSwitchTime = tick()
    NextSwitchTime = math.random(AimbotSettings.SwitchInterval.Min, AimbotSettings.SwitchInterval.Max)
    
    VisibilityCache = {}
end

local function AimAtTarget(target)
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(GetCurrentLockPart())
    if not targetPart then return end
    
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
end

local frameCounter = 0
local function startAimbotLoop()
    if renderSteppedConnection then
        renderSteppedConnection:Disconnect()
    end
    
    renderSteppedConnection = RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(CameraViewportSize.X / 2, CameraViewportSize.Y / 2)
        
        frameCounter = frameCounter + 1
        
        if frameCounter % 3 == 0 then
            if AimbotSettings.SwitchEnabled and tick() - LastSwitchTime >= NextSwitchTime then
                SwitchLockPart()
            end
            
            local currentTime = tick()
            if AimbotEnabled and CurrentTarget and AimbotSettings.Enabled then
                if currentTime - LastWallCheckTime >= 0.1 then
                    LastWallCheckTime = currentTime
                    
                    if not IsVisible(CurrentTarget) then
                        CurrentTarget = nil
                        FOVCircle.Color = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
        end
        
        if AimbotEnabled and AimbotSettings.Enabled then
            if not CurrentTarget and tick() - LastTargetUpdateTime >= 0.1 then
                LastTargetUpdateTime = tick()
                CurrentTarget = GetClosestTarget()
            end
            
            if CurrentTarget then
                AimAtTarget(CurrentTarget)
            end
        end
    end)
end

localPlayer.CharacterAdded:Connect(function()
    VisibilityCache = {}
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType[AimbotSettings.TriggerKey] and AimbotSettings.Enabled then
        AimbotEnabled = true
        CurrentTarget = GetClosestTarget()
        LastTargetUpdateTime = tick()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType[AimbotSettings.TriggerKey] then
        AimbotEnabled = false
        CurrentTarget = nil
        FOVCircle.Color = Color3.fromRGB(0, 255, 0)
        VisibilityCache = {}
    end
end)

-- =============================================================================
-- RAYFIELD GUI
-- =============================================================================

local Window = Rayfield:CreateWindow({
    Name = "ESP & Aimbot",
    LoadingTitle = "ESP & Aimbot",
    LoadingSubtitle = "by AI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ESPConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

local ESPToggle = MainTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        if Value then
            enableESP()
        else
            disableESP()
        end
    end,
})

local InfoSection = MainTab:CreateSection("Information")
MainTab:CreateLabel("ESP Features:")
MainTab:CreateLabel("- Player highlighting with HP")
MainTab:CreateLabel("- Weapon detection (Killer/Sheriff)")
MainTab:CreateLabel("- Team identification")
MainTab:CreateLabel("- Hint system integration")
MainTab:CreateLabel("- Dropped weapon highlighting")

local SettingsTab = Window:CreateTab("Settings", 4483362458)

local DistanceSection = SettingsTab:CreateSection("Distance Settings")

local ItemDistanceSlider = SettingsTab:CreateSlider({
    Name = "Item Display Distance",
    Range = {10, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = MaxItemsDistance,
    Flag = "ItemDisplayDistance",
    Callback = function(Value)
        MaxItemsDistance = Value
        updateAllESPDisplays()
    end,
})

local PerformanceSection = SettingsTab:CreateSection("Performance")
local UpdateRateSlider = SettingsTab:CreateSlider({
    Name = "Update Rate (seconds)",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 1,
    Flag = "UpdateRate",
    Callback = function(Value)
    end,
})

local VisualSection = SettingsTab:CreateSection("Visual")
local HighlightTransparencySlider = SettingsTab:CreateSlider({
    Name = "Highlight Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.7,
    Flag = "HighlightTransparency",
    Callback = function(Value)
        for _, espData in pairs(activeESPGuis) do
            if espData.highlight then
                espData.highlight.FillTransparency = Value
            end
        end
    end,
})

local ButtonSection = SettingsTab:CreateSection("Controls")
SettingsTab:CreateButton({
    Name = "Refresh ESP",
    Callback = function()
        if ESPEnabled then
            disableESP()
            wait(0.1)
            enableESP()
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Clear All ESP",
    Callback = function()
        disableESP()
    end,
})

local DistanceInfoSection = SettingsTab:CreateSection("Distance Info")
SettingsTab:CreateLabel("Item Distance: determines at what distance")
SettingsTab:CreateLabel("player inventory items are displayed.")
SettingsTab:CreateLabel("If distance is exceeded, '...' is shown")

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Aimbot Enabled",
    CurrentValue = AimbotSettings.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        AimbotSettings.Enabled = Value
        FOVCircle.Visible = Value
        if not Value then
            AimbotEnabled = false
            CurrentTarget = nil
            FOVCircle.Color = Color3.fromRGB(0, 255, 0)
        else
            startAimbotLoop()
        end
    end,
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = AimbotSettings.TeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        AimbotSettings.TeamCheck = Value
    end,
})

AimbotTab:CreateLabel("Team Check Rules:")
AimbotTab:CreateLabel("- If you have a team: don't aim at teammates")
AimbotTab:CreateLabel("- If no team (gun check mode):")
AimbotTab:CreateLabel("  • Unarmed/Sheriff: can aim at killers only")
AimbotTab:CreateLabel("  • Killer: can aim at everyone")
AimbotTab:CreateLabel("  • No team detected: can aim at everyone")

AimbotTab:CreateSlider({
    Name = "FOV Radius",
    Range = {10, 300},
    Increment = 5,
    Suffix = " pixels",
    CurrentValue = AimbotSettings.FOV,
    Flag = "AimbotFOV",
    Callback = function(Value)
        AimbotSettings.FOV = Value
        FOVCircle.Radius = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Health Check",
    CurrentValue = AimbotSettings.HealthCheck,
    Flag = "AimbotHealthCheck",
    Callback = function(Value)
        AimbotSettings.HealthCheck = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "Minimum Health",
    Range = {0, 100},
    Increment = 1,
    Suffix = " HP",
    CurrentValue = AimbotSettings.MinHealth,
    Flag = "AimbotMinHealth",
    Callback = function(Value)
        AimbotSettings.MinHealth = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = AimbotSettings.WallCheck,
    Flag = "AimbotWallCheck",
    Callback = function(Value)
        AimbotSettings.WallCheck = Value
        VisibilityCache = {}
    end,
})

AimbotTab:CreateLabel("Wall Check: Aimbot only works when target is visible")

AimbotTab:CreateSlider({
    Name = "Max Distance",
    Range = {50, 2000},
    Increment = 25,
    Suffix = " studs",
    CurrentValue = AimbotSettings.MaxDistance,
    Flag = "AimbotMaxDistance",
    Callback = function(Value)
        AimbotSettings.MaxDistance = Value
    end,
})

AimbotTab:CreateDropdown({
    Name = "Lock Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentValue = AimbotSettings.LockPart,
    Flag = "AimbotLockPart",
    Callback = function(Value)
        AimbotSettings.LockPart = Value
        VisibilityCache = {}
        
        if not AimbotSettings.SwitchEnabled then
            CurrentLockPart = Value
        end
    end,
})

AimbotTab:CreateToggle({
    Name = "Random Aim Part",
    CurrentValue = AimbotSettings.SwitchEnabled,
    Flag = "AimbotSwitchEnabled",
    Callback = function(Value)
        AimbotSettings.SwitchEnabled = Value
        if Value then
            LastSwitchTime = tick()
            NextSwitchTime = math.random(AimbotSettings.SwitchInterval.Min, AimbotSettings.SwitchInterval.Max)
        else
            CurrentLockPart = AimbotSettings.LockPart
        end
        VisibilityCache = {}
    end,
})

AimbotTab:CreateSlider({
    Name = "Min Switch Time",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = " seconds",
    CurrentValue = AimbotSettings.SwitchInterval.Min,
    Flag = "AimbotSwitchMin",
    Callback = function(Value)
        AimbotSettings.SwitchInterval.Min = Value
        if AimbotSettings.SwitchInterval.Max < Value then
            AimbotSettings.SwitchInterval.Max = Value
        end
    end,
})

AimbotTab:CreateSlider({
    Name = "Max Switch Time",
    Range = {1, 20},
    Increment = 0.5,
    Suffix = " seconds",
    CurrentValue = AimbotSettings.SwitchInterval.Max,
    Flag = "AimbotSwitchMax",
    Callback = function(Value)
        AimbotSettings.SwitchInterval.Max = Value
        if AimbotSettings.SwitchInterval.Min > Value then
            AimbotSettings.SwitchInterval.Min = Value
        end
    end,
})

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = FOVCircle.Visible,
    Flag = "ShowFOVCircle",
    Callback = function(Value)
        FOVCircle.Visible = Value
    end,
})

AimbotTab:CreateSection("Trigger Key")
AimbotTab:CreateLabel("Current Trigger Key: " .. AimbotSettings.TriggerKey)
AimbotTab:CreateLabel("Hold this key to activate aimbot")

Rayfield:LoadConfiguration()
startAimbotLoop() 
