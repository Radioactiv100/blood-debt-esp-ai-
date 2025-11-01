local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Rayfield failed to load: " .. tostring(err))
    return
end

local function clamp(v, a, b) 
    if v < a then 
        return a 
    elseif v > b then 
        return b 
    else 
        return v 
    end 
end

local function safeRequire(m)
    local ok2, res = pcall(function() 
        return require(m) 
    end)
    if ok2 then 
        return res 
    end
    return nil
end

local State = {
    ESP = false,
    ESP_TeamCheck = false,
    WalkLock = false,
    WeaponEnhancementsEnabled = true,
    RapidFire = false,
    InfiniteAmmo = false,
    SpreadControl = false,
}

local Settings = {
    WalkSpeed = 16,
    WalkMin = 8,
    WalkMax = 200,
    RapidFireRate = 0.02,
    SpreadValue = 0,
    AmmoValue = 30,
}

local DoorHandleSettings = {
    Enabled = false,
    SizeMultiplier = 2,
    NoCollision = false
}

local ThirdPersonSettings = {
    Enabled = false,
    MaxZoomDistance = 15,
    MinZoomDistance = 0
}

local FOVChangerSettings = {
    Enabled = false,
    FOVValue = 90
}

local LocalAmmoDisplaySettings = {
    Enabled = false,
    TextColor = Color3.new(1, 1, 1),
    TextSize = 36,
    Font = Enum.Font.GothamBold
}

local ESPEnabled = false
local MaxItemsDistance = 75
local ESPUpdateRate = 1

local ESPVisibilitySettings = {
    ShowName = true,
    ShowTools = true,
    ShowAmmoInfo = true
}

local BoxESPSettings = {
    Enabled = false,
    ShowDistance = true,
    ShowTracer = true,
    Thickness = 2,
    SizeMultiplier = 1
}

local HealthBarSettings = {
    Enabled = false,
    BarThickness = 3,
    BarWidth = 12
}

local HitboxSettings = {
    Enabled = false,
    OverallScale = 2.0,
    HeightScale = 1.0,
    WidthScale = 1.0,
    DepthScale = 1.0,
    ToggleKey = Enum.KeyCode.E,
    Transparency = 0.8,
    Color = Color3.fromRGB(255, 165, 0),
    Material = "Neon"
}

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
    
    TransparencyThreshold = 0.6,
    ForceFieldAlwaysTransparent = true,
    
    MultiLayerCheck = true,
    MaxWallLayers = 3,
    CheckPrecision = 2.0
}

local killerWeapons = {"K1911", "HWISSH-KP9", "RR-LightCompactPistol", "HEARDBALLA", "JS2-Derringy" , "JS1-Cyclops", "WISP", "Jolibri", "Rosen-Obrez", "Mares Leg", "Sawn-off", "JTS225-Obrez", "Mandols-5", "ZOZ-106", "SKORPION", "ZZ-90", "MAK-10", "Micro KZI", "LUT-E 'KRUS'", "Hammer n Bullet", "Comically Large Spoon", "JS-44", "RR-Mark2", "JS-22", "AGM22", "JS1-Competitor", "Doorbler", "JAVELIN-OBREZS", "Whizz", "Kensington", "THUMPA", "Merretta 486", "Palubu,ZOZ-106", "Kamatov", "RR-LightCompactPistolS","Meretta486Palubu Sawn-Off","Wild Mandols-5","MAK-1020","CharcoalSteel JS-22", "ChromeSlide Turqoise RR-LCP", "Skeleton Rosen-Obrez", "Dual LCPs", "Mares Leg10", "JTS225-Obrez Partycannon", "CharcoalSteel JS-44", "corrodedmetal JS-22", "KamatovS", "JTS225-Obrez Monochrome", "Door'bler", "Clothed SKORPION", "K1911GILDED", "Kensington20", "WISP Pearl", "JS2-BondsDerringy", "JS1-CYCLOPS", "Dual SKORPS", "Clothed Rosen-Obrez", "GraySteel K1911", "Rosen-ObrezGILDED", "PLASTIC JS-22", "CharcoalSteel SKORPION", "Clothed Sawn-off", "Pretty Pink RR-LCP", "Whiteout RR-LightCompactPistolS", "Sawn-off10", "Whiteout Rosen-Obrez", "SKORPION10", "Katya's 'Memories'", "JS2-DerringyGILDED", "JS-22GILDED", "Nikolai's 'Dented'", "JTS225-Obrez Poly", "SilverSteel K1911", "RR-LCP", "DarkSteel K1911", "Door'bler TIGERSTRIPES", "HEARBALLA", "RR-LCP10", "KamatovDRUM", "Charcoal Steel SKORPION", "SKORPION 'AMIRNOV", "Rosen Nagan", "M-1020", "RR-LightCompactPistolS10", "JTS225-ObrezGILDED", "KR7S", "Mooser", "PTRB-41", "TEKE-9", "RUZKH-12", "APZ", "HW-K7"}
local sheriffWeapons = {"IZVEKH-412", "J9-Meretta", "RR-Snubby", "Beagle", "HW-M5K", "DRICO", "ZKZ-Obrez", "Buxxberg-COMPACT", "JS-5A-OBREZ", "Dual Elites", "HWISSH-226", "GG-17", "Pretty Pink Buxxberg-COMPACT","GG-1720", "JS-5A-Obrez", "Case Hardened DRICO", "GG-17 TAN", "Dual GG-17s", "CharcoalSteel I412", "ZKZ-Obrez10", "SilverSteel RR-Snubby", "Clothed ZKZ-Obrez", "Pretty Pink GG-17", "GG-17GILDED", "RR-Snubby10", "RR-SnubbyGILDED", "Mini Ranch Rifle"} 

local killerWeaponsLookup = {}
local sheriffWeaponsLookup = {}

for _, weapon in ipairs(killerWeapons) do
    killerWeaponsLookup[weapon] = true
end

for _, weapon in ipairs(sheriffWeapons) do
    sheriffWeaponsLookup[weapon] = true
end

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
    ["Robbers"] = Color3.fromRGB(255, 140, 0),
    ["Hiders"] = Color3.fromRGB(255, 200, 0)
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
        "Politsiya7", "Politsiya8", "Politsiya9", "Politsiya10", "Politsiya11", "Joe", "Joe, S", "Politzia"
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
        "Tsezar Bortsov", "Aleksei Solovev", "Nikolai Gerasimov", "Hasyan Sunayev", "Marko Glaz"
    },
    ["NETO"] = {
        "Andrew Murphy", "Marshall Fletcher", "Jenson Barnes", "Aaron Knight", "Marco Hughes", "Michael Cooper", 
		"Gabriel Hall", "Noah Khan", "Harry Thompson", "Lamar Farrell", "Jordan Henderson", "Antonio Lindsay", 
		"Sam Jordan", "Tom Stone", "Samuel Lawson", "Julio Bishop"
    },
    ["Juggernaut"] = {
        "Stanislav", "Veronika Kazakova", "Mason Jr.", "Traktirnikov Gennadiy", "Vanya Aleksandrov"
    },
    ["Robbers"] = {
        "Anastasya Revyakina", "Angela Korzhakova", "Denis Zhuka", "Katya Bykov", "Klara Ivazova", 
        "Matvei Bykov", "Pyotr Turbin", "Viktor Vodoleyev", "Vitaliy Malikov", "Yaroslav Kaditsyn", "Konstantin Krupin"
    },
    ["Hiders"] = {
        "Timofey Nevelyskiy", "Sasha Karpov", "Anatoly Kravtsov", "Asya Rozhkova", "Anton Panikov", 
        "Valentina Artyomovna", "Artur Kombatov", "Aleksandr Kristavitskiy", "David Evseev", "Yulya Serdechainya","Stepan Fendrikov",
    }
}

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

