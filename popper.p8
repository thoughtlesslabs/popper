pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--popper
--thoughtless labs
--a silly game about popcorn

function _init()
	cls()
	mode="start"
	shake=0
	gametimer=0
	levelnum=1
	levels={}
	levels[1]="ffff"
	levels[2]="ffffffff"
	levels[3]="fffffffffffff"
	levels[4]="fffffffffffffffffffff"
	levels[5]="ffffffffffffffffffffffffff"
end

--set game mode
function _update()
	doshake()
	if mode=="start" then
		updatestart()
	elseif mode=="game" then
		drawkern()
	end
end

--update and reset game
function updatestart()
	level=levels[levelnum]
	kern(level)
	pop=false
	popcount=0
	mode="game"
	rotater()
	gametimer=30
end

function lvlname()
	if levelnum==1 then
		levelsname="xtra small"
	elseif levelnum==2 then
		levelsname="  small  "
	elseif levelnum==3 then
		levelsname="  medium  "
	elseif levelnum==4 then
		levelsname="  large  "
	elseif levelnum==5 then
		levelsname="xtra large"	
	end
end

--user select kernel count
function kcount()
	lvlname()
	if mode!="playing" then
	if btnp(0) then
		if levelnum >1 then
			levelnum-=1
			mode="start"
			return
		end
	elseif btnp(1) then
		if levelnum < #levels then
			levelnum+=1
	 	mode="start"
	 	return
		end
	end
end
end
--generate popcorn kernels
function kern(lvl)
	local i,chr
	x={}
	y={}
	v={}
 n={}
	for i=1,#lvl do 
		chr=sub(lvl,i,i)
		if chr=="f" then
			add(x,flr(mid(1,rnd(110),110)))
			add(y,flr(mid(35,rnd(110),110)))
			add(v,true)
			add(n,i)
		end
	end
end

--kernel jitter
function jitter()
	jit={}
	for i=1,50 do
		add(jit,rnd(2))
	end
end

--pop kernels base on user input
function updatekern() 
 mode="playing"
 shake=0.1
 --pick random kernel to pop
	randnum=flr(rnd(n))
	--check if kernel is already popped
 if v[randnum]==false then
  del(n,randnum)
  updatekern()
	elseif v[randnum] then
		v[randnum]=false
		pop=true
		sfx(0)
		popcount+=1
 end
end

function rotater()
	r={}
	for i=1,#x do
 	add(r,flr(rnd(4)+1))
	end
end	

function kernpop()
	if btnp(4) then
		updatekern()
	end
end

function drawkern()
	local i
	cls(1)
	kernpop()
	kcount()
	jitter()
	for i=1,#x do
		if v[i] then
			spr(2,x[i]+rnd(jit),y[i]+rnd(jit))
		elseif pop then
			if r[i]==1 then
				spr(1,x[i]+5,y[i]+5,1,1,true)
			elseif r[i]==2 then
				spr(1,x[i]+5,y[i]+5,1,1,false)
			elseif r[i]==3 then
				spr(1,x[i]+5,y[i]+5,1,1,false,true)
			elseif r[i]==4 then
				spr(1,x[i]+5,y[i]+5,1,1,true,false)
			end
		end
	end	
	if not(pop) then
		print("what size today?",35,10,7)
		print("⬅️ "..levelsname.." ➡️",35,20,7)
		print("press 🅾️ to pop",35,30,7)

	elseif popcount==#x then
		retry()
	end
end	

function retry()
	gametimer-=1
	if gametimer<=0 then
		shake=0
		rectfill(35,35,95,60,4)
		print("play again?",45,40,7)
		print("press ❎",50,50,7)
		update_retry()
	end
end

function update_retry()
	if btn(5) then
		mode="start"
	end
end

function _draw()
	if mode=="game" or mode=="playing" then
		drawkern()
	elseif mode=="start" then
		updatestart()
	end
end
-->8
--gimme the juice

--camera shake
function doshake()
 --	-16 to +16
	local shakex=16-rnd(32)
	local shakey=16-rnd(32)
	
	shakex=shakex*shake
	shakey=shakey*shake

	camera(shakex,shakey)
	
	shake=shake*0.95
	if shake<0.05 then
		shake=0
	end
end
__gfx__
00000000000776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009977600004499000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700779967760044449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000779667760044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000776677660444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700677777760444550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000067777660055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111717117717171111177717771771171711111717177717771771177717111177111117771177177117771717177711111111111111111
11111111111111111111717171717171111177717171717171711111717171117171717171117111711111111711717171717171717111711111111111111111
11111111111111111111777171717171111171717771717177711111771177117711717177117111777111111711717171717771777117711111111111111111
11111111111111111111717171717771111171717171717111711111717171117171717171117111117111111711717171717171117111111111111111111111
11111111111111111111717177117771111171717171717177711111717177717171717177717771771111111711771177717171777117111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111177777111111771177711111177777111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111777117711111171171711111771177711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111771117711111171171711111771117711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111777117711111171171711111771177711111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111177777111111777177711111177777111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111777177717771177117711111177777111111777117711111777117717771111111111111111111111111111111111
11111111111111111111111111111111111717171717111711171111111771117711111171171711111717171717171111111111111111111111111111111111
11111111111111111111111111111111111777177117711777177711111771717711111171171711111777171717771111111111111111111111111111111111
11111111111111111111111111111111111711171717111117111711111771117711111171171711111711171717111111111111111111111111111111111111
11111111111111111111111111111111111711171717771771177111111177777111111171177111111711177117111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111449911111111111111111111111111111111111111111111111111144991111114499111111111111111111111111111111111111111111
11111111111111114444911111111111111111111111111111111111111111111111111444491111144449111111111111111111111111111111111111111111
11111111111111114444411111111111111111111111111111111111111111111111111444441111144444111111111111111111111111111111111111111111
11111111111111144444511111111111111111111111111111111111111111111111114444451111444445111111111111111111111111111111111111111111
11111111111111144455111111111111111111111111111111111111111111111111114445511111444551111111111111111111111111111111111111111111
11111111111111115511111111111111111111111111111111111111111111111111111551111111155111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111449911111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111114444911111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111114444411111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111144444511111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111144455111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111115511111111449911111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111114444911111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111114499111111111114444411111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111144449111111111144444511111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111144444111111111144455111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111444445111111111115511111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111444551111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111155111111111111111111111111111111111111111111111111
11111111111111111144991111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111444491111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111444441111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111114444451111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111114445511111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111551111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111114499111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111144449111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111144444111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111114499111111111111111111111111444445111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111144449111111111111111111111111444551111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111144444111111111111111111111111155111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111444445111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111444551111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111155111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111114499111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111144449111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111144444111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111444445111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111444551111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111155111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__sfx__
000100002a65025650206501a650126500a6500760001600006001b6000b6000f60023600006002860008600096002e6000b6000f600126001960000600006000060000600006000060000600006000060000600
