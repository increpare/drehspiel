import js.html.Screen;
import js.html.svg.GraphicsElement;
import js.html.History;
import haxegon.*;
import utils.*;
import Globals.*;



class Entity {
	public var x:Int;
	public var y:Int;
	public var t:String;
	public var von:Entity;

	public function spieler():Bool{
		return t=="1" || t=="2"||t=="3"||t=="4";		
	}

	public function frame():Int{
		switch(t){
			case "1":
				return 0;
			case "2":
				return 1;
			case "3":
				return 2;
			case "4":
				return 3;
		}
		trace("ERROR Asdf23");
		return -1;
	}

	public function new(_x:Int,_y:Int,_t:String){
		this.x=_x;
		this.y=_y;
		this.t=_t;
		this.von=null;
	}

	public function copy():Entity{
		var e = new Entity(x,y,t);
		e.von=von;
		return e;
	}
	public function equal(o:Entity):Bool{
		return x==o.x && y==o.y && t==o.t;
	}

	public function cycle(){
		switch(t){
			case "1":
				t="2";
			case "2":
				t="3";
			case "3":
				t="4";
			case "4":
				t="1";
		}
	}
}

class Level {
	public var entities:Array<Entity>;
	public var ziele:Array<Entity>;

	public function gewonnen():Bool{
		for (z in ziele){
			var found:Bool=false;
			for (e in entities){
				if (e.t=="Klotz" && e.x==z.x && e.y==z.y){
					found=true;
					break;
				}
			}
			if (found==false){
				return false;
			}
		}
		return true;
	}

	public function new(){
		entities = new Array<Entity>();
		ziele = new Array<Entity>();
	}

	public function loeschBewegungen(){
		for(e in entities){
			e.von=null;
		}
	}

	public function copy():Level{
		var l = new Level();
		for(e in entities){
			l.entities.push(e.copy());
		}
		for(e in ziele){
			l.ziele.push(e.copy());
		}
		return l;
	}

	public function bewege(dx:Int,dy:Int):Int{
		if (gewonnen()){
			return -1;
		}

		loeschBewegungen();

		var s = spieler();

		switch(s.t){
			case "1":
				if (dx==-1 || dy==1){
					return -2;
				}
				if (dx==1){
					//Sound.play("t5")					
				} else {
					//Sound.play("t6")
				} 
			case "2":
				if (dx==-1 || dy==-1){
					return -2;
				}
				if (dy==1){
					//Sound.play("t5")					
				} else {
					//Sound.play("t6")
				} 
			case "3":
				if (dx==1 || dy==-1){
					return -2;
				}
				if (dx==-1){
					//Sound.play("t5")					
				} else {
					//Sound.play("t6")
				} 
			case "4":
				if (dx==1 || dy==1){
					return -2;
				}
				if (dy==-1){
					//Sound.play("t5")					
				} else {
					//Sound.play("t6")
				} 
		}
		//OOB
		{
			var tx = s.x+dx;
			var ty = s.y+dy;
			if (tx<0||ty<0||tx>=9||ty>=9){
				return -1;
			}
		}

		var e1 = entAuf(s.x+dx,s.y+dy);
		if (e1==null){
			s.von = s.copy();
			s.x+=dx;
			s.y+=dy;		
			s.cycle();

			return 1;
		}

		var e2 = entAuf(s.x+2*dx,s.y+2*dy);
		if (e1.t=="Klotz" && (e2==null)){
			s.von = s.copy();
			s.x+=dx;
			s.y+=dy;	
			s.cycle();


			var tx = e1.x+dx;
			var ty = e1.y+dy;
			if (tx<0||ty<0||tx>=9||ty>=9){
				return -1;
			}

			e1.von = e1.copy();
			e1.x+=dx;
			e1.y+=dy;

			return 1;
		}

		return -1;
	}

	public function spieler():Entity{
		for(e in entities){
			if (e.t=="1"||e.t=="2"||e.t=="3"||e.t=="4"){
				return e;
			}
		}
		trace("ERROR asdf1231");
		return null;
	}

	function entAuf(x:Int,y:Int):Entity{
		for(e in entities){
			if (e.x==x&&e.y==y){
				return e;
			}
		}
		return null;
	}
}


class Game {	

	var gameState:Level;

	var undoStack:Array<Level>;

	var levelout:Bool;