local NPCSFolder = Workspace:FindFirstChild("NPCSFolder")

local function isPlayerInNPCSFolder(player)
    return NPCSFolder and NPCSFolder:FindFirstChild(player.Name) ~= nil
end

local playersMatchingHints = {}
local hintTextConnection = nil
local lastHintCheck = 0
local HINT_CHECK_INTERVAL = 1

local function parseSingleHint(hintContent)
    local hintType = "invalid"
    local hintValue = nil
    local cleanedContent = hintContent:match("^%s*(.-)%s*$") or ""

    if string.len(cleanedContent) == 0 then
        return hintType, hintValue
    end

    local taskMatch = cleanedContent:match("^Is often seen%s*(.*)$")
    if taskMatch then
        hintType = "task"
        hintValue = taskMatch:match("^%s*(.-)%s*$")
        return hintType, hintValue
    end

    local traitBracketMatch = cleanedContent:match("^%[.-%]$")
    if traitBracketMatch then
        local cleanClue = traitBracketMatch:gsub("[%[%]]", ""):match("^%s*(.-)%s*$") or ""
        if string.len(cleanClue) > 0 and cleanClue:lower() ~= "assigned task" and cleanClue:lower() ~= "seen" then
            hintType = "trait"
            hintValue = cleanClue
            return hintType, hintValue
        end
    end

    if hintType == "invalid" then
        hintType = "trait"
        hintValue = cleanedContent
    end

    return hintType, hintValue
end

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

    local hintPrefix = "Hints : "
    local lowerHintText = string.lower(hintText)
    local lowerHintPrefix = string.lower(hintPrefix)

    if lowerHintText:sub(1, string.len(lowerHintPrefix)) ~= lowerHintPrefix then
        return
    end

    local actualHintContent = hintText:sub(string.len(hintPrefix) + 1):match("^%s*(.-)%s*$")
    
    if string.len(string.gsub(actualHintContent, "%s", "")) == 0 then
        return
    end

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

    if not NPCSFolder or next(targetConditions) == nil then
        return
    end

    for _, player in Players:GetPlayers() do
        if player ~= localPlayer and isPlayerInNPCSFolder(player) then
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
    
    if hintsChanged then
        forceUpdateESP()
    end
end

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

local function getStandardBodyParts(npcModel)
    local bodyParts = {}
    
    if not npcModel or not npcModel:IsA("Model") then
        return bodyParts
    end
    
    local standardParts = {
        "Head", "Torso", "HumanoidRootPart",
        "Left Arm", "Right Arm", 
        "Left Leg", "Right Leg"
    }
    
    for _, partName in ipairs(standardParts) do
        local part = npcModel:FindFirstChild(partName)
        if part and part:IsA("BasePart") and part.Transparency < 1 then
            table.insert(bodyParts, part)
        end
    end
    
    return bodyParts
end

