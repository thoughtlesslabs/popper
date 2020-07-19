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
	rkern=1
	gametimer=0
	levelnum=1
	levels={}
	levels[1]="ffff"
	levels[2]="ffffffff"
	levels[3]="fffffffffffff"
	levels[4]="fffffffffffffffffffff"
	levels[5]="ffffffffffffffffffffffffff"
	part={}
end

function _update60()
	updateparts()
	if mode=="start" then
		updatestart()
	elseif mode=="game" then
		updategame()
	elseif mode=="gameover" then
		updategameover()
	end
end

function _draw()
	if mode=="start" then
		drawstart()
	elseif mode=="game" then
		drawgame()
	elseif mode=="gameover" then
		drawgameover()
	end
end


-->8
--gimme the juice

-- particles
function addpart(_x,_y,_dx,_dy,_type,_maxage,_col)
 local _p = {}
 _p.x=_x
 _p.y=_y
 _p.dx=_dx
 _p.dy=_dy
 _p.tpe=_type
 _p.mage=_maxage
 _p.age=0
 _p.col=0
	_p.colarr=_col
 add(part,_p)
end

-- kernel explosion
function popped(_k)
	for i=0,10 do
		local _ang = rnd()
		local _dx = cos(_ang)*2
		local _dy = sin(_ang)*2
		addpart(_k.x,_k.y+10,_dx,_dy,1,100,{7,5,6})
	end
end

