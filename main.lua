
-- Initialisation function, set up the global variables 
function love.load()
    hero_graphic   = love.graphics.newImage( "CubeMan_40.png" )
    zombie_graphic = love.graphics.newImage( "Zombie_40.png" )
    dirt_graphic   = love.graphics.newImage( "DirtPile_40.png" )
  
    hero_x = 0
    hero_y = 0 

    movement_increment = 40 

    zombie_list = {}
    dirt_list = {}

    math.randomseed(os.time())

    love.graphics.setBackgroundColor( 1.0, 1.0, 1.0 )

    inGame = false 

    startNumberOfZombies = 0
    numberOfZombies = startNumberOfZombies
    numberofZombiesAddedForEachLevel = 5 

    -- setupZombies() 
end

function startGame() 
    inGame = true

    love.graphics.setColor( 1.0, 1.0, 1.0 )

    numberOfZombies = 0

    setupZombies()

    teleportHero()
end

function setupZombies() 
    dirt_list = {}

    numberOfZombies = numberOfZombies + numberofZombiesAddedForEachLevel

    newZombie = {}
    local width  = love.graphics.getWidth() 
    local height = love.graphics.getHeight() 

    local maxW = width / movement_increment
    local maxH = height / movement_increment


    for i = 1,numberOfZombies,1 do 
        
        newZombie = {} 

        newZombie.x = math.random(maxW-1) * movement_increment
        newZombie.y = math.random(maxH-1) * movement_increment
        newZombie.alive = true 

        -- print( newZombie.x, newZombie.y )

        table.insert( zombie_list, newZombie ) 
    end 
end

function drawFPS()
    -- Draw the current FPS.
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 50)
    -- Draw the current delta-time. (The same value
    -- is passed to update each frame).
    -- love.graphics.print("dt: " .. love.timer.getDelta(), 50, 100)
end

function teleportHero() 
    local width  = love.graphics.getWidth() 
    local height = love.graphics.getHeight() 

    local maxW = width / movement_increment
    local maxH = height / movement_increment
    
    local random_x = 1
    local random_y = 1

    local noLocationFound = true
    while( noLocationFound ) do 

        random_x = math.random(maxW-1) * movement_increment
        random_y = math.random(maxH-1) * movement_increment
    
        noLocationFound = false 
        for i,v in ipairs(zombie_list) do
            if ( random_x == v.x and random_y == v.y ) then 
                noLocationFound = true 
            end
        end
    end

    hero_x = random_x
    hero_y = random_y 

end

function endGame()
    inGame = false
    zombie_list = {}
    dirt_list = {} 

end

function love.keypressed( key ) 

    if ( inGame == false ) then

        if ( key == 'q' ) then 
            love.event.quit(0)
        end
    
        startGame()

    else 

        -- print( key ) 
        if ( ( key == 'kp8' ) or ( key == 'w' ) ) then
            hero_y = hero_y - movement_increment
        end
        if ( ( key == 'kp2' ) or ( key == 'x' ) ) then
            hero_y = hero_y + movement_increment
        end
        if ( key == 'kp6' ) or ( key == 'd' ) then
            hero_x = hero_x + movement_increment
        end
        if ( key == 'kp4' ) or ( key == 'a' ) then
            hero_x = hero_x - movement_increment
        end

        if ( key == 'kp7' ) or ( key == 'q' ) then
            hero_x = hero_x - movement_increment
            hero_y = hero_y - movement_increment
        end
        if ( key == 'kp9' ) or ( key == 'e' ) then
            hero_x = hero_x + movement_increment
            hero_y = hero_y - movement_increment
        end
        if ( key == 'kp1' ) or ( key == 'z' ) then
            hero_x = hero_x - movement_increment
            hero_y = hero_y + movement_increment
        end
        if ( key == 'kp3' ) or ( key == 'c' ) then
            hero_x = hero_x + movement_increment
            hero_y = hero_y + movement_increment
        end

        if ( key == 't' ) then
            teleportHero() 
        end


        if ( hero_x < 0 ) then
            hero_x = 0 
        end
        if ( hero_y < 0 ) then
            hero_y = 0 
        end

        local width  = love.graphics.getWidth() 
        local height = love.graphics.getHeight() 

        if ( hero_x > ( width - movement_increment )  ) then
            hero_x = width  - movement_increment
        end
        if ( hero_y > ( height - movement_increment ) ) then
            hero_y = height  - movement_increment
        end

        if ( key ~= 't' ) then
            updateZombies()
        end 
    end
end

function updateZombies() 
    for i,v in ipairs(zombie_list) do
        if v.x > hero_x then 
            v.x = v.x - movement_increment
        end 
        if v.x < hero_x then 
            v.x = v.x + movement_increment
        end 
        if v.y > hero_y then 
            v.y = v.y - movement_increment
        end 
        if v.y < hero_y then 
            v.y = v.y + movement_increment
        end 
    end
    
    -- Check if the zombies have collided with each other 
    for i,v in ipairs(zombie_list) do
        for j,w in ipairs(zombie_list) do
            if ( i ~= j ) then 
                if ( v.x == w.x ) and ( v.y == w.y ) then 
                    v.alive = false
                end
            end
        end

        -- check if the zombies have collided with a pile 
        for  k,m in ipairs( dirt_list ) do 
            if ( v.x == m.x ) and ( v.y == m.y ) then 
                v.alive = false
            end 
        end
    
        if ( v.x == hero_x ) and ( v.y == hero_y ) then
            endGame() 
            return
        end
    end
  


    -- Update the zombie list and the dirt list     
    newZombieList = {}
    for i,v in ipairs(zombie_list) do
        if v.alive == true then
            table.insert( newZombieList, v ) 
        else
            table.insert( dirt_list, v )
        end
    end


    zombie_list = newZombieList

    if #zombie_list == 0 then
        setupZombies()
    end
end

function drawZombies()
    for i,v in ipairs(zombie_list) do
        love.graphics.draw( zombie_graphic, v.x, v.y )
    end 
end

function drawDirt() 
    for i,v in ipairs(dirt_list) do
        love.graphics.draw( dirt_graphic, v.x, v.y )
    end 
end

function drawTitleScreen() 
    font = love.graphics.newFont(40)
    love.graphics.setFont(font)
    love.graphics.setColor( 0.8, 0.3, 0.3 )
    love.graphics.print( "Zombies", 150, 150, 0, 1, 1)
    love.graphics.print( "Press q to quit", 150, 250, 0, 1, 1)
    love.graphics.print( "Any other key to begin", 150, 350, 0, 1, 1)
    
end

-- Draw function 
function love.draw()
    if ( inGame ) then
        love.graphics.draw( hero_graphic , hero_x, hero_y )
        drawDirt()
        drawZombies() 
    else
        drawTitleScreen()
    end
    -- drawFPS()
end
    
function love.update(dt)
         
end