local function calculateStandardCharacterBounds(npcModel)
    if not npcModel or not npcModel:IsA("Model") then
        return nil, nil
    end
    
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    local partsFound = false
    
    local bodyParts = getStandardBodyParts(npcModel)
    
    if #bodyParts == 0 then
        local humanoidRootPart = npcModel:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
            local position = humanoidRootPart.Position
            local size = Vector3.new(3, 5, 1)
            return position, size
        end
        return nil, nil
    end
    
    for _, part in ipairs(bodyParts) do
        local cf = part.CFrame
        local size = part.Size
        
        local vertices = {
            cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
            cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
            cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
            cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
            cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
            cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
            cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
            cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)
        }
        
        for _, vertex in ipairs(vertices) do
            local pos = vertex.Position
            minX = math.min(minX, pos.X)
            minY = math.min(minY, pos.Y)
            minZ = math.min(minZ, pos.Z)
            maxX = math.max(maxX, pos.X)
            maxY = math.max(maxY, pos.Y)
            maxZ = math.max(maxZ, pos.Z)
        end
        partsFound = true
    end
    
    if not partsFound then
        return nil, nil
    end
    
    local center = Vector3.new((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2)
    local size = Vector3.new(maxX - minX, maxY - minY, maxZ - minZ)
    
    size = size + Vector3.new(0.3, 0.3, 0.3)
    
    return center, size
end

local function getAccurateScreenBoundingBox(npcModel)
    local center, size = calculateStandardCharacterBounds(npcModel)
    if not center or not size then
        return nil
    end
    
    local corners = {
        center + Vector3.new(size.X/2, size.Y/2, size.Z/2),
        center + Vector3.new(-size.X/2, size.Y/2, size.Z/2),
        center + Vector3.new(size.X/2, -size.Y/2, size.Z/2),
        center + Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
        center + Vector3.new(size.X/2, size.Y/2, -size.Z/2),
        center + Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
        center + Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
        center + Vector3.new(-size.X/2, -size.Y/2, -size.Z/2)
    }
    
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyVisible = false
    
    for _, corner in ipairs(corners) do
        local screenPoint, onScreen = Camera:WorldToViewportPoint(corner)
        if onScreen then
            anyVisible = true
            minX = math.min(minX, screenPoint.X)
            minY = math.min(minY, screenPoint.Y)
            maxX = math.max(maxX, screenPoint.X)
            maxY = math.max(maxY, screenPoint.Y)
        end
    end
    
    if not anyVisible then
        return nil
    end
    
    local width = (maxX - minX) * BoxESPSettings.SizeMultiplier
    local height = (maxY - minY) * BoxESPSettings.SizeMultiplier
    
    local centerX = (minX + maxX) / 2
    local centerY = (minY + maxY) / 2
    
    local boxPosition = Vector2.new(centerX - width/2, centerY - height/2)
    local boxSize = Vector2.new(width, height)
    
    return boxPosition, boxSize, center
end

local function getPlayerTeam(player)
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.DisplayName then
            local displayName = humanoid.DisplayName:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
            
            if characterToTeam[displayName] then
                return characterToTeam[displayName]
            end
            
            for teamName, members in pairs(teamLookup) do
                for memberName in pairs(members) do
                    if string.find(displayName, memberName, 1, true) then
                        return teamName
                    end
                end
            end
        end
    end
    return nil
end

local playerWeaponsCache = {}
local WEAPONS_CACHE_TIME = 0.5

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

local boxESPPlayers = {}
local boxESPConnections = {}

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
    
    local playerTeam = getPlayerTeam(player)
    if playerTeam and teamColors[playerTeam] then
        return teamColors[playerTeam]
    end
    
    local weapons = getPlayerWeapons(player)
    for _, weaponName in ipairs(weapons) do
        if killerWeaponsLookup[weaponName] then
            return Color3.fromRGB(255, 0, 0)
        elseif sheriffWeaponsLookup[weaponName] then
            return Color3.fromRGB(0, 0, 255)
        end
    end
    
    return Color3.fromRGB(0, 255, 0)
end

local function createBoxESP(player)
    if player == localPlayer then return end
    if boxESPPlayers[player] then return end
    
    local boxData = {
        Box = Drawing.new("Square"),
        DistanceTag = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    boxData.Box.Visible = false
    boxData.Box.Color = getPlayerColor(player)
    boxData.Box.Thickness = BoxESPSettings.Thickness
    boxData.Box.Transparency = 1
    boxData.Box.Filled = false
    
    boxData.DistanceTag.Visible = false
    boxData.DistanceTag.Color = Color3.new(1, 1, 1)
    boxData.DistanceTag.Size = 13
    boxData.DistanceTag.Center = true
    boxData.DistanceTag.Outline = true
    boxData.DistanceTag.OutlineColor = Color3.new(0, 0, 0)
    boxData.DistanceTag.Font = 2
    
    boxData.Tracer.Visible = false
    boxData.Tracer.Color = getPlayerColor(player)
    boxData.Tracer.Thickness = 2
    
    boxESPPlayers[player] = boxData
end

local function removeBoxESP(player)
    if boxESPPlayers[player] then
        for _, drawing in pairs(boxESPPlayers[player]) do
            if drawing and drawing.Remove then
                pcall(function() drawing:Remove() end)
            end
        end
        boxESPPlayers[player] = nil
    end
    
    if boxESPConnections[player] then
        boxESPConnections[player]:Disconnect()
        boxESPConnections[player] = nil
    end
end

local function updateBoxESP()
    if not BoxESPSettings.Enabled then return end
    
    for player, boxData in pairs(boxESPPlayers) do
        if not player or not player.Parent then
            removeBoxESP(player)
            continue
        end
        
        if not isPlayerInNPCSFolder(player) then
            removeBoxESP(player)
            continue
        end
        
        local npcModel = NPCSFolder:FindFirstChild(player.Name)
        if not npcModel or not npcModel:IsA("Model") then
            removeBoxESP(player)
            continue
        end
        
        local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            if boxData then
                boxData.Box.Visible = false
                boxData.DistanceTag.Visible = false
                boxData.Tracer.Visible = false
            end
            continue
        end
        
        local success, boxPosition, boxSize, worldCenter = pcall(function()
            return getAccurateScreenBoundingBox(npcModel)
        end)
        
        if not success or not boxPosition or not boxSize then
            if boxData then
                boxData.Box.Visible = false
                boxData.DistanceTag.Visible = false
                boxData.Tracer.Visible = false
            end
            continue
        end
        
        local playerColor = getPlayerColor(player)
        
        boxData.Box.Size = boxSize
        boxData.Box.Position = boxPosition
        boxData.Box.Color = playerColor
        boxData.Box.Thickness = BoxESPSettings.Thickness
        boxData.Box.Visible = true
        
        if BoxESPSettings.ShowDistance then
            local distance = 0
            if localPlayer.Character then
                local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localRoot and worldCenter then
                    distance = math.floor((worldCenter - localRoot.Position).Magnitude)
                end
            end
            boxData.DistanceTag.Position = Vector2.new(boxPosition.X + boxSize.X/2, boxPosition.Y + boxSize.Y + 5)
            boxData.DistanceTag.Text = tostring(distance) .. "m"
            boxData.DistanceTag.Color = Color3.new(1, 1, 1)
            boxData.DistanceTag.Visible = true
        else
            boxData.DistanceTag.Visible = false
        end
        
        if BoxESPSettings.ShowTracer then
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            local worldCenterScreen = Camera:WorldToViewportPoint(worldCenter)
            if worldCenterScreen then
                boxData.Tracer.From = screenCenter
                boxData.Tracer.To = Vector2.new(worldCenterScreen.X, worldCenterScreen.Y)
                boxData.Tracer.Color = playerColor
                boxData.Tracer.Thickness = 2
                boxData.Tracer.Visible = true
            else
                boxData.Tracer.Visible = false
            end
        else
            boxData.Tracer.Visible = false
        end
    end
end

local function toggleBoxESP()
    if BoxESPSettings.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                createBoxESP(player)
            end
        end
        
        local playerAddedConnection
        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            wait(1)
            createBoxESP(player)
        end)
        
        local playerRemovingConnection
        playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
            removeBoxESP(player)
        end)
        
        local npcFolderConnection
        if NPCSFolder then
            npcFolderConnection = NPCSFolder.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    wait(0.5)
                    local player = Players:FindFirstChild(child.Name)
                    if player and player ~= localPlayer then
                        createBoxESP(player)
                    end
                end
            end)
            
            local npcFolderConnection2 = NPCSFolder.ChildRemoved:Connect(function(child)
                if child:IsA("Model") then
                    local player = Players:FindFirstChild(child.Name)
                    if player then
                        removeBoxESP(player)
                    end
                end
            end)
            
            boxESPConnections["NPCSFolderAdded"] = npcFolderConnection
            boxESPConnections["NPCSFolderRemoved"] = npcFolderConnection2
        end
        
        boxESPConnections["PlayerAdded"] = playerAddedConnection
        boxESPConnections["PlayerRemoving"] = playerRemovingConnection
        
        if not boxESPConnections["RenderStep"] then
            boxESPConnections["RenderStep"] = RunService.RenderStepped:Connect(updateBoxESP)
        end
    else
        if boxESPConnections["RenderStep"] then
            boxESPConnections["RenderStep"]:Disconnect()
            boxESPConnections["RenderStep"] = nil
        end
        
        for key, connection in pairs(boxESPConnections) do
            if type(connection) == "userdata" and connection.Disconnect then
                connection:Disconnect()
            end
        end
        boxESPConnections = {}
        
        for player, _ in pairs(boxESPPlayers) do
            removeBoxESP(player)
        end
        boxESPPlayers = {}
    end
end

local healthBarPlayers = {}
local healthBarConnections = {}

local function createHealthBar(player)
    if player == localPlayer then return end
    if healthBarPlayers[player] then return end
    
    local healthBarData = {
        HealthBar = Drawing.new("Line")
    }
    
    healthBarData.HealthBar.Visible = false
    healthBarData.HealthBar.Color = Color3.new(0, 1, 0)
    healthBarData.HealthBar.Thickness = HealthBarSettings.BarThickness
    
    healthBarPlayers[player] = healthBarData
end

local function removeHealthBar(player)
    if healthBarPlayers[player] then
        if healthBarPlayers[player].HealthBar then
            healthBarPlayers[player].HealthBar:Remove()
        end
        healthBarPlayers[player] = nil
    end
end

local function updateHealthBar()
    if not HealthBarSettings.Enabled then return end
    
    for player, healthBarData in pairs(healthBarPlayers) do
        if not player or not player.Parent then
            removeHealthBar(player)
            continue
        end
        
        if not isPlayerInNPCSFolder(player) then
            removeHealthBar(player)
            continue
        end
        
        local npcModel = NPCSFolder:FindFirstChild(player.Name)
        if not npcModel or not npcModel:IsA("Model") then
            removeHealthBar(player)
            continue
        end
        
        local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            if healthBarData then
                healthBarData.HealthBar.Visible = false
            end
            continue
        end
        
        local success, boxPosition, boxSize, worldCenter = pcall(function()
            return getAccurateScreenBoundingBox(npcModel)
        end)
        
        if not success or not boxPosition or not boxSize then
            if healthBarData then
                healthBarData.HealthBar.Visible = false
            end
            continue
        end
        
        local health = humanoid.Health / humanoid.MaxHealth
        local healthBarHeight = boxSize.Y * health
        local healthBarWidth = HealthBarSettings.BarWidth
        
        healthBarData.HealthBar.From = Vector2.new(
            boxPosition.X - healthBarWidth - 2, 
            boxPosition.Y + boxSize.Y - healthBarHeight
        )
        healthBarData.HealthBar.To = Vector2.new(
            boxPosition.X - healthBarWidth - 2, 
            boxPosition.Y + boxSize.Y
        )
        healthBarData.HealthBar.Color = Color3.new(1 - health, health, 0)
        healthBarData.HealthBar.Thickness = HealthBarSettings.BarThickness
        healthBarData.HealthBar.Visible = true
    end
end

