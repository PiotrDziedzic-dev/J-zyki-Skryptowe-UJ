local serpent = require("libs.serpent")

local blockSize = 30
local gridWidth, gridHeight = 10, 20
local grid = {}
local currentPiece, nextPiece
local score = 0
local gameOver = false
local sounds = {}
local clearingLines = {}
local animationTimer = 0
local autoFallTimer = 0
local autoFallInterval = 1
local downCooldown = 0
local downRepeatDelay = 0.15
local saveInfoTimer = 0
local saveInfoText = ""

local colors = {
    {0.27, 0.82, 0.95, 1}, -- I
    {0.91, 0.76, 0.15, 1}, -- O
    {0.63, 0.22, 0.82, 1}, -- T
    {0.93, 0.44, 0.18, 1}  -- L
}

local shapes = {
    { -- I
        blocks = {{0,0}, {1,0}, {2,0}, {3,0}},
        pivot = {1.5, 0.5},
        color = colors[1]
    },
    { -- O
        blocks = {{0,0}, {1,0}, {0,1}, {1,1}},
        pivot = {0.5, 0.5},
        color = colors[2]
    },
    { -- T
        blocks = {{0,1}, {1,1}, {2,1}, {1,0}},
        pivot = {1,1},
        color = colors[3]
    },
    { -- L
        blocks = {{0,0}, {0,1}, {0,2}, {1,2}},
        pivot = {0.5, 1.5},
        color = colors[4]
    }
}

function love.load()

    love.graphics.setFont(love.graphics.newFont(18))
    math.randomseed(os.time())

    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end

    sounds.move = love.audio.newSource("assets/sounds/move.wav", "static")
    sounds.rotate = love.audio.newSource("assets/sounds/rotate.wav", "static")
    sounds.clear = love.audio.newSource("assets/sounds/clear.wav", "static")
    sounds.gameover = love.audio.newSource("assets/sounds/gameover.wav", "static")

    spawnNewPiece()
end

function spawnNewPiece()
    currentPiece = nextPiece or createRandomPiece()
    nextPiece = createRandomPiece()
    currentPiece.x = math.floor(gridWidth/2 - currentPiece.width/2)
    currentPiece.y = 1

    if checkCollision(currentPiece.x, currentPiece.y, currentPiece.blocks) then
        gameOver = true
        sounds.gameover:play()
    end
end

