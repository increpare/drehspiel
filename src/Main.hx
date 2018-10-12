import haxegon.*;
import utils.*;
import Globals.*;


class Main {	
	
	var darkmodeenter=false;

	function setup(){
		darkmodeenter=true;
		darkmode=false;
		selection=0;
			
		weggehen=false;
		//Truetype fonts look a LOT better when we don't scale the canvas!
		//Gfx.resizescreen(0, 0);
		//Text.font = GUI.font;

		//initial all globals here

		if (!Save.exists("language")){
			Save.savevalue("language",1);
		}
		state.sprache = Save.loadvalue("language");
		if (state.sprache==0){
			state.sprache=0;//ok does't do much			
		}

		haxegon.Core.delaycall(
			function(){
				darkmodeenter=false;
				},
			0.2);
	}

	var frame:Int=0;

	function reset(){
		setup();
	}
	

	function init(){
		// Sound.play("t2");
		//Music.play("music",0,true);
		Gfx.resizescreen(94, 94,true);
		SpriteManager.enable();
		Particle.enable();
		setup();
	}	

	private var selection:Int=0;
	private var darkmode=false;
	function fangan(){
		weggehen=true;
		time=0;
		haxegon.Core.delaycall(
			function(){
				// Sound.play("t8");
				},
			0.2);
		haxegon.Core.delaycall(
			function(){
				darkmode=true;
				},
			0.5);
		haxegon.Core.delaycall(
			function(){
				Globals.level=0;
				haxegon.Scene.change(LevelIntro);
				},
			0.75);
			
	}


	var weggehen:Bool=false;
	var time=0;

	function update() {	
		frame++;
		time++;
		//mouseInput();		
		// Draw a white background

		var ox=0;
		var oy=4;

		Gfx.clearscreen(PAL.l0);

		var f = Math.ceil(frame*2/5)*5;
		Gfx.drawline(0.5,Gfx.screenheightmid-f,0.5,Gfx.screenheightmid+f,PAL.l1);
		Gfx.drawline(93.5,Gfx.screenheightmid-f,93.5,Gfx.screenheightmid+f,PAL.l1);
		Gfx.drawline(Gfx.screenwidthmid-f,0.5,Gfx.screenwidthmid+f,0.5,PAL.l1);
		Gfx.drawline(Gfx.screenwidthmid-f,93.5,Gfx.screenwidthmid+f,93.5,PAL.l1);
		
		//Gfx.drawbox(0,0,Gfx.screenwidth,Gfx.screenheight,PAL.l1);
		Gfx.setpixel(0,0,0);
		Gfx.setpixel(93,0,0);
		Gfx.setpixel(0,93,0);
		Gfx.setpixel(93,93,0);

		if (darkmode){
			Text.display(Text.CENTER,oy+2*1+2,S("Drehspiel","Rotgame"), PAL.l1);
			//Text.display(Text.CENTER,2*13,S("Start","Start"), PAL.l1 );		
			return;
		}	

		if (darkmodeenter){
			Text.display(Text.CENTER,oy+2*1+2,S("Drehspiel","Rotgame"), PAL.l1);

			Text.display(Text.CENTER,oy+2*13,S("Start","Start"), PAL.l1);
			Text.display(Text.CENTER,oy+2*19,S("DE","DE"), PAL.l1);

			return;
		}	

		var h = Gfx.screenheight;
		var w = Gfx.screenwidth;
		Text.wordwrap=w;

		Text.size=GUI.titleTextSize;
		Text.display(Text.CENTER,oy+2*1+2,S("Drehspiel","Rotgame"), PAL.l2);
				
		Text.size=1;
		trace(weggehen);
		if (weggehen){
			if (Math.floor(time/5)%2==0){
				Text.display(Text.CENTER,oy+2*13,S("Start","Start"), PAL.l3);
			} else {
				Text.display(Text.CENTER,oy+2*13,S("Start","Start"),PAL.l2 );
			}
			if (state.sprache==0){
				Text.display(Text.CENTER,oy+2*19,S("DE","DE"), PAL.l1);
			} else {
				Text.display(Text.CENTER,oy+2*19,S("EN","EN"), PAL.l1);
			}
		} else if (selection==0){
			Text.display(Text.CENTER,oy+2*13,S("[ Start ]","[ Start ]"), PAL.l2);
			if (state.sprache==0){
				Text.display(Text.CENTER,oy+2*19,S("DE","DE"), PAL.l2);
			} else {
				Text.display(Text.CENTER,oy+2*19,S("EN","EN"), PAL.l2);
			}
		} else if (selection==1){
			Text.display(Text.CENTER,oy+2*13,S("Start","Start"), PAL.l2);
			if (state.sprache==0){
				Text.display(Text.CENTER,oy+2*19,S("[ DE ]","[ DE ]"), PAL.l2);
			} else {
				Text.display(Text.CENTER,oy+2*19,S("[ EN ]","[ EN ]"), PAL.l2);
			}
		} else {
			Text.display(Text.CENTER,oy+2*13,S("Start","Start"), PAL.l2);
			if (state.sprache==0){
				Text.display(Text.CENTER,oy+2*19,S("DE","DE"), PAL.l2);
			} else {
				Text.display(Text.CENTER,oy+2*19,S("EN","EN"), PAL.l2);
			}

		}
		
		Text.display(ox+3,oy+2*29,S("Steuerung:","Controls:"),  PAL.l1);
		Text.display(ox+4*2,oy+2*34,S("Pfeiltasten ","Cursor Keys"),  PAL.l1);
		Text.display(ox+4*2,oy+2*39,S("Z (Widerrufen)","Z (Undo)"), PAL.l1);
	
		if (weggehen){
			return;
		}
		
		if (Input.justpressed(Key.UP) || Input.justpressed(Key.DOWN)){
			if (selection==-1){
				if (Input.justpressed(Key.DOWN)){
					selection=1;		
					// Sound.play("t5");
				} else {
					selection=0;	
					// Sound.play("t6");
				}
			} else {
				selection=1-selection;			
				if (selection==1){						
					// Sound.play("t5");
				} else {	
					// Sound.play("t6");
				}
			}
		}

		if(selection==1){
			if (
				Input.justpressed(Key.LEFT) || 
				Input.justpressed(Key.RIGHT) || 
				Input.justpressed(Key.X)||
				Input.justpressed(Key.ENTER)||
				Input.justpressed(Key.SPACE)
				) {
				state.sprache=1-state.sprache;
				// Sound.play("t6");
				Save.savevalue("language",state.sprache);
			}
		} else {
			if (Input.justpressed(Key.X)||Input.justpressed(Key.ENTER)||Input.justpressed(Key.SPACE)){
				fangan();
			}
		}
	}
}