local function toggleHealthBar()
    if HealthBarSettings.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                createHealthBar(player)
            end
        end
        
        local playerAddedConnection
        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            wait(1)
            createHealthBar(player)
        end)
        
        local playerRemovingConnection
        playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
            removeHealthBar(player)
        end)
        
        local npcFolderConnection
        if NPCSFolder then
            npcFolderConnection = NPCSFolder.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    wait(0.5)
                    local player = Players:FindFirstChild(child.Name)
                    if player and player ~= localPlayer then
                        createHealthBar(player)
                    end
                end
            end)
            
            local npcFolderConnection2 = NPCSFolder.ChildRemoved:Connect(function(child)
                if child:IsA("Model") then
                    local player = Players:FindFirstChild(child.Name)
                    if player then
                        removeHealthBar(player)
                    end
                end
            end)
            
            healthBarConnections["NPCSFolderAdded"] = npcFolderConnection
            healthBarConnections["NPCSFolderRemoved"] = npcFolderConnection2
        end
        
        healthBarConnections["PlayerAdded"] = playerAddedConnection
        healthBarConnections["PlayerRemoving"] = playerRemovingConnection
        
        if not healthBarConnections["RenderStep"] then
            healthBarConnections["RenderStep"] = RunService.RenderStepped:Connect(updateHealthBar)
        end
    else
        if healthBarConnections["RenderStep"] then
            healthBarConnections["RenderStep"]:Disconnect()
            healthBarConnections["RenderStep"] = nil
        end
        
        for key, connection in pairs(healthBarConnections) do
            if type(connection) == "userdata" and connection.Disconnect then
                connection:Disconnect()
            end
        end
        healthBarConnections = {}
        
        for player, _ in pairs(healthBarPlayers) do
            removeHealthBar(player)
        end
        healthBarPlayers = {}
    end
end

local thirdPersonConnection = nil

local function unlockThirdPerson()
    if Camera.CameraType == Enum.CameraType.Scriptable then
        Camera.CameraType = Enum.CameraType.Custom
    end
    
    localPlayer.CameraMode = Enum.CameraMode.Classic
    
    wait(0.1)
    localPlayer.CameraMaxZoomDistance = ThirdPersonSettings.MaxZoomDistance
    localPlayer.CameraMinZoomDistance = ThirdPersonSettings.MinZoomDistance
    
    local character = localPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end

local function toggleThirdPersonUnlocker()
    if thirdPersonConnection then
        thirdPersonConnection:Disconnect()
        thirdPersonConnection = nil
    end
    
    if ThirdPersonSettings.Enabled then
        thirdPersonConnection = RunService.Heartbeat:Connect(function()
            if localPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
                unlockThirdPerson()
            end
            
            if Camera.CameraType ~= Enum.CameraType.Custom then
                Camera.CameraType = Enum.CameraType.Custom
            end
            
            if localPlayer.CameraMaxZoomDistance < 5 then
                localPlayer.CameraMaxZoomDistance = ThirdPersonSettings.MaxZoomDistance
            end
        end)
        
        unlockThirdPerson()
    end
end

local originalDoorHandleProperties = {}
local doorHandleConnection = nil

local function modifyDoorHandle(part)
    if part:IsA("Part") and part.Name == "Handeol" then
        if not originalDoorHandleProperties[part] then
            originalDoorHandleProperties[part] = {
                Size = part.Size,
                CanCollide = part.CanCollide
            }
        end
        
        if DoorHandleSettings.Enabled then
            part.Size = originalDoorHandleProperties[part].Size * DoorHandleSettings.SizeMultiplier
            part.CanCollide = not DoorHandleSettings.NoCollision
        else
            if originalDoorHandleProperties[part] then
                part.Size = originalDoorHandleProperties[part].Size
                part.CanCollide = originalDoorHandleProperties[part].CanCollide
            end
        end
    end
end

local function updateAllDoorHandles()
    for _, part in ipairs(Workspace:GetDescendants()) do
        modifyDoorHandle(part)
    end
end

local function toggleDoorHandleSystem()
    if doorHandleConnection then
        doorHandleConnection:Disconnect()
        doorHandleConnection = nil
    end
    
    if DoorHandleSettings.Enabled then
        updateAllDoorHandles()
        
        doorHandleConnection = Workspace.DescendantAdded:Connect(function(descendant)
            modifyDoorHandle(descendant)
        end)
    else
        for part, originalProps in pairs(originalDoorHandleProperties) do
            if part and part.Parent then
                part.Size = originalProps.Size
                part.CanCollide = originalProps.CanCollide
            end
        end
    end
end

local FOVChangerConnection = nil

local function toggleFOVChanger()
    if FOVChangerConnection then
        FOVChangerConnection:Disconnect()
        FOVChangerConnection = nil
    end
    
    if FOVChangerSettings.Enabled then
        FOVChangerConnection = Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if Camera.FieldOfView ~= FOVChangerSettings.FOVValue then
                Camera.FieldOfView = FOVChangerSettings.FOVValue
            end
        end)
        Camera.FieldOfView = FOVChangerSettings.FOVValue
    end
end

local originalProperties = {}
local hitboxParts = {}

local function saveOriginalProperties(player)
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and not originalProperties[player] then
            originalProperties[player] = {
                Size = humanoidRootPart.Size,
                Transparency = humanoidRootPart.Transparency,
                BrickColor = humanoidRootPart.BrickColor,
                Material = humanoidRootPart.Material,
                CanCollide = humanoidRootPart.CanCollide
            }
        end
    end
end

local function restoreOriginalProperties(player)
    if originalProperties[player] and player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Size = originalProperties[player].Size
            humanoidRootPart.Transparency = originalProperties[player].Transparency
            humanoidRootPart.BrickColor = originalProperties[player].BrickColor
            humanoidRootPart.Material = originalProperties[player].Material
            humanoidRootPart.CanCollide = originalProperties[player].CanCollide
        end
    end
    if hitboxParts[player] then
        hitboxParts[player] = nil
    end
end

local function applyHitboxSettings(player)
    if not HitboxSettings.Enabled then return end
    if player == localPlayer then return end
    if not isPlayerInNPCSFolder(player) then 
        restoreOriginalProperties(player)
        return 
    end
    
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            saveOriginalProperties(player)
            
            local originalSize = originalProperties[player] and originalProperties[player].Size or humanoidRootPart.Size
            local newSize = Vector3.new(
                originalSize.X * HitboxSettings.WidthScale * HitboxSettings.OverallScale,
                originalSize.Y * HitboxSettings.HeightScale * HitboxSettings.OverallScale,
                originalSize.Z * HitboxSettings.DepthScale * HitboxSettings.OverallScale
            )
            
            humanoidRootPart.Size = newSize
            humanoidRootPart.Transparency = HitboxSettings.Transparency
            humanoidRootPart.BrickColor = BrickColor.new(HitboxSettings.Color)
            humanoidRootPart.Material = HitboxSettings.Material
            humanoidRootPart.CanCollide = false
            
            hitboxParts[player] = true
        end
    end
end

local function toggleHitboxSystem()
    if HitboxSettings.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and isPlayerInNPCSFolder(player) then
                applyHitboxSettings(player)
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                restoreOriginalProperties(player)
            end
        end
    end
end

local function updateAllHitboxes()
    if HitboxSettings.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and isPlayerInNPCSFolder(player) then
                applyHitboxSettings(player)
            end
        end
    end
end

local localAmmoBillboard = nil
local localAmmoTextLabel = nil
local localAmmoConnection = nil
local currentEquippedTool = nil