--particle updater
function updateparts()
	local _p
	for i=#part,1,-1 do
		_p=part[i]
		_p.age+=1
		if _p.age>_p.mage then
			del(part,part[i])
		else
			if #_p.colarr==1 then
				_p.col=_p.colarr[1]
			else
				local _ci=_p.age/_p.mage
				_ci=1+flr(_ci*#_p.colarr)
				_p.col=_p.colarr[_ci]
			end
		
		--apply gravity
			if _p.tpe==1 then
			_p.dy-=0.009
			end

		--move particle
			_p.x+=_p.dx
			_p.y+=_p.dy
		end
	end
end

function drawparts()
	for i=1,#part do
		_p=part[i]
		--pixel particle
		pset(_p.x,_p.y,_p.col)
	end
end

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
-->8
-- update functions

--update and reset game
function updatestart()
	level=levels[levelnum]
	kern(level)
	popcount=0
	gametimer=30
	levelselect()
	lvlname()
	jit=0
	jittering=false
	if btnp(4) then
		mode="game"
	end
end

--player select level
function levelselect()
	if btnp(0) then
		if levelnum >1 then
			levelnum-=1
		end
	elseif btnp(1) then
		if levelnum < #levels then
			levelnum+=1
		end
	end
end

function lvlname()
	if levelnum==1 then
		levelname="small"
	elseif levelnum==2 then
		levelname="medium"
	elseif levelnum==3 then
		levelname="large" 
	elseif levelnum==4 then
		levelname="x-large"
	end
end

function updategameover()
	if btnp(5) then
		mode="game"
	end
end

--pop kernels base on user input
function updategame()
 if popcount<#kernels then
 	if btnp(4) and jittering==false then
 		pickkern()
 	end
 else
 	updategameover()
 end
 if kernels[rkern].mvtimer>0 then
 movekern(rkern)
 end
	if kernels[rkern].j then
		jitter(rkern)
	end
	if kernels[rkern].jtimer==0 then
		kernpop()
	end
end

function jitter(_j)
	jittering=true
	kernels[_j].jtimer-=1
	if kernels[_j].jtimer > 0 then
		jit=rnd(3)
	else
		kernels[_j].jtimer=0
	end
end

function pickkern()
	rkern=flr(rnd(#kernels)+1)
	if kernels[rkern].n==false then
		pickkern()
	else
		kernels[rkern].j=true
	end
end

function kernpop()
	if kernels[rkern].p then	
		kernels[rkern].n=false
	elseif kernels[rkern].n then	
		sfx(0)
		shake=0.4
		popped(kernels[rkern])
		popcount+=1
		kernels[rkern].p=true
	end
	jittering=false
end

function movekern(mk)
	mv=kernels[mk]
	mv.dx=flr(rnd(3)+1)
	mv.dy=flr(rnd(3)+1)
	
	if mv.p then
		if mv.mvtimer>0 then
			if mv.dx==3 then
				nextx=mv.x+mv.dx
				nexty=mv.y+mv.dy
			elseif mv.dx==2 then
				nextx=mv.x-mv.dx
				nexty=mv.y+mv.dy
			else
				nextx=mv.x-mv.dx
				nexty=mv.y-mv.dy
			end
		mv.mvtimer-=1
		end
	else
		nextx=mv.x
		nexty=mv.y
	end
	
	if nextx <100 then
	mv.x=nextx
	mv.y=nexty
	else 
		mv.x=mv.x
		mv.y=mv.y
	end
end

function updategameover()
	gametimer-=1
	if gametimer<0 then
		mode="gameover"
		if btn(5) then
			mode="start"
		end
	end
end
-->8
--kernels

-- give kernels attributes
function addkern(_i)
	k={}
	k.x=mid(1,rnd(110),110)
	k.y=mid(1,rnd(110),110)
	k.dx=1
	k.dy=-1
	k.p=false
	k.j=false
	k.jtimer=20
	k.n=true
	k.r=flr(rnd(4)+1)
	k.mvtimer=10
	add(kernels,k)
end

--generate popcorn kernels
function kern(lvl)
	kernels={}
	for i=1,#lvl do 
		chr=sub(lvl,i,i)
		if chr=="f" then
			addkern(i)
		end
	end
end
-->8
--draw

function drawgame()
	local i
	cls(1)
	doshake()
	for i=1,#kernels do
		if kernels[i].p==false then
			if kernels[i].j then
			spr(2,kernels[i].x+jit,kernels[i].y+jit)
			else
			spr(2,kernels[i].x,kernels[i].y)
			end
		elseif kernels[i].p then
		--	spr(1,kernels[i].x,kernels[i].y+5,1,1,kernels[i].r)
			if kernels[i].r==1 then
				spr(1,kernels[i].x,kernels[i].y+5,1,1,true)
			elseif kernels[i].r==2 then
				spr(1,kernels[i].x,kernels[i].y+5,1,1,false)
			elseif kernels[i].r==3 then
				spr(1,kernels[i].x,kernels[i].y+5,1,1,false,true)
			elseif kernels[i].r==4 then
				spr(1,kernels[i].x,kernels[i].y+5,1,1,true,false)
			end
		end
	end
	drawparts()	
end

function drawstart()
	cls(1)
	spr(16,0,0,20,15)
	spr(16,35,0,10,15)
	spr(16,0,0,20,15,true)
	print("what size today?",35,30,7)
	print("  ➡️",75,40,7)
	print("⬅️ "..levelname,40,40,7)
	print("press 🅾️ to pop",35,50,7)
end

function drawgameover()
		shake=0
		rectfill(35,35,95,60,4)
		print("play again?",45,40,7)
		print("press ❎",50,50,7)
end
-->8
--					to do list
--2. 	start menu page
--3.  animated kernel popping
--4.  steam rising pre-pop
__gfx__
00000000000776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009977600004499000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700779967760044449000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000779667760044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000776677660444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700677777760444550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000067777660055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000
999009999999999999999999999aa999999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000
90000099999999999999999999aaaaa9999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000
000000099999999900999999aa9099aaa99999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009999999000099999a9000099aaaaaa99999999aa00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a9000000099a90000000099999aaaaaaaaa9900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a9000000099a9000000000000999999aa999900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a9000000099a900000000000000900999990000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a9000000099a900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a9000000099a900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a90000000999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999a90000000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009999a90000000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
