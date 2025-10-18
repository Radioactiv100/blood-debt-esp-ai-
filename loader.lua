-- LocalScript в StarterPlayer.StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

-- Define weapon lists
local killerWeapons = {"K1911", "HWISSH-KP9", "RR-LightCompactPistol", "HEARDBALLA", "JS2-Derringy" , "JS1-Cyclops", "WISP", "Jolibri", "Rosen-Obrez", "Mares Leg", "Sawn-off", "JTS225-Obrez", "Mandols-5", "ZOZ-106", "SKORPION", "ZZ-90", "MAK-10", "Micro KZI", "LUT-E 'KRUS'", "Hammer n Bullet", "Comically Large Spoon", "JS-44", "RR-Mark2", "JS-22", "AGM22", "JS1-Competitor", "Doorbler", "JAVELIN-OBREZS", "Whizz", "Kensington", "THUMPA", "Merretta 486", "Palubu,ZOZ-106", "Kamatov", "RR-LightCompactPistolS","Meretta486Palubu Sawn-Off","Wild Mandols-5","MAK-1020","CharcoalSteel JS-22", "ChromeSlide Turqoise RR-LCP", "Skeleton Rosen-Obrez", "Dual LCPs", "Mares Leg10", "JTS225-Obrez Partycannon", "CharcoalSteel JS-44", "corrodedmetal JS-22", "KamatovS", "JTS225-Obrez Monochrome", "Door'bler", "Clothed SKORPION", "K1911GILDED", "Kensington20", "WISP Pearl", "JS2-BondsDerringy", "JS1-CYCLOPS", "Dual SKORPS", "Clothed Rosen-Obrez", "GraySteel K1911", "Rosen-ObrezGILDED", "PLASTIC JS-22", "CharcoalSteel SKORPION", "Clothed Sawn-off", "Pretty Pink RR-LCP", "Whiteout RR-LightCompactPistolS", "Sawn-off10", "Whiteout Rosen-Obrez", "SKORPION10", "Katya's 'Memories'", "JS2-DerringyGILDED"}
local sheriffWeapons = {"IZVEKH-412", "J9-Meretta", "RR-Snubby", "Beagle", "HW-M5K", "DRICO", "ZKZ-Obrez", "Buxxberg-COMPACT", "JS-5A-OBREZ", "Dual Elites", "HWISSH-226", "GG-17", "Pretty Pink Buxxberg-COMPACT","GG-1720", "JS-5A-Obrez", "Case Hardened DRICO", "GG-17 TAN", "Dual GG-17s", "CharcoalSteel I412", "ZKZ-Obrez10", "SilverSteel RR-Snubby", "Clothed ZKZ-Obrez", "Pretty Pink GG-17"} 

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
    ["Street Gang"] = Color3.fromRGB(255, 0, 0), -- Красный
    ["Bratva"] = Color3.fromRGB(0, 0, 255), -- Синий
    ["Nubagami"] = Color3.fromRGB(0, 255, 0), -- Зеленый
    ["Heist crew"] = Color3.fromRGB(255, 255, 0), -- Желтый
    ["Politsiya"] = Color3.fromRGB(0, 255, 255), -- Голубой
    ["The Zoo"] = Color3.fromRGB(255, 0, 255), -- Розовый
    ["The Trinity"] = Color3.fromRGB(255, 165, 0), -- Оранжевый
    ["Hoboes"] = Color3.fromRGB(128, 0, 128), -- Фиолетовый
    ["Hooligans"] = Color3.fromRGB(165, 42, 42), -- Коричневый
    ["The Noobic Union"] = Color3.fromRGB(0, 128, 128), -- Бирюзовый
    ["NETO"] = Color3.fromRGB(128, 128, 128), -- Серый
    ["Juggernaut"] = Color3.fromRGB(139, 0, 0), -- Темно-красный
    ["Robbers"] = Color3.fromRGB(255, 140, 0) -- Темно-оранжевый
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
        "Tsezar Bortsov", "Aleksai Solovev", "Nikolai Gerasimov", "Hasyan Sunayev"
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
        -- Clean name (remove punctuation and extra spaces)
        local cleanName = memberName:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
        teamLookup[teamName][cleanName] = true
        characterToTeam[cleanName] = teamName
    end