local function getWeaponAmmoInfo(player, isLocalPlayer)
    local character = player.Character
    if not character then return "", "" end
    
    local equippedWeapon = nil
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            equippedWeapon = tool
            break
        end
    end
    
    if not equippedWeapon then return "", "" end
    
    local ammoInfo = ""
    local chamberStatus = ""
    
    local hasChambers = false
    local chamberedCount = 0
    local totalChambers = 0
    
    for i = 1, 9 do
        local chamberAttr = equippedWeapon:GetAttribute("__chamber" .. tostring(i))
        if chamberAttr ~= nil then
            hasChambers = true
            totalChambers = totalChambers + 1
            if chamberAttr == true then
                chamberedCount = chamberedCount + 1
            end
        end
    end
    
    if hasChambers then
        ammoInfo = tostring(chamberedCount) .. "/" .. tostring(totalChambers)
        chamberStatus = ""
    else
        local magValue = equippedWeapon:GetAttribute("mag")
        
        if magValue then
            ammoInfo = tostring(magValue)
            
            local chamberedValue = equippedWeapon:GetAttribute("chambered")
            
            if isLocalPlayer then
                if chamberedValue == nil then
                    chamberStatus = "Ready"
                else
                    chamberStatus = chamberedValue and "Ready" or "Not Ready"
                end
            else
                if chamberedValue == nil then
                    chamberStatus = "Chambered: Yes"
                else
                    chamberStatus = chamberedValue and "Chambered: Yes" or "Chambered: No"
                end
            end
        else
            return "", ""
        end
    end
    
    return ammoInfo, chamberStatus
end

local function createWeaponAmmoDisplay(tool)
    if localAmmoBillboard then
        localAmmoBillboard:Destroy()
        localAmmoBillboard = nil
    end
    
    localAmmoBillboard = Instance.new("BillboardGui")
    localAmmoBillboard.Name = "WeaponAmmoDisplay"
    localAmmoBillboard.Adornee = tool
    localAmmoBillboard.Size = UDim2.new(0, 200, 0, 60)
    localAmmoBillboard.StudsOffset = Vector3.new(0, 0.5, 0)
    localAmmoBillboard.AlwaysOnTop = true
    localAmmoBillboard.Enabled = true
    localAmmoBillboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    localAmmoBillboard.Parent = tool
    
    localAmmoTextLabel = Instance.new("TextLabel")
    localAmmoTextLabel.Size = UDim2.new(1, 0, 1, 0)
    localAmmoTextLabel.BackgroundTransparency = 1
    localAmmoTextLabel.TextColor3 = LocalAmmoDisplaySettings.TextColor
    localAmmoTextLabel.TextSize = LocalAmmoDisplaySettings.TextSize
    localAmmoTextLabel.Font = LocalAmmoDisplaySettings.Font
    localAmmoTextLabel.Text = "Loading..."
    localAmmoTextLabel.TextStrokeTransparency = 0
    localAmmoTextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    localAmmoTextLabel.TextXAlignment = Enum.TextXAlignment.Center
    localAmmoTextLabel.TextYAlignment = Enum.TextYAlignment.Center
    localAmmoTextLabel.BorderSizePixel = 0
    localAmmoTextLabel.Parent = localAmmoBillboard
    
    currentEquippedTool = tool
end

local function updateLocalAmmoDisplay()
    if not LocalAmmoDisplaySettings.Enabled or not localAmmoTextLabel then return end
    
    local character = localPlayer.Character
    if not character then 
        if localAmmoTextLabel then
            localAmmoTextLabel.Text = "No character"
        end
        return
    end
    
    local equippedWeapon = nil
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            equippedWeapon = tool
            break
        end
    end
    
    if not equippedWeapon then
        if localAmmoTextLabel then
            localAmmoTextLabel.Text = "No weapon"
        end
        if localAmmoBillboard then
            localAmmoBillboard:Destroy()
            localAmmoBillboard = nil
            localAmmoTextLabel = nil
            currentEquippedTool = nil
        end
        return
    end
    
    if currentEquippedTool ~= equippedWeapon then
        createWeaponAmmoDisplay(equippedWeapon)
    end
    
    local ammoInfo, chamberStatus = getWeaponAmmoInfo(localPlayer, true)
    
    if ammoInfo == "" and chamberStatus == "" then
        if localAmmoTextLabel then
            localAmmoTextLabel.Text = ""
        end
    else
        if localAmmoTextLabel then
            if chamberStatus ~= "" then
                localAmmoTextLabel.Text = ammoInfo .. "\n" .. chamberStatus
            else
                localAmmoTextLabel.Text = ammoInfo
            end
        end
    end
end

local function monitorWeaponChanges()
    local function onCharacterAdded(character)
        wait(1)
        
        local function onChildAdded(child)
            if child:IsA("Tool") then
                wait(0.1)
                if LocalAmmoDisplaySettings.Enabled then
                    createWeaponAmmoDisplay(child)
                end
            end
        end
        
        local function onChildRemoved(child)
            if child:IsA("Tool") and child == currentEquippedTool then
                if localAmmoBillboard then
                    localAmmoBillboard:Destroy()
                    localAmmoBillboard = nil
                    localAmmoTextLabel = nil
                    currentEquippedTool = nil
                end
            end
        end
        
        character.ChildAdded:Connect(onChildAdded)
        character.ChildRemoved:Connect(onChildRemoved)
        
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
                if LocalAmmoDisplaySettings.Enabled then
                    createWeaponAmmoDisplay(child)
                end
                break
            end
        end
    end
    
    if localPlayer.Character then
        onCharacterAdded(localPlayer.Character)
    end
    localPlayer.CharacterAdded:Connect(onCharacterAdded)
end

local function toggleLocalAmmoDisplay()
    if LocalAmmoDisplaySettings.Enabled then
        monitorWeaponChanges()
        
        if localAmmoConnection then
            localAmmoConnection:Disconnect()
        end
        
        localAmmoConnection = RunService.Heartbeat:Connect(function()
            updateLocalAmmoDisplay()
        end)
    else
        if localAmmoConnection then
            localAmmoConnection:Disconnect()
            localAmmoConnection = nil
        end
        
        if localAmmoBillboard then
            localAmmoBillboard:Destroy()
            localAmmoBillboard = nil
            localAmmoTextLabel = nil
            currentEquippedTool = nil
        end
    end
end

local rolesChecked = false
local lastRoleCheck = 0
local ROLE_CHECK_INTERVAL = 10

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

local function isToolEquippedByPlayer(tool)
    if tool.Parent and tool.Parent:IsA("Model") then
        local humanoid = tool.Parent:FindFirstChildOfClass("Humanoid")
        return humanoid ~= nil
    end
    return false
end

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

local function getAmmoInfoWithDistance(player, distance)
    if distance > MaxItemsDistance then
        return ""
    end
    
    local ammoInfo, chamberStatus = getWeaponAmmoInfo(player, false)
    
    if ammoInfo == "" then
        return ""
    end
    
    if chamberStatus ~= "" then
        return ammoInfo .. " " .. chamberStatus
    else
        return ammoInfo
    end
end

local function getDistanceToPlayer(player)
    if not localPlayer.Character then return math.huge end
    
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if not localRoot or not playerRoot then return math.huge end
    
    return (localRoot.Position - playerRoot.Position).Magnitude
end

local function createDisplayText(playerName, weapons, distance)
    local displayLines = {}
    
    if ESPVisibilitySettings.ShowName then
        local player = Players:FindFirstChild(playerName)
        local hintIndicator = ""
        if player and playersMatchingHints[player] then
            hintIndicator = " [HINT]"
        end
        
        if player then
            local playerTeam = getPlayerTeam(player)
            if playerTeam then
                table.insert(displayLines, playerName .. " [" .. playerTeam .. "]" .. hintIndicator)
            else
                table.insert(displayLines, playerName .. hintIndicator)
            end
        else
            table.insert(displayLines, playerName .. hintIndicator)
        end
    end
    
    if ESPVisibilitySettings.ShowTools then
        local weaponText = formatWeaponsList(weapons, distance)
        table.insert(displayLines, weaponText)
    end
    
    if ESPVisibilitySettings.ShowAmmoInfo then
        local player = Players:FindFirstChild(playerName)
        if player then
            local ammoText = getAmmoInfoWithDistance(player, distance)
            if ammoText ~= "" then
                table.insert(displayLines, ammoText)
            end
        end
    end
    
    return table.concat(displayLines, "\n")