	function initLevel(){
		gameState=  new Level();
		

		switch(Globals.level){
			case 0:
				for (i in 0...9){
					gameState.entities.push(new Entity(i,0,"Wand"));
					gameState.entities.push(new Entity(i,8,"Wand"));
				}
				// gameState.ziele.push(new Entity(6,5,"Ziel"));
				// gameState.entities.push(new Entity(5,5,"Klotz"));
				// gameState.entities.push(new Entity(4,5,"2"));

				gameState.ziele.push(new Entity(2,3,"Ziel"));
				gameState.entities.push(new Entity(6,3,"Klotz"));
				gameState.entities.push(new Entity(4,5,"2"));
			case 1:
				gameState.ziele.push(new Entity(3,3,"Ziel"));
				gameState.ziele.push(new Entity(3,5,"Ziel"));
				gameState.ziele.push(new Entity(5,3,"Ziel"));
				gameState.ziele.push(new Entity(5,5,"Ziel"));
				gameState.entities.push(new Entity(4,3,"Klotz"));
				gameState.entities.push(new Entity(3,4,"Klotz"));
				gameState.entities.push(new Entity(4,5,"Klotz"));
				gameState.entities.push(new Entity(5,4,"Klotz"));

				gameState.entities.push(new Entity(4,7,"1"));
			case 2:
				for (i in 0...9){
					gameState.entities.push(new Entity(i,0,"Wand"));
					gameState.entities.push(new Entity(i,1,"Wand"));
					gameState.entities.push(new Entity(i,6,"Wand"));
					gameState.entities.push(new Entity(i,7,"Wand"));
					gameState.entities.push(new Entity(i,8,"Wand"));
				}
				gameState.ziele.push(new Entity(2,3,"Ziel"));
				gameState.entities.push(new Entity(4,3,"Wand"));
				gameState.entities.push(new Entity(6,3,"Klotz"));
				gameState.entities.push(new Entity(4,5,"1"));
		}
	}
	var s:String;

	var alternate:Int=0;

	var spintimer:Int=0;
	var spintimerenabled:Bool=false;
	var flickerplayer=false;
	var outplayerparticles=false;
	var hideplayer=false;
	var dunkelgitter=false;
	var dark=false;
	var extendarms=false;
	var extendarmstimer=0;

	function setup(){
		dark=false;


		outplayerparticles=false;
		flickerplayer=false;
		hideplayer=false;
		spintimerenabled=false;
		spintimer=0;
		s="Level " + (Globals.level+1) +S("/3","/3");
		frame=0;
		jitter=0;
		initLevel();
		undoStack = new Array<Level>();
		undoStack.push(gameState.copy());
		alternate=0;
		levelout=false;
		jittered=false;
		undoing=false;
		shimmer=false;
        ende=false;


		dunkelgitter=true;
		extendarms=false;
		extendarmstimer=0;

		haxegon.Core.delaycall(
			function(){
				dunkelgitter=false;
				extendarms=true;
				},
			0.2);


	}

	function reset(){
		setup();
	}
	

	function init(){
		setup();
	}	

	private var selection:Int=0;

	private var ende:Bool;
	
	public function actiongeradegedreckt(){
		return (							
					Input.justpressed(Key.X)||
					Input.justpressed(Key.C)||
					Input.justpressed(Key.ENTER)||
					Input.justpressed(Key.SPACE)||
					Mouse.leftclick()
				);
	}
	
	var frame:Int;
	var bewegdauer:Int=10;
	var jitter:Int;
	var jdx:Int;
	var jdy:Int;
	