function createRandomPiece()
    local s = shapes[math.random(#shapes)]
    local piece = {
        blocks = {},
        color = s.color,
        pivot = s.pivot,
        width = 0,
        height = 0
    }

    local minX, maxX, minY, maxY = math.huge, 0, math.huge, 0
    for _,b in ipairs(s.blocks) do
        table.insert(piece.blocks, {b[1], b[2]})
        minX, maxX = math.min(minX, b[1]), math.max(maxX, b[1])
        minY, maxY = math.min(minY, b[2]), math.max(maxY, b[2])
    end
    piece.width = maxX - minX + 1
    piece.height = maxY - minY + 1
    return piece
end

function checkCollision(x, y, blocks)
    for _,b in ipairs(blocks) do
        local bx, by = x + b[1], y + b[2]
        if bx < 1 or bx > gridWidth or by > gridHeight then
            return true
        end
        if by >= 1 and grid[by][bx] ~= 0 then
            return true
        end
    end
    return false
end

function rotatePiece(piece, clockwise)
    local newBlocks = {}
    local px, py = piece.pivot[1], piece.pivot[2]

    for _,b in ipairs(piece.blocks) do
        local dx, dy = b[1]-px, b[2]-py
        if clockwise then
            table.insert(newBlocks, {px - dy, py + dx})
        else
            table.insert(newBlocks, {px + dy, py - dx})
        end
    end
    return newBlocks
end

function checkLines()
    local lines = {}
    for y = gridHeight, 1, -1 do
        local full = true
        for x = 1, gridWidth do
            if grid[y][x] == 0 then
                full = false
                break
            end
        end
        if full then table.insert(lines, y) end
    end

    if #lines > 0 then
        animationTimer = 0.5
        clearingLines = lines
        score = score + #lines * 100
        sounds.clear:play()
    end
end

function love.update(dt)
    if gameOver then return end

    saveInfoTimer = math.max(0, saveInfoTimer - dt)

    if animationTimer > 0 then
        animationTimer = animationTimer - dt
        if animationTimer <= 0 then
            for _,y in ipairs(clearingLines) do
                table.remove(grid, y)
                table.insert(grid, 1, {})
                for x = 1, gridWidth do grid[1][x] = 0 end
            end
            clearingLines = {}
        end
        return
    end

    autoFallTimer = autoFallTimer + dt
    if autoFallTimer >= autoFallInterval then
        autoFallTimer = 0
        if not checkCollision(currentPiece.x, currentPiece.y + 1, currentPiece.blocks) then
            currentPiece.y = currentPiece.y + 1
        else
            placePiece()
        end
    end

    if love.keyboard.isDown("down") then
        downCooldown = downCooldown + dt
        if downCooldown >= downRepeatDelay then
            downCooldown = 0
            if not checkCollision(currentPiece.x, currentPiece.y + 1, currentPiece.blocks) then
                currentPiece.y = currentPiece.y + 1
                sounds.move:play()
            else
                placePiece()
            end
        end
    else
        downCooldown = 0
    end
end

function love.keypressed(key)
    if key == "r" then
        resetGame()
        return
    end

    if key == "left" then
        if not checkCollision(currentPiece.x - 1, currentPiece.y, currentPiece.blocks) then
            currentPiece.x = currentPiece.x - 1
            sounds.move:play()
        end
    elseif key == "right" then
        if not checkCollision(currentPiece.x + 1, currentPiece.y, currentPiece.blocks) then
            currentPiece.x = currentPiece.x + 1
            sounds.move:play()
        end
    elseif key == "up" then
        local rotated = rotatePiece(currentPiece, true)
        if not checkCollision(currentPiece.x, currentPiece.y, rotated) then
            currentPiece.blocks = rotated
            sounds.rotate:play()
        end
    elseif key == "space" then
        while not checkCollision(currentPiece.x, currentPiece.y + 1, currentPiece.blocks) do
            currentPiece.y = currentPiece.y + 1
        end
        placePiece()
    elseif key == "f5" then
        saveGameState()
    elseif key == "f8" then
        loadGameState()
    end
end

function placePiece()
    for _,b in ipairs(currentPiece.blocks) do
        local x = currentPiece.x + b[1]
        local y = currentPiece.y + b[2]
        if y >= 1 then grid[y][x] = currentPiece.color end
    end
    checkLines()
    spawnNewPiece()
end

function saveGameState()
    local state = {
        grid = grid,
        currentPiece = currentPiece,
        nextPiece = nextPiece,
        score = score,
        autoFallTimer = autoFallTimer,
        animationTimer = animationTimer,
        gameOver = gameOver
    }

    if state.currentPiece then
        state.currentPiece.color = {unpack(state.currentPiece.color)}
    end
    if state.nextPiece then
        state.nextPiece.color = {unpack(state.nextPiece.color)}
    end

    local success, err = pcall(function()
        local serialized = serpent.dump(state, {comment = false}) -- Używamy dump()
        love.filesystem.write("save.txt", serialized)
    end)

    if success then
        saveInfoText = "Gra zapisana!"
    else
        saveInfoText = "Błąd zapisu: " .. tostring(err)
    end
    saveInfoTimer = 2
end


function loadGameState()
    if not love.filesystem.getInfo("save.txt") then
        saveInfoText = "Brak zapisu!"
        saveInfoTimer = 2
        return false
    end

    local serialized, readError = love.filesystem.read("save.txt")
    if not serialized then
        saveInfoText = "Błąd wczytywania: " .. tostring(readError)
        saveInfoTimer = 2
        return false
    end

    print("Wczytana zawartość:\n", serialized)

    local stateFunc, loadError = load(serialized)
    if not stateFunc then
        saveInfoText = "Błąd deserializacji: " .. tostring(loadError)
        saveInfoTimer = 2
        return false
    end

    local success, state = pcall(stateFunc)
    if not success then
        saveInfoText = "Błąd odczytu stanu: " .. tostring(state)
        saveInfoTimer = 2
        return false
    end

    if type(state) ~= "table" then
        saveInfoText = "Błąd: nieprawidłowy format zapisu!"
        saveInfoTimer = 2
        return false
    end

    grid = state.grid or {}
    currentPiece = state.currentPiece or createRandomPiece()
    nextPiece = state.nextPiece or createRandomPiece()
    score = state.score or 0
    autoFallTimer = state.autoFallTimer or 0
    animationTimer = state.animationTimer or 0
    gameOver = state.gameOver or false

    if currentPiece and currentPiece.color then
        currentPiece.color = {unpack(state.currentPiece.color)}
    end
    if nextPiece and nextPiece.color then
        nextPiece.color = {unpack(state.nextPiece.color)}
    end

    saveInfoText = "Gra wczytana!"
    saveInfoTimer = 2
    return true
end




function resetGame()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end

    score = 0
    gameOver = false
    autoFallTimer = 0
    animationTimer = 0
    clearingLines = {}
    saveInfoTimer = 0
    saveInfoText = ""

    spawnNewPiece()
end

function love.draw()
    -- Tło
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local gameAreaWidth = gridWidth * blockSize
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] ~= 0 then
                local alpha = 1
                if animationTimer > 0 and clearingLines[y] then
                    alpha = 0.5 + math.abs(math.sin(animationTimer * 10)) * 0.5
                end
                love.graphics.setColor(grid[y][x][1], grid[y][x][2], grid[y][x][3], alpha)
                love.graphics.rectangle("fill", (x-1)*blockSize, (y-1)*blockSize, blockSize-1, blockSize-1)
            end
        end
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.setLineWidth(2)
    love.graphics.line(gameAreaWidth, 0, gameAreaWidth, love.graphics.getHeight())

    love.graphics.setColor(currentPiece.color)
    for _,b in ipairs(currentPiece.blocks) do
        local x = (currentPiece.x + b[1] - 1) * blockSize
        local y = (currentPiece.y + b[2] - 1) * blockSize
        love.graphics.rectangle("fill", x, y, blockSize-1, blockSize-1)
    end

    local infoX = gameAreaWidth + 20
    local bigFont = love.graphics.newFont(20)

    love.graphics.setFont(bigFont)
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("WYNIK: "..score, infoX, 20)

    love.graphics.print("NASTEPNY KLOCEK:", infoX, 100)

    local previewScale = 0.7
    if nextPiece then
        love.graphics.setColor(nextPiece.color)
        local minX, minY = math.huge, math.huge
        for _,b in ipairs(nextPiece.blocks) do
            minX = math.min(minX, b[1])
            minY = math.min(minY, b[2])
        end

        local previewWidth = nextPiece.width * blockSize * previewScale
        local startX = infoX + (180 - previewWidth)/2

        for _,b in ipairs(nextPiece.blocks) do
            local x = startX + (b[1]-minX)*blockSize*previewScale
            local y = 160 + (b[2]-minY)*blockSize*previewScale
            love.graphics.rectangle("fill", x, y, blockSize*previewScale-2, blockSize*previewScale-2)
        end
    end

    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("F5 - Zapisz gre\nF8 - Wczytaj gre\nR - Restart", infoX, 400, 180, "center")

    if saveInfoTimer > 0 then
        love.graphics.setColor(0, 1, 0)
        love.graphics.printf(saveInfoText, infoX, 500, 180, "center")
    end

    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("KONIEC GRY", infoX, 300, 180, "center", 0, 1.5, 1.5)
        love.graphics.printf("Nacisnij R aby zrestartowac", infoX, 350, 180, "center")
    end
end