end

local activeESPGuis = {}
local activeWeaponHighlights = {}

local function forceUpdateESP()
    if not ESPEnabled then return end
    
    for player, espData in pairs(activeESPGuis) do
        if player and player.Parent and player.Character and espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
            local weapons = getPlayerWeapons(player)
            local distance = getDistanceToPlayer(player)
            local displayText = createDisplayText(player.Name, weapons, distance)
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

local function updateAllESPDisplays()
    for player, espData in pairs(activeESPGuis) do
        if player and player.Parent and player.Character and espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
            if not isPlayerInNPCSFolder(player) then
                if espData.billboardGui then
                    espData.billboardGui:Destroy()
                end
                if espData.highlight then
                    espData.highlight:Destroy()
                end
                activeESPGuis[player] = nil
            else
                local weapons = getPlayerWeapons(player)
                local distance = getDistanceToPlayer(player)
                local displayText = createDisplayText(player.Name, weapons, distance)
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
end

local function createPlayerESP(player)
    if not ESPEnabled then return end
    if player == localPlayer then return end
    if not isPlayerInNPCSFolder(player) then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local weapons = getPlayerWeapons(player)
    local distance = getDistanceToPlayer(player)
    local displayText = createDisplayText(player.Name, weapons, distance)
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
    billboardGui.Size = UDim2.new(0, 200, 0, 100)
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

local function onPlayerAdded(player)
    if not ESPEnabled then return end
    
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
    
    if player.Character and isPlayerInNPCSFolder(player) then
        onCharacterAdded(player.Character, player)
    end
end

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

local eventConnections = {}
local mainLoopConnection = nil
local fastScanConnection = nil
local weaponMonitorConnection = nil

local function enableESP()
    if ESPEnabled then return end
    ESPEnabled = true
    
    connectHintTextSignal()
    
    eventConnections.playerAdded = Players.PlayerAdded:Connect(onPlayerAdded)
    eventConnections.playerRemoving = Players.PlayerRemoving:Connect(onPlayerRemoving)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and isPlayerInNPCSFolder(player) then
            onPlayerAdded(player)
        end
    end
    
    weaponMonitorConnection = monitorWorkspaceForWeapons()
    
    local updateCounter = 0
    local hintCheckCounter = 0
    local forceUpdateCounter = 0
    
    mainLoopConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not ESPEnabled then return end
        
        updateCounter = updateCounter + deltaTime
        hintCheckCounter = hintCheckCounter + deltaTime
        forceUpdateCounter = forceUpdateCounter + deltaTime
        
        if forceUpdateCounter >= 0.5 then
            forceUpdateCounter = 0
            forceUpdateESP()
        end
        
        if updateCounter >= ESPUpdateRate then
            updateCounter = 0
            
            for player, _ in pairs(activeESPGuis) do
                if player and player.Parent and player.Character then
                    if not isPlayerInNPCSFolder(player) then
                        if activeESPGuis[player] then
                            if activeESPGuis[player].billboardGui then
                                activeESPGuis[player].billboardGui:Destroy()
                            end
                            if activeESPGuis[player].highlight then
                                activeESPGuis[player].highlight:Destroy()
                            end
                            activeESPGuis[player] = nil
                        end
                    else
                        local weapons = getPlayerWeapons(player)
                        local distance = getDistanceToPlayer(player)
                        local displayText = createDisplayText(player.Name, weapons, distance)
                        local color = getPlayerColor(player)
                        
                        local espData = activeESPGuis[player]
                        if espData and espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
                            local textLabel = espData.billboardGui:FindFirstChildOfClass("TextLabel")
                            if textLabel then
                                textLabel.Text = displayText
                                textLabel.TextColor3 = color
                            end
                            
                            if espData.highlight and espData.highlight:IsDescendantOf(game) then
                                espData.highlight.FillColor = color
                                espData.highlight.OutlineColor = color
                            end
                        end
                    end
                end
            end
        end
        
        if hintCheckCounter >= 2 then
            hintCheckCounter = 0
            updateMatchingHintPlayers()
            forceUpdateESP()
        end
    end)
    
    fastScanConnection = RunService.Heartbeat:Connect(function()
        if not ESPEnabled then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and not activeESPGuis[player] and player.Character and isPlayerInNPCSFolder(player) then
                createPlayerESP(player)
            end
        end
    end)
end

local function disableESP()
    if not ESPEnabled then return end
    ESPEnabled = false
    
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
FOVCircle.Position = Vector2.new(CameraViewportSize.X / 2, Camera.ViewportSize.Y / 2)

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
    local totalDistance = direction.Magnitude
    
    if totalDistance > AimbotSettings.MaxDistance then
        VisibilityCache[target] = {visible = false, time = currentTime}
        return false
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local ignoredParts = {localPlayer.Character, target.Character}
    raycastParams.FilterDescendantsInstances = ignoredParts
    
    local currentOrigin = origin
    local traveledDistance = 0
    local maxTravelDistance = totalDistance * 1.1
    local layersPassed = 0
    
    while layersPassed < AimbotSettings.MaxWallLayers and traveledDistance < maxTravelDistance do
        local remainingDistance = totalDistance - traveledDistance
        local result = workspace:Raycast(currentOrigin, direction.Unit * remainingDistance, raycastParams)
        
        if not result then
            VisibilityCache[target] = {visible = true, time = currentTime}
            return true
        end
        
        local hitPart = result.Instance
        local hitPosition = result.Position
        local hitDistance = (hitPosition - currentOrigin).Magnitude
        
        local distanceToTarget = (targetPosition - hitPosition).Magnitude
        if distanceToTarget <= AimbotSettings.CheckPrecision then
            VisibilityCache[target] = {visible = true, time = currentTime}
            return true
        end
        
        local transparency = hitPart.Transparency
        local material = hitPart.Material
        
        local isTransparent = (transparency >= AimbotSettings.TransparencyThreshold) or 
                             (AimbotSettings.ForceFieldAlwaysTransparent and material == Enum.Material.ForceField)
        
        if not isTransparent then
            VisibilityCache[target] = {visible = false, time = currentTime}
            return false
        end
        
        table.insert(ignoredParts, hitPart)
        raycastParams.FilterDescendantsInstances = ignoredParts
        currentOrigin = hitPosition + direction.Unit * 0.05
        traveledDistance = traveledDistance + hitDistance
        layersPassed = layersPassed + 1
    end
    
    VisibilityCache[target] = {visible = false, time = currentTime}
    return false
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
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
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

