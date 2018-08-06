pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--------------------------------
--------------------------------
-- learning pico-8 -------------
--------------------------------
-- probably does not represent -
-- the best coding practices ---
--------------------------------
-- by jukefr (hi@juke.fr) ------
--------------------------------
--------------------------------

-------------------
-- base variables -
-------------------
player = {64, 64, 8} -- x y r
enemy = {0, 0, 4}    -- x y r
is_music = false -- playing ?
score = -1
speed = 1
is_playing = false
timer = 0
seconds = 0
game_over = false
-------------------

------------------
-- configuration -
------------------
clr0 = 13 -- main color
clr1 = 3  -- secondary color
------------------

--------------------------------
--------- start logic ----------
--------------------------------

-- start partymode
function partymode()
 if not is_playing then
  music_player()
  is_playing = true
 end
end

function reset()
 player = {64, 64, 8} -- x y r
 enemy = {0, 0, 4}    -- x y r
 is_music = false -- playing ?
 score = -1
 speed = 1
 is_playing = false
 timer = 0
 seconds = 0
 game_over = false
 music(-1)
end

function music_player()
 if not is_music then
  music()
  is_music = true
 end
end

function bounds(point, r)
	-- check if the position is
 -- outside screen and correct
 -- if it is
	if point < -(r-1) then
		point = 127 - r
	elseif point>127+r then
	 point = r
	end
	
	return point
end

-- calculate player position
-- return as array
function get_position(x,y,r)
	-- maps btn(i-1) to action
	-- to execute on player
	-- x and y position
	keys={
		{-1,0}, {1,0}, -- x pos
		{0,-1}, {0,1}  -- y pos
	}

	-- lua arrays start at 1
	for i=1,4 do
		if btn(i-1) then
			x += (keys[i][1]*speed)
			y += (keys[i][2]*speed)
		end
	end
	
 -- check if out of bounds
	x = bounds(x, r)
	y = bounds(y, r)
	
 -- check if we are eating
 eat( x, y, r,
  enemy[1], enemy[2], enemy[3] )

	return {x,y,r}
end

function eat(px, py, pr,
             ex, ey, er)
 radix = (px-ex)*(px-ex)
 radiy = (py-ey)*(py-ey)
 radi = pr+er
 radi *= radi
	if radix + radiy < radi then
  enemy=randomize_enemy(enemy)
  player=grow(player)
 end
end

function grow(p)
 return {p[1], p[2], p[3]+5 }
end

function randomize_enemy(e)
 score += 1
 speed += 1
 return {flr(rnd(127)),
         flr(rnd(127)),
         e[3]}
end

-- runs at every frame
-- before _draw
function _update60()
	-- store position in global
	-- player array
 if is_playing then
  timer += 1
  seconds = flr(timer / 60)
  if score == -1 then
   enemy=randomize_enemy(enemy)
  end
 end
	player = get_position(
		player[1],
		player[2],
  player[3]
	)
 if seconds > 30 then
  game_over = true
 end
end
--------------------------------
---------- end logic -----------
--------------------------------

--------------------------------
-------- start graphics --------
--------------------------------
function draw_bg()
	cls()
end

-- draws background
function draw_border()
	rectfill(0,0,127,1, clr1)
	rectfill(0,126,127,127, clr1)
	rectfill(0,0,1,127, clr1)
	rectfill(126,0,127,127, clr1)
end

-- draws player
function draw_player(x,y,r)
	circfill(x,y,r,clr0)
end

function draw_enemy(e)
 circfill(
  e[1],
  e[2],
  e[3],
  clr1
 )
end

-- draw a second circle
-- if the player is out
-- of bounds, like a "mirror"
function draw_mirror(x,y)
	if x < player[3] then
		circfill(127+x, y, player[3] ,clr0)
		partymode()
	elseif x > 119 then
	 circfill(x-127, y, player[3], clr0)
		partymode()
	end
	if y < player[3] then
		circfill(x, 127+y, player[3] ,clr0)
		partymode()
	elseif y > 119 then
		circfill(x, y-127, player[3] ,clr0)
		partymode()
	end 
end

function stop_game()
 o_msg = "❎ "
 o__msg = " to start over"
 msg_o= 64-(#o_msg+#o__msg)*2
 msg__o = msg_o+#o_msg*4
 over_score = ""..score
 cls()
 print(over_score,
       64-#over_score*2,
       64, clr0)
 print(o_msg,
       msg_o, 105, clr0)
 print(o__msg,
       msg__o ,
       105, clr1)
 if btn(5) then
  reset()
 end
end

-- draws info_
function info_()
 s_msg = "score:"
 s__msg = ""..score
 msg_s= 64-(#s_msg+#s__msg)*2
 msg__s = msg_s+#s_msg*4

 print(s_msg,
       msg_s, 105)
 print(s__msg,
       msg__s ,
       105, clr0)

 t_msg = "time:"
 t__msg = ""..(30-seconds)
 msg_t= 64-(#t_msg+#t__msg)*2
 msg__t = msg_t+#t_msg*4

 print(t_msg, msg_t, 15, clr1)
 print(t__msg, msg__t ,
       15, clr0)
end

-- called after _update
function _draw()
 if game_over then
  stop_game()
  draw_border()
 else
  speed = 1 + flr(rnd(abs(score)))
  draw_bg()
  draw_player(
   player[1],
   player[2],
   player[3]
  )
  draw_mirror(
   player[1],
   player[2]
  )
  if is_playing then
   draw_enemy(enemy)
   draw_border()
   info_()
  end
 end
end

--------------------------------
--------- end graphics ---------
--------------------------------
__gfx__
08800880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000000c053000000000000000246150000000000000000c053000000000000000246150000000000000000c053000000000000000246150000000000000000c05300000000000000024615000000000000000
011000000214002140021400214002140021400214002140021400214002140021400214002140021400214002140021400214002140021400214002140021400214002140021400214002140021400214002140
011000000214002130021200211002140021300212002110021400213002120021100214002130021200211002140021300212002110021400213002120021100214002130021200211002140021300212002110
011000000214002120021100214002120021100214002120021100214002120021100214002110021400211002140021200211002140021200211002140021200211002140021200211002140021100214002110
011000000210002100021400212002110021400212002110021400212002110021400212002110021400211002140021200211002140021200211002140021200211002140021200211002140021100214002110
011000000210002100021400212002010021400212002010021400212002010021400212002010021400201002140021200201002140021200201002140021200201002140021200201002140020100214002010
01100000021000210002140021200e11002140021200e11002140021200e11002140021200e110021400e11002140021200e11002140021200e11002140021200e11002140021200e110021400e110021400e110
01100000021000210002140020200e11002040021200e01002140020200e11002040021200e010021400e01002140020200e11002040021200e01002140020200e11002040021200e010021400e010021400e010
01100000021000210002140021250e11002140021200e11502140021250e11002140021200e115021400e11002140021200e11502140021200e11002140021250e11002140021200e110021400e110021400e110
__music__
00 00014344
01 00024344
00 00034344
00 00044344
00 00054344
00 00064344
00 00074344
02 00084344