end

-- Cache variables for optimization
local rolesChecked = false
local lastRoleCheck = 0
local ROLE_CHECK_INTERVAL = 10 -- Check roles every 10 seconds

-- Function to check if roles are present in the game (optimized)
local function checkForRoles()
    local currentTime = tick()
    if currentTime - lastRoleCheck < ROLE_CHECK_INTERVAL then
        return rolesChecked
    end
    
    lastRoleCheck = currentTime
    
    -- Quick check: look for any BillboardGui with team names
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local textLabel = obj:FindFirstChildOfClass("TextLabel")
            if textLabel and textLabel.Text then
                local text = textLabel.Text:gsub("[%,%.]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                
                -- Quick team name check
                for teamName in pairs(teams) do
                    if text:find(teamName, 1, true) then
                        rolesChecked = true
                        return true
                    end
                end
            end
        end
    end
    
    -- If no billboard found, check NPCs (limited check)
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
            break -- Only check first NPC for performance
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

-- Cache for player weapons to reduce calls
local playerWeaponsCache = {}
local WEAPONS_CACHE_TIME = 5 -- Cache weapons for 5 seconds

-- Function to get a player's weapons (with caching)
local function getPlayerWeapons(player)
    local currentTime = tick()
    local cache = playerWeaponsCache[player]
    
    if cache and currentTime - cache.time < WEAPONS_CACHE_TIME then
        return cache.weapons
    end
    
    local weapons = {}
    local character = player.Character
    
    -- Only check backpack if character exists
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
    
    -- Update cache
    playerWeaponsCache[player] = {
        weapons = weapons,
        time = currentTime
    end
    
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

-- Function to determine weapon type and color (guncheck mode)
local function getWeaponColor(weapons)
    if #weapons == 0 then
        return Color3.fromRGB(0, 255, 0) -- Зеленый для отсутствия оружия
    end

    for _, weaponName in ipairs(weapons) do
        if killerWeaponsLookup[weaponName] then
            return Color3.fromRGB(255, 0, 0) -- Красный для киллера
        end

        if sheriffWeaponsLookup[weaponName] then
            return Color3.fromRGB(0, 0, 255) -- Синий для шерифа
        end
    end

    return Color3.fromRGB(0, 255, 0) -- Зеленый для других оружий
end

-- Function to get player's team based on character display name
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

-- Function to determine player color (уникальные цвета для команд)
local function getPlayerColor(player)
    local rolesFound = checkForRoles()
    
    if rolesFound then
        -- Режим команд: используем уникальный цвет для каждой команды
        local playerTeam = getPlayerTeam(player)
        if playerTeam and teamColors[playerTeam] then
            return teamColors[playerTeam]
        else
            -- Если команда не определена, используем белый цвет
            return Color3.fromRGB(255, 255, 255)
        end
    else
        -- Guncheck mode: use weapon-based logic
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

-- Function to format weapons list with distance check
local function formatWeaponsList(weapons, distance)
    local MAX_ITEMS_DISTANCE = 75 -- Дистанция для отображения предметов
    
    if distance > MAX_ITEMS_DISTANCE then
        return "..." -- Показываем многоточие, если игрок далеко
    end
    
    if #weapons == 0 then
        return "Нет предметов"
    else
        -- Показываем все предметы, если игрок близко
        return table.concat(weapons, ", ")
    end
end

-- Function to create display text with distance check and health
local function createDisplayText(playerName, weapons, distance, currentHealth, maxHealth)
    local weaponText = formatWeaponsList(weapons, distance)
    local healthText = "HP: " .. currentHealth .. "/" .. maxHealth
    
    -- Add team info if available
    local player = Players:FindFirstChild(playerName)
    if player then
        local playerTeam = getPlayerTeam(player)
        if playerTeam then
            return playerName .. " [" .. playerTeam .. "]\n" .. weaponText .. "\n" .. healthText
        end
    end
    
    return playerName .. "\n" .. weaponText .. "\n" .. healthText
end

-- Table to store active ESP elements
local activeESPGuis = {}
local activeWeaponHighlights = {}

-- Configuration
local HIGHLIGHT_LIFETIME = 10
local FADE_DURATION = 2

-- Function to clean up old highlights
local function cleanupOldHighlights()
    local currentTime = tick()
    local playersToRemove = {}
    
    for player, espData in pairs(activeESPGuis) do
        if currentTime - espData.createTime > HIGHLIGHT_LIFETIME then
            if espData.highlight and espData.highlight:IsDescendantOf(game) then
                local tweenInfo = TweenInfo.new(FADE_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local fadeTween = TweenService:Create(espData.highlight, tweenInfo, {FillTransparency = 1, OutlineTransparency = 1})
                fadeTween:Play()
                espData.fadeTween = fadeTween
                espData.fadeStartTime = currentTime
            end
            
            if espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
                local textLabel = espData.billboardGui:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local textTween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
                    textTween:Play()
                end
            end
        end
        
        if espData.fadeStartTime and currentTime - espData.fadeStartTime > FADE_DURATION then
            table.insert(playersToRemove, player)
        end
    end
    
    for _, player in ipairs(playersToRemove) do
        if activeESPGuis[player] then
            if activeESPGuis[player].billboardGui then
                activeESPGuis[player].billboardGui:Destroy()
            end
            if activeESPGuis[player].highlight then
                activeESPGuis[player].highlight:Destroy()
            end
            activeESPGuis[player] = nil
        end
    end
end

-- Function to highlight dropped weapons
local function highlightDroppedWeapon(tool)
    if not tool:IsA("Tool") then return end
    if activeWeaponHighlights[tool] then return end
    
    if tool:IsDescendantOf(Workspace) and not isToolEquippedByPlayer(tool) then
        local weaponColor = Color3.fromRGB(0, 255, 0) -- Зеленый по умолчанию
        
        if killerWeaponsLookup[tool.Name] then
            weaponColor = Color3.fromRGB(255, 0, 0) -- Красный для киллера
        elseif sheriffWeaponsLookup[tool.Name] then
            weaponColor = Color3.fromRGB(0, 0, 255) -- Синий для шерифа
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

-- Optimized workspace monitoring
local function monitorWorkspaceForWeapons()
    -- Initial scan in chunks to prevent lag
    local tools = {}
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            table.insert(tools, tool)
        end
    end
    
    -- Process tools in chunks
    for i = 1, #tools, 10 do
        for j = i, math.min(i + 9, #tools) do
            highlightDroppedWeapon(tools[j])
        end
        wait(0.05)
    end
    
    -- Listen for new tools
    Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Tool") then
            task.wait(0.1)
            highlightDroppedWeapon(descendant)
        end
    end)
end

-- MAIN FUNCTION: Create ESP for a player - БЫСТРАЯ ВЕРСИЯ БЕЗ ДИСТАНЦИОННЫХ ОГРАНИЧЕНИЙ
local function createPlayerESP(player)
    if player == localPlayer then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Get player's weapons, health and determine color
    local weapons = getPlayerWeapons(player)
    local distance = getDistanceToPlayer(player)
    local currentHealth, maxHealth = getPlayerHealth(player)
    local displayText = createDisplayText(player.Name, weapons, distance, currentHealth, maxHealth)
    local color = getPlayerColor(player)

    -- Update existing ESP instead of recreating
    if activeESPGuis[player] then
        local espData = activeESPGuis[player]
        
        -- Update text
        if espData.billboardGui and espData.billboardGui:IsDescendantOf(game) then
            local textLabel = espData.billboardGui:FindFirstChildOfClass("TextLabel")
            if textLabel then
                textLabel.Text = displayText
                textLabel.TextColor3 = color
                -- Убрано изменение цвета текста в зависимости от здоровья
            end
        end
        
        -- Update highlight color
        if espData.highlight and espData.highlight:IsDescendantOf(game) then
            espData.highlight.FillColor = color
            espData.highlight.OutlineColor = color
            espData.createTime = tick() -- Reset timer
        end
        
        return
    end

    -- Create new BillboardGui БЕЗ ДИСТАНЦИОННЫХ ОГРАНИЧЕНИЙ
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 200, 0, 70) -- Увеличили высоту для отображения здоровья
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billboardGui.AlwaysOnTop = true
    -- УБИРАЕМ MaxDistance для отображения на любой дистанции
    billboardGui.Enabled = true
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboardGui.Parent = head

    -- Create TextLabel
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

    -- Create Highlight
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
        createTime = tick(),
        fadeTween = nil,
        fadeStartTime = nil
    }
end

-- Function to handle character added event - МГНОВЕННАЯ ВЕРСИЯ
local function onCharacterAdded(character, player)
    if activeESPGuis[player] then
        if activeESPGuis[player].billboardGui then
            activeESPGuis[player].billboardGui:Destroy()
        end
        if activeESPGuis[player].highlight then
            activeESPGuis[player].highlight:Destroy()
        end
        activeESPGuis[player] = nil
    end
    
    -- Clear weapons cache for this player
    playerWeaponsCache[player] = nil
    
    -- МГНОВЕННОЕ СОЗДАНИЕ ESP - без задержек
    createPlayerESP(player)
end

-- Function to handle player added
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
    
    if player.Character then
        -- МГНОВЕННОЕ СОЗДАНИЕ ESP для существующих игроков
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
end

-- Функция для загрузки через loadstring
local function initializeESP()
    print("Instant ESP Script with HP Display, Distance-Based Item Display and New Teams Initialized")

    -- МГНОВЕННАЯ ИНИЦИАЛИЗАЦИЯ всех игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            onPlayerAdded(player)
        end
    end

    -- SET UP EVENT HANDLERS
    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)

    -- Start monitoring for dropped weapons
    task.wait(1)
    monitorWorkspaceForWeapons()

    -- БЫСТРЫЙ ЦИКЛ ОБНОВЛЕНИЯ
    local updateCounter = 0
    local cleanupCounter = 0

    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        updateCounter = updateCounter + deltaTime
        cleanupCounter = cleanupCounter + deltaTime
        
        -- БЫСТРОЕ ОБНОВЛЕНИЕ ESP (каждую секунду)
        if updateCounter >= 1 then
            updateCounter = 0
            
            -- МГНОВЕННОЕ ОБНОВЛЕНИЕ ВСЕХ ИГРОКОВ
            for player, _ in pairs(activeESPGuis) do
                if player and player.Parent and player.Character then
                    createPlayerESP(player) -- Update existing ESP
                end
            end
        end
        
        -- Cleanup old highlights каждые 5 секунд
        if cleanupCounter >= 4 then
            cleanupCounter = 0
            cleanupOldHighlights()
        end
    end)

    -- ДОПОЛНИТЕЛЬНЫЙ МГНОВЕННЫЙ СКАН ДЛЯ НОВЫХ ИГРОКОВ
    local fastScanConnection
    fastScanConnection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and not activeESPGuis[player] and player.Character then
                -- МГНОВЕННО создаем ESP для игроков, у которых еще нет ESP
                createPlayerESP(player)
            end
        end
    end)

    -- Возвращаем функции для управления скриптом
    return {
        Stop = function()
            -- Останавливаем все соединения
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
            end
            if fastScanConnection then
                fastScanConnection:Disconnect()
            end
            
            -- Удаляем все ESP элементы
            for player, espData in pairs(activeESPGuis) do
                if espData.billboardGui then
                    espData.billboardGui:Destroy()
                end
                if espData.highlight then
                    espData.highlight:Destroy()
                end
            end
            
            -- Очищаем таблицы
            activeESPGuis = {}
            activeWeaponHighlights = {}
            playerWeaponsCache = {}
        end,
        
        Restart = function()
            -- Останавливаем текущую версию
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
            end
            if fastScanConnection then
                fastScanConnection:Disconnect()
            end
            
            -- Перезапускаем скрипт
            initializeESP()
        end
    }
end

-- Автоматическая инициализация при прямом выполнении
if not _G.ESP_Initialized then
    _G.ESP_Initialized = true
    _G.ESP_Module = initializeESP()
else
    -- Если уже инициализирован, перезапускаем
    if _G.ESP_Module then
        _G.ESP_Module.Stop()
    end
    _G.ESP_Module = initializeESP()
end

-- Возвращаем функцию для загрузки через loadstring
return initializeESP