local Window = Rayfield:CreateWindow({
    Name = "RADIO HUB",
    LoadingTitle = "RADIO HUB",
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

local function safeCreateElement(tab, elementType, options)
    local success, result = pcall(function()
        if elementType == "Toggle" then
            return tab:CreateToggle(options)
        elseif elementType == "Slider" then
            return tab:CreateSlider(options)
        elseif elementType == "Button" then
            return tab:CreateButton(options)
        elseif elementType == "Dropdown" then
            return tab:CreateDropdown(options)
        elseif elementType == "ColorPicker" then
            return tab:CreateColorPicker(options)
        elseif elementType == "Keybind" then
            return tab:CreateKeybind(options)
        elseif elementType == "Label" then
            return tab:CreateLabel(options)
        elseif elementType == "Section" then
            return tab:CreateSection(options)
        end
    end)
    
    if not success then
        warn("Failed to create " .. elementType .. ": " .. tostring(result))
        return nil
    end
    
    return result
end

local ESPTab = Window:CreateTab("ESP", 4483362458)

safeCreateElement(ESPTab, "Toggle", {
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

safeCreateElement(ESPTab, "Section", {
    Name = "Health Bar ESP Settings"
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Health Bar ESP",
    CurrentValue = HealthBarSettings.Enabled,
    Flag = "HealthBarESPEnabled",
    Callback = function(Value)
        HealthBarSettings.Enabled = Value
        toggleHealthBar()
    end,
})

safeCreateElement(ESPTab, "Slider", {
    Name = "Health Bar Thickness",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = HealthBarSettings.BarThickness,
    Flag = "HealthBarThickness",
    Callback = function(Value)
        HealthBarSettings.BarThickness = Value
        for _, healthBarData in pairs(healthBarPlayers) do
            if healthBarData.HealthBar then
                healthBarData.HealthBar.Thickness = Value
            end
        end
    end,
})

safeCreateElement(ESPTab, "Slider", {
    Name = "Health Bar Width",
    Range = {5, 20},
    Increment = 1,
    Suffix = "px",
    CurrentValue = HealthBarSettings.BarWidth,
    Flag = "HealthBarWidth",
    Callback = function(Value)
        HealthBarSettings.BarWidth = Value
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Box ESP Settings"
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Box ESP Enabled",
    CurrentValue = BoxESPSettings.Enabled,
    Flag = "BoxESPEnabled",
    Callback = function(Value)
        BoxESPSettings.Enabled = Value
        toggleBoxESP()
    end,
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Distance",
    CurrentValue = BoxESPSettings.ShowDistance,
    Flag = "BoxESPDistance",
    Callback = function(Value)
        BoxESPSettings.ShowDistance = Value
    end,
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Tracer",
    CurrentValue = BoxESPSettings.ShowTracer,
    Flag = "BoxESPTracer",
    Callback = function(Value)
        BoxESPSettings.ShowTracer = Value
    end,
})

safeCreateElement(ESPTab, "Slider", {
    Name = "Box Thickness",
    Range = {1, 8},
    Increment = 1,
    Suffix = "",
    CurrentValue = BoxESPSettings.Thickness,
    Flag = "BoxESPThickness",
    Callback = function(Value)
        BoxESPSettings.Thickness = Value
        for _, boxData in pairs(boxESPPlayers) do
            if boxData.Box then
                boxData.Box.Thickness = Value
            end
        end
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Visibility Settings"
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Player Names",
    CurrentValue = ESPVisibilitySettings.ShowName,
    Flag = "ShowPlayerNames",
    Callback = function(Value)
        ESPVisibilitySettings.ShowName = Value
        forceUpdateESP()
    end,
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Tools/Weapons",
    CurrentValue = ESPVisibilitySettings.ShowTools,
    Flag = "ShowTools",
    Callback = function(Value)
        ESPVisibilitySettings.ShowTools = Value
        forceUpdateESP()
    end,
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Ammo Info",
    CurrentValue = ESPVisibilitySettings.ShowAmmoInfo,
    Flag = "ShowAmmoInfo",
    Callback = function(Value)
        ESPVisibilitySettings.ShowAmmoInfo = Value
        forceUpdateESP()
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Local Ammo Display"
})

safeCreateElement(ESPTab, "Toggle", {
    Name = "Show Local Ammo Info",
    CurrentValue = LocalAmmoDisplaySettings.Enabled,
    Flag = "LocalAmmoDisplayEnabled",
    Callback = function(Value)
        LocalAmmoDisplaySettings.Enabled = Value
        toggleLocalAmmoDisplay()
    end,
})

safeCreateElement(ESPTab, "ColorPicker", {
    Name = "Text Color",
    Color = LocalAmmoDisplaySettings.TextColor,
    Flag = "LocalAmmoTextColor",
    Callback = function(Value)
        LocalAmmoDisplaySettings.TextColor = Value
        if localAmmoTextLabel then
            localAmmoTextLabel.TextColor3 = Value
        end
    end
})

safeCreateElement(ESPTab, "Slider", {
    Name = "Text Size",
    Range = {12, 48},
    Increment = 1,
    Suffix = "",
    CurrentValue = LocalAmmoDisplaySettings.TextSize,
    Flag = "LocalAmmoTextSize",
    Callback = function(Value)
        LocalAmmoDisplaySettings.TextSize = Value
        if localAmmoTextLabel then
            localAmmoTextLabel.TextSize = Value
        end
    end,
})

safeCreateElement(ESPTab, "Button", {
    Name = "Force Update ESP Colors",
    Callback = function()
        forceUpdateESP()
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Distance Settings"
})

safeCreateElement(ESPTab, "Slider", {
    Name = "Items & Ammo Display Distance",
    Range = {10, 200},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = MaxItemsDistance,
    Flag = "ItemsAmmoDisplayDistance",
    Callback = function(Value)
        MaxItemsDistance = Value
        forceUpdateESP()
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Performance"
})
safeCreateElement(ESPTab, "Slider", {
    Name = "Update Rate",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = ESPUpdateRate,
    Flag = "ESPUpdateRate",
    Callback = function(Value)
        ESPUpdateRate = Value
        if ESPEnabled then
            disableESP()
            wait(0.1)
            enableESP()
        end
    end,
})

safeCreateElement(ESPTab, "Section", {
    Name = "Visual"
})
safeCreateElement(ESPTab, "Slider", {
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

safeCreateElement(ESPTab, "Section", {
    Name = "Controls"
})
safeCreateElement(ESPTab, "Button", {
    Name = "Refresh ESP",
    Callback = function()
        if ESPEnabled then
            disableESP()
            wait(0.1)
            enableESP()
        end
    end,
})

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

safeCreateElement(AimbotTab, "Toggle", {
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

safeCreateElement(AimbotTab, "Toggle", {
    Name = "Team Check",
    CurrentValue = AimbotSettings.TeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        AimbotSettings.TeamCheck = Value
    end,
})

safeCreateElement(AimbotTab, "Slider", {
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

safeCreateElement(AimbotTab, "Toggle", {
    Name = "Health Check",
    CurrentValue = AimbotSettings.HealthCheck,
    Flag = "AimbotHealthCheck",
    Callback = function(Value)
        AimbotSettings.HealthCheck = Value
    end,
})

safeCreateElement(AimbotTab, "Slider", {
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

safeCreateElement(AimbotTab, "Section", {
    Name = "Advanced Wall Check"
})

safeCreateElement(AimbotTab, "Toggle", {
    Name = "Wall Check",
    CurrentValue = AimbotSettings.WallCheck,
    Flag = "AimbotWallCheck",
    Callback = function(Value)
        AimbotSettings.WallCheck = Value
        VisibilityCache = {}
    end,
})

safeCreateElement(AimbotTab, "Slider", {
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

safeCreateElement(AimbotTab, "Dropdown", {
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

safeCreateElement(AimbotTab, "Section", {
    Name = "Random Aim Part"
})

safeCreateElement(AimbotTab, "Toggle", {
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

safeCreateElement(AimbotTab, "Slider", {
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

safeCreateElement(AimbotTab, "Slider", {
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

safeCreateElement(AimbotTab, "Toggle", {
    Name = "Show FOV Circle",
    CurrentValue = FOVCircle.Visible,
    Flag = "ShowFOVCircle",
    Callback = function(Value)
        FOVCircle.Visible = Value
    end,
})

local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

safeCreateElement(HitboxTab, "Section", {
    Name = "Hitbox Settings"
})

safeCreateElement(HitboxTab, "Toggle", {
    Name = "Hitbox Enabled",
    CurrentValue = HitboxSettings.Enabled,
    Flag = "HitboxEnabled",
    Callback = function(Value)
        HitboxSettings.Enabled = Value
        toggleHitboxSystem()
    end,
})

safeCreateElement(HitboxTab, "Section", {
    Name = "Keybind Settings"
})

safeCreateElement(HitboxTab, "Keybind", {
    Name = "Toggle Hitbox Keybind",
    CurrentKeybind = HitboxSettings.ToggleKey,
    HoldToInteract = false,
    Flag = "HitboxKeybind",
    Callback = function(Key)
        HitboxSettings.ToggleKey = Key
    end,
})

safeCreateElement(HitboxTab, "Section", {
    Name = "Hitbox Size Controls"
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Overall Scale",
    Range = {1.0, 10.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = HitboxSettings.OverallScale,
    Flag = "HitboxOverallScale",
    Callback = function(Value)
        HitboxSettings.OverallScale = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Height Scale",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = HitboxSettings.HeightScale,
    Flag = "HitboxHeightScale",
    Callback = function(Value)
        HitboxSettings.HeightScale = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Width Scale",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = HitboxSettings.WidthScale,
    Flag = "HitboxWidthScale",
    Callback = function(Value)
        HitboxSettings.WidthScale = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Depth Scale",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = HitboxSettings.DepthScale,
    Flag = "HitboxDepthScale",
    Callback = function(Value)
        HitboxSettings.DepthScale = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "Section", {
    Name = "Hitbox Appearance"
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = HitboxSettings.Transparency,
    Flag = "HitboxTransparency",
    Callback = function(Value)
        HitboxSettings.Transparency = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "ColorPicker", {
    Name = "Hitbox Color",
    Color = HitboxSettings.Color,
    Flag = "HitboxColor",
    Callback = function(Value)
        HitboxSettings.Color = Value
        updateAllHitboxes()
    end
})

safeCreateElement(HitboxTab, "Dropdown", {
    Name = "Material",
    Options = {"Neon", "Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", "DiamondPlate", "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand", "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone", "Air", "Water", "Rock", "Glacier", "Snow", "Sandstone", "Mud", "Basalt", "Ground", "CrackedLava", "Asphalt", "LeafyGrass", "Salt", "Limestone", "Pavement"},
    CurrentValue = HitboxSettings.Material,
    Flag = "HitboxMaterial",
    Callback = function(Value)
        HitboxSettings.Material = Value
        updateAllHitboxes()
    end,
})

safeCreateElement(HitboxTab, "Section", {
    Name = "Door Handle Settings"
})

safeCreateElement(HitboxTab, "Toggle", {
    Name = "Door Handle Modification",
    CurrentValue = DoorHandleSettings.Enabled,
    Flag = "DoorHandleEnabled",
    Callback = function(Value)
        DoorHandleSettings.Enabled = Value
        toggleDoorHandleSystem()
    end,
})

safeCreateElement(HitboxTab, "Slider", {
    Name = "Door Handle Size Multiplier",
    Range = {2, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = DoorHandleSettings.SizeMultiplier,
    Flag = "DoorHandleSize",
    Callback = function(Value)
        DoorHandleSettings.SizeMultiplier = Value
        updateAllDoorHandles()
    end,
})

safeCreateElement(HitboxTab, "Toggle", {
    Name = "Disable Door Handle Collision",
    CurrentValue = DoorHandleSettings.NoCollision,
    Flag = "DoorHandleNoCollision",
    Callback = function(Value)
        DoorHandleSettings.NoCollision = Value
        updateAllDoorHandles()
    end,
})

safeCreateElement(HitboxTab, "Section", {
    Name = "Hitbox Controls"
})

safeCreateElement(HitboxTab, "Button", {
    Name = "Refresh Hitboxes",
    Callback = function()
        updateAllHitboxes()
    end,
})

local OthersTab = Window:CreateTab("Others", 4483362458)

safeCreateElement(OthersTab, "Section", {
    Name = "FOV Changer"
})

safeCreateElement(OthersTab, "Toggle", {
    Name = "FOV Changer Enabled",
    CurrentValue = FOVChangerSettings.Enabled,
    Flag = "FOVChangerEnabled",
    Callback = function(Value)
        FOVChangerSettings.Enabled = Value
        toggleFOVChanger()
    end,
})

safeCreateElement(OthersTab, "Slider", {
    Name = "FOV Value",
    Range = {50, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = FOVChangerSettings.FOVValue,
    Flag = "FOVValue",
    Callback = function(Value)
        FOVChangerSettings.FOVValue = Value
        if FOVChangerSettings.Enabled then
            Camera.FieldOfView = FOVChangerSettings.FOVValue
        end
    end,
})

safeCreateElement(OthersTab, "Section", {
    Name = "Third Person Unlocker"
})

safeCreateElement(OthersTab, "Toggle", {
    Name = "Third Person Unlocker",
    CurrentValue = ThirdPersonSettings.Enabled,
    Flag = "ThirdPersonEnabled",
    Callback = function(Value)
        ThirdPersonSettings.Enabled = Value
        toggleThirdPersonUnlocker()
    end,
})

safeCreateElement(OthersTab, "Slider", {
    Name = "Max Zoom Distance",
    Range = {5, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = ThirdPersonSettings.MaxZoomDistance,
    Flag = "ThirdPersonMaxZoom",
    Callback = function(Value)
        ThirdPersonSettings.MaxZoomDistance = Value
        if ThirdPersonSettings.Enabled then
            localPlayer.CameraMaxZoomDistance = Value
        end
    end,
})

safeCreateElement(OthersTab, "Slider", {
    Name = "Min Zoom Distance",
    Range = {0, 10},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = ThirdPersonSettings.MinZoomDistance,
    Flag = "ThirdPersonMinZoom",
    Callback = function(Value)
        ThirdPersonSettings.MinZoomDistance = Value
        if ThirdPersonSettings.Enabled then
            localPlayer.CameraMinZoomDistance = Value
        end
    end,
})

local hitboxKeyConnection
hitboxKeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == HitboxSettings.ToggleKey then
        HitboxSettings.Enabled = not HitboxSettings.Enabled
        toggleHitboxSystem()
    end
end)

local hitboxLoopConnection
hitboxLoopConnection = RunService.Heartbeat:Connect(function()
    if HitboxSettings.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and isPlayerInNPCSFolder(player) then
                pcall(function()
                    applyHitboxSettings(player)
                end)
            end
        end
    end
end)

local function setupHitboxPlayerHandlers()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if HitboxSettings.Enabled and isPlayerInNPCSFolder(player) then
                applyHitboxSettings(player)
            end
        end)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        originalProperties[player] = nil
        hitboxParts[player] = nil
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if HitboxSettings.Enabled and isPlayerInNPCSFolder(player) then
                    applyHitboxSettings(player)
                end
            end)
        end
    end
end

setupHitboxPlayerHandlers()

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

Players.PlayerRemoving:Connect(function(player)
    originalProperties[player] = nil
    hitboxParts[player] = nil
end)

Rayfield:LoadConfiguration()

startAimbotLoop()

if FOVChangerSettings.Enabled then
    toggleFOVChanger()
end

if DoorHandleSettings.Enabled then
    toggleDoorHandleSystem()
end

if ThirdPersonSettings.Enabled then
    toggleThirdPersonUnlocker()
end

if BoxESPSettings.Enabled then
    toggleBoxESP()
end

if HealthBarSettings.Enabled then
    toggleHealthBar()
end

if LocalAmmoDisplaySettings.Enabled then
    toggleLocalAmmoDisplay()
end
