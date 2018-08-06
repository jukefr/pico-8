pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- pong
-- very basic attempt at re-
-- creating pong in pico-8
-- by kevin j. (hi@juke.fr)

player  = {} -- base player vars
player1 = {} -- specific player
player2 = {} -- specific player
ball    = {} -- pomg ball
scene   = {} -- background etc.

scene.clr = 7

player.clr   = 7
player.w     = 3
player.h     = 15
player.min_y = 2
player.max_y = 125-player.h

player1.x     = 3
player1.y     = 64-player.h/2
player1.vctr  = {0,0}
player1.score = 0

player2.x     = 124-player.w 
player2.y     = 64-player.h/2
player2.vctr  = {0,0}
player2.score = 0

ball.r     = 3
ball.clr   = 7
ball.x     = 64
ball.y     = 64
ball.speed = 1
ball.vctr  = {0,0}

function player1.update()
 player1.x += player1.vctr[1]
 player1.y += player1.vctr[2]
end

function player1.mvmt()
 player1.vctr[1]=0 
 player1.vctr[2]=0 
 if btn(4) then
  if player1.y-1>player.min_y then
   player1.vctr[1]=0
   player1.vctr[2]=-1
  end
 end
 if btn(5) then
  if player1.y+1<player.max_y then
   player1.vctr[1]=0
   player1.vctr[2]=1
  end
 end
end

function player2.update()
 player2.x += player2.vctr[1]
 player2.y += player2.vctr[2]
end

function player2.mvmt() 
 player2.vctr[1]=0 
 player2.vctr[2]=0   
 if btn(2) then
  if player2.y-1>player.min_y then
   player2.vctr[1]=0 
   player2.vctr[2]=-1 
  end
 end
 if btn(3) then
  if player2.y+1<player.max_y then
   player2.vctr[1]=0 
   player2.vctr[2]=1 
  end
 end
end

function ball.update()
 ball.x += ball.vctr[1]
 ball.y += ball.vctr[2]
end

function ball.throw(direction)
 if direction == "left" then
  ball.vctr[1] = -ball.speed
  ball.vctr[2] = 0
 elseif direction == "right" then
  ball.vctr[1] = ball.speed
  ball.vctr[2] = 0
 else
   if ball.vctr[1] == 0 then
    if ball.vctr[2] == 0 then
     ball.vctr[1] = ball.speed
     ball.vctr[2] = 0
    end
   end
 end
end

function scene.reset()
 ball.x        = 64
 ball.y        = 64
 ball.vctr     = {0,0}
 player1.x     = 3
 player1.y     = 64-player.h/2
 player1.vctr  = {0,0}
 player2.x     = 124-player.w 
 player2.y     = 64-player.h/2
 player2.vctr  = {0,0}
end

function scene.score()
 if ball.x <= 2+ball.r then
  player2.score += 1
  scene.reset()
  ball.throw("right")
 end
 if ball.x >= 125-ball.r then
  player1.score += 1
  scene.reset()
  ball.throw("left")
 end
end

function scene.collision()
 -- down wall collision
 if ball.y >= 125-ball.r then
  ball.vctr[2]=-ball.vctr[2]
 end
 -- up wall collision
 if ball.y <= 2+ball.r then
  ball.vctr[2]=-ball.vctr[2]
 end
 -- player1 collision
 if ball.x==2+player.w+ball.r then
  if ball.y>=player1.y then
   if ball.y<=player1.y+player.h then
    ball.vctr[1]*=-1
    if player1.vctr[2] > 0 then
     ball.vctr[2]+=rnd(abs(player1.vctr[2]))
    else
     ball.vctr[2]-=rnd(abs(player1.vctr[2]))
    end
   end
  end
 end
 -- player2 collision
 if ball.x==125-player.w-ball.r then
  if ball.y>=player2.y then
   if ball.y<=player2.y+player.h then
    ball.vctr[1]*=-1
    if player2.vctr[2] > 0 then
     ball.vctr[2]+=rnd(abs(player2.vctr[2]))
    else
     ball.vctr[2]-=rnd(abs(player2.vctr[2]))
    end
   end
  end
 end
end

function _update60()
 player1.mvmt()
 player1.update()
 player2.mvmt()
 player2.update()
 scene.score()
 scene.collision()
 ball.throw()
 ball.update()
end

function scene.draw()
 -- borders
 rectfill(0,0,127,1,scene.clr)
 rectfill(0,0,1,127,scene.clr)
 rectfill(0,126,127,127,
          scene.clr)
 rectfill(126,0,127,127,
          scene.clr)
 -- score
 score1=""..player1.score
 score2=""..player2.score
 print(score1, 32-#score1*2, 5,
       scene.clr)
 print(score2, 96-#score2*2, 5,
       scene.clr)

 -- middle line (good enough)
 for i=0,16 do
  if i%2 == 0 then
   rectfill(64,4+i*8,65,i*8+12,
            scene.clr)
  end
 end
end

function player.draw(p)
 rectfill(
  p.x,
  p.y,
  p.x+player.w,
  p.y+player.h,
  player.clr
 )
end

function ball.draw(b)
 circfill(b.x,b.y,b.r,b.clr)
end

function _draw()
 cls()
 scene.draw()
 player.draw(player1)
 player.draw(player2)
 ball.draw(ball)
end