	function renderLevel(){
		jitter--;
		frame++;

		if (extendarms){
			extendarmstimer++;
			if (Math.ceil(extendarmstimer/5)>=4){
				extendarms=false;
			}
		}
		Gfx.clearscreen(PAL.l0);

		Gfx.drawbox(0,0,Gfx.screenwidth,Gfx.screenheight,PAL.l1);

		Gfx.setpixel(0,0,0);
		Gfx.setpixel(93,0,0);
		Gfx.setpixel(0,93,0);
		Gfx.setpixel(93,93,0);
		
		for (i in 0...9){
			for (j in 0...9){
				var col=dunkelgitter?PAL.l1:PAL.l2;
				if ((i+j)%2==0){
					col=dunkelgitter?PAL.l0:PAL.l1;
				} else {

				}

				Gfx.fillbox(2+i*10,2+j*10,10,10,col);
			}
		}
		switch(level){
			case 0:
				Gfx.setpixel(2,12,PAL.l0);
				Gfx.setpixel(91,12,PAL.l0);
				Gfx.setpixel(2,81,PAL.l0);
				Gfx.setpixel(91,81,PAL.l0);
			case 1:
				Gfx.setpixel(2,2,PAL.l0);
				Gfx.setpixel(91,2,PAL.l0);
				Gfx.setpixel(2,91,PAL.l0);
				Gfx.setpixel(91,91,PAL.l0);
			case 2:
				Gfx.setpixel(2,22,PAL.l0);
				Gfx.setpixel(91,22,PAL.l0);
				Gfx.setpixel(2,61,PAL.l0);
				Gfx.setpixel(91,61,PAL.l0);
		}

		
		for (e in gameState.ziele){
			var x = e.x;

			var y = e.y;
			var ox = 2+e.x*10+0.5;
			var oy = 2+e.y*10+0.5;
			var col=dunkelgitter?PAL.l0:PAL.l1;
			if ((e.x+e.y)%2==0){
				col=dunkelgitter?PAL.l1:PAL.l2;
			}
			Gfx.drawbox(ox+2,oy+2,6,6,col);
		}



		Gfx.linethickness=1;

		
		for (e in gameState.entities){
			var x = e.x;
			var y = e.y;

			var ox = 2+e.x*10+0.5;
			var oy = 2+e.y*10+0.5;


			if (frame<bewegdauer && e.von!=null || (spintimerenabled&&e.spieler()) ){
				var vx =e.x;
				var vy =e.y;
				if (e.von != null && frame<bewegdauer){
					vx = e.von.x;
					vy = e.von.y;
				}
				
				var dx = e.x-vx;
				var dy = e.y-vy;

				var pc = frame/bewegdauer;
				if (spintimerenabled){
					pc=spintimer/bewegdauer+1;
				}
				var pixeloffset=Math.ceil(pc*10);
				ox=2+vx*10+pixeloffset*dx+0.5;
				oy=2+vy*10+pixeloffset*dy+0.5;

				if (e.spieler()&&hideplayer){
					continue;
				}
				if (e.spieler()  ){
					if (flickerplayer && alternate<5){
						return;
					}
					if (undoing){
						pc=2-pc;//-pc-1;
					}
					var winkel = ((1-pc)/4-e.frame()/4)*Math.PI*2;
					var dx1 = Math.cos(winkel)*4;
					var dy1 = -Math.sin(winkel)*4;
					var dx2 = Math.cos(winkel+Math.PI/2)*4;
					var dy2 = -Math.sin(winkel+Math.PI/2)*4;

					if (spintimerenabled && shimmer==false){
						dx1*=0.75;	
						dy1*=0.75;	
						dx2*=0.75;	
						dy2*=0.75;	
					}

					Gfx.drawline(ox+4,oy+4,ox+4+dx1,oy+4+dy1,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+dx2,oy+4+dy2,PAL.l3);

					ox+=1;
					Gfx.drawline(ox+4,oy+4,ox+4+dx1,oy+4+dy1,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+dx2,oy+4+dy2,PAL.l3);

					oy+=1;
					Gfx.drawline(ox+4,oy+4,ox+4+dx1,oy+4+dy1,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+dx2,oy+4+dy2,PAL.l3);

					ox-=1;
					Gfx.drawline(ox+4,oy+4,ox+4+dx1,oy+4+dy1,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+dx2,oy+4+dy2,PAL.l3);



					Gfx.fillbox(ox+4,oy+3,2,2,PAL.l0);
					return;
				}
			}

			if (jitter>0 && e.spieler()){					
				ox+=jdx;//Random.int(-1,1);
				oy+=jdy;//Random.int(-1,1);				
			}
			
			switch(e.t){			
				case "Klotz":
					if (dunkelgitter){
						continue;
					}
					//if (levelout==false || shimmer==true)
					{
						if (levelout==false || spintimer< bewegdauer+45){
							
							if (levelout&&frame>bewegdauer+20){					
								//ox+=Random.int(-1,1);
								//oy+=Random.int(-1,1);				
								Gfx.drawbox(ox+2,oy+2,10-4,10-4,PAL.l3);
								if (frame<bewegdauer+40){
									Gfx.drawbox(ox+1,oy+1,10-2,10-2,PAL.l3);
								}
							} else {
								Gfx.drawbox(ox,oy,10,10,PAL.l3);
								Gfx.drawbox(ox+1,oy+1,10-2,10-2,PAL.l3);
							}

						}
					}
				case "Wand":					
					Gfx.fillbox(ox,oy,10,10,PAL.l0);
					if (Globals.level==2&&e.y==3){
						Gfx.fillbox(ox,oy,1,1,PAL.l2);
						Gfx.fillbox(ox+9,oy,1,1,PAL.l2);
						Gfx.fillbox(ox+9,oy+9,1,1,PAL.l2);
						Gfx.fillbox(ox,oy+9,1,1,PAL.l2);
					}
				case "1":	
					if (dunkelgitter){
						continue;
					}	

					
					var e = 4;
					if (extendarms){
						e=Math.ceil(extendarmstimer/5);
					}

					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);

					ox++;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);

					oy++;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);

					ox--;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);

					Gfx.fillbox(ox+4,oy+3,2,2,PAL.l0);
				case "2":
					if (dunkelgitter){
						continue;
					}

					
					var e = 4;
					if (extendarms){
						e=Math.ceil(extendarmstimer/5);
					}

					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					ox++;
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					oy++;
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					ox--;
					Gfx.drawline(ox+4,oy+4,ox+4+e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					Gfx.fillbox(ox+4,oy+3,2,2,PAL.l0);
				case "3":
					if (dunkelgitter){
						continue;
					}

					
					var e = 4;
					if (extendarms){
						e=Math.ceil(extendarmstimer/5);
					}

					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					ox++;
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					oy++;
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					ox--;
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4+e,PAL.l3);

					Gfx.fillbox(ox+4,oy+3,2,2,PAL.l0);
				case "4":
					if (dunkelgitter){
						continue;
					}

					
					var e = 4;
					if (extendarms){
						e=Math.ceil(extendarmstimer/5);
					}

					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);

					ox++;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);

					oy++;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);

					ox--;
					Gfx.drawline(ox+4,oy+4,ox+4,oy+4-e,PAL.l3);
					Gfx.drawline(ox+4,oy+4,ox+4-e,oy+4,PAL.l3);

					Gfx.fillbox(ox+4,oy+3,2,2,PAL.l0);
			}
		}
	}

	function spawnPartikeln(count:Int){
			
		for (e in gameState.entities){
			if (e.t!="Klotz"){
				continue;
			}
			var ox = 2+e.x*10;
			var oy = 2+e.y*10;
			Particle.GenerateParticles(
					{
						min:ox,
						max:ox+10,
					},
					{
						min:oy,
						max:oy+10,
					},
					PAL.l3,//color
					count,//count
					0,//gravityx
					0,//gravityy
					{//lebenzeit
						min:1,
						max:1
					},
					{//angle
						min:0,
						max:360
					},
					{//velx
						min:-10, max:10
					},
					{//vely
						min:-10, max:-10
					},
					{
						min:20,
						max:20
					},
					{
						min:2,max:2
					},
					{
						min:1,max:1
					}
				);
		}
	}



	function spawnPlayerPartikeln(count:Int){			
		
		var e = gameState.spieler();

		var ox = 2+e.x*10;
		var oy = 2+e.y*10;
		Particle.GenerateParticles(
				{
					min:ox+2,
					max:ox+10-4,
				},
				{
					min:oy+2,
					max:oy+10-4,
				},
				PAL.l3,//color
				count,//count
				0,//gravityx
				0,//gravityy
				{//lebenzeit
					min:1,
					max:1
				},
				{//angle
					min:0,
					max:360
				},
				{//velx
					min:-10, max:10
				},
				{//vely
					min:-10, max:-10
				},
				{
					min:20,
					max:20
				},
				{
					min:2,max:2
				},
				{
					min:1,max:1
				}
			);
	
	}




	function spawnSchwarzPlayerPartikeln(count:Int){			
		
		var e = gameState.spieler();

		var ox = 2+e.x*10;
		var oy = 2+e.y*10;
		Particle.GenerateParticles(
				{
					min:ox+5-1,
					max:ox+5+1,
				},
				{
					min:oy+5-1,
					max:oy+5+1,
				},
				PAL.l0,//color
				count,//count
				0,//gravityx
				0,//gravityy
				{//lebenzeit
					min:1,
					max:1
				},
				{//angle
					min:0,
					max:360
				},
				{//velx
					min:-10, max:10
				},
				{//vely
					min:-10, max:-10
				},
				{
					min:20,
					max:20
				},
				{
					min:2,max:2
				},
				{
					min:1,max:1
				}
			);
	
	}
	function versuchBewegung(dx:Int,dy:Int){
		var moved = gameState.bewege(dx,dy);
		if (moved>=0){
			undoStack.push(gameState.copy());
			frame=0;
			jittered=false;
			jitter=0;
			undoing=false;

			if (gameState.gewonnen()){
				if (!levelout){
					levelout=true;
					shimmer=true;
					var delay:Float=bewegdauer/30;

					haxegon.Core.delaycall(
						function(){
							alternate=0;
							spintimerenabled=true;
							},
						delay);

					haxegon.Core.delaycall(
						function(){
							spawnPartikeln(10);
							},
						delay+0.5);
					haxegon.Core.delaycall(
						function(){
							shimmer=false;
							//Sound.play("t8");
							},
						delay+1.0);


					haxegon.Core.delaycall(
						function(){
							flickerplayer=true;
							alternate=0;
							},
						delay+1.5);


					haxegon.Core.delaycall(
						function(){
							outplayerparticles=true;
							},
						delay+1.5);

					haxegon.Core.delaycall(
						function(){
							hideplayer=true;
							//Sound.play("t7");
							spawnSchwarzPlayerPartikeln(2);
							outplayerparticles=false;
							},
						delay+2.3);


					haxegon.Core.delaycall(
						function(){
							dunkelgitter=true;
							},
						delay+3.1);

					haxegon.Core.delaycall(
						function(){
							Globals.level++;
							haxegon.Scene.change(LevelIntro);
							},
						delay+3.3);
				}
			}
		} else if (moved==-2 && frame>=bewegdauer ){
			jitter=3;
			jittered=true;
			jdx=dx;
			jdy=dy;
		}
	}
	var jittered:Bool=false;
	var undoing:Bool=false;
	var shimmer:Bool=false;
	//nim aimatioie von nachLevel
	function reverseAnims(vor:Level,nachLevel:Level){
		for(i in 0...vor.entities.length){
			var e_vor=vor.entities[i];
			var e_nach=nachLevel.entities[i];

			e_vor.von=null;

			if (e_nach.von!=null){
				trace("ADDED anim");
				e_vor.von=e_nach.copy();
			}
		}
	}

	function repeatpressed(k:Key):Bool{
		return (Input.justpressed(k) ||
				( frame>bewegdauer && Input.pressed(k) ));
	}

	function update() {
		if (dark){		
			Gfx.clearscreen(PAL.l0);

			Gfx.drawbox(0,0,Gfx.screenwidth,Gfx.screenheight,PAL.l1);

			Gfx.setpixel(0,0,0);
			Gfx.setpixel(93,0,0);
			Gfx.setpixel(0,93,0);
			Gfx.setpixel(93,93,0);
			return;
		}
		alternate=(alternate+1)%10;

		if (levelout&&shimmer&&frame>=bewegdauer && alternate%2==0){
			spawnPartikeln(1);
		}

		if (outplayerparticles && alternate%2==0){
			spawnPlayerPartikeln(1);
		}

		if (levelout==false && dunkelgitter==false && extendarms==false){
			if (Input.justpressed(Key.UP)){
				versuchBewegung(0,-1);
			}
			if (Input.justpressed(Key.DOWN)){
				versuchBewegung(0,1);			
			}
			if (Input.justpressed(Key.LEFT)){
				versuchBewegung(-1,0);						
			}
			if (Input.justpressed(Key.RIGHT)){
				versuchBewegung(1,0);						
			}
			

			if (Input.justpressed(Key.ESCAPE)){
				dunkelgitter=true;
				haxegon.Core.delaycall(
					function(){
						dark=true;
						},
					0.2);		
				haxegon.Core.delaycall(
					function(){
						Globals.level=0;
						haxegon.Scene.change(Main);
						},
					0.4);			
			}

			if (repeatpressed(Key.Z)){
				if (undoStack.length>1){
					frame=0;
					jitter=0;
					var nach = undoStack.pop();
					gameState = undoStack[undoStack.length-1].copy();
					reverseAnims(gameState,nach);				
					undoing=true;
				}					
			}

			if (Input.justpressed(Key.R)){
				if (undoStack.length>1){
					undoStack.push(undoStack[0].copy());
					gameState = undoStack[0].copy();
				}					
			}
		}

		if (spintimerenabled){			
			spintimer++;
			if (shimmer==false && alternate>=5){
				spintimer++;
			}
		}

		renderLevel();		
	}

}