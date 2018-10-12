import haxegon.*;
import utils.*;
import Globals.*;


class LevelIntro {	

	var s:String;
	function setup(){
        ende=false;
		if (Globals.level<3){
			s="Level " + (Globals.level+1) +S("/3","/3");
		} else {
			s =S("Du bist der Drehmeister bzw. die Drehmeisterin!","You are the Spinmaster!");
		}
		frame=-50;

		if (Globals.level==3){
			Particle.GenerateParticles(
					{
						min:0,
						max:Gfx.screenwidth,
					},
					{
						min:-10,
						max:0,
					},
					PAL.l3,//color
					10,//count
					0,//gravityx
					.1,//gravityy
					{//lebenzeit
						min:20,
						max:20
					},
					{//angle
						min:0,
						max:360
					},
					{//velx
						min:-5, max:5
					},
					{//vely
						min:10, max:10
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
					Input.justpressed(Key.ESCAPE)||
					Mouse.leftclick()
				);
	}

	var frame:Int;
	function update() {

		if (Globals.level==3 && Random.int(1,7)==4){
			Particle.GenerateParticles(
					{
						min:0,
						max:Gfx.screenwidth,
					},
					{
						min:-10,
						max:0,
					},
					Random.pick([PAL.l1,PAL.l2,PAL.l3]),					
					1,//count
					0,//gravityx
					0,//gravityy
					{//lebenzeit
						min:20,
						max:20
					},
					{//angle
						min:0,
						max:360
					},
					{//velx
						min:-5, max:5
					},
					{//vely
						min:10, max:10
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
		frame++;
		if (frame%3==0){
			// Sound.play("t1",0,0,Random.float(0.2,0.5));
		}
		var canInput:Bool=false;
		var toDisplay:String=s.substr(0,Math.floor(frame/3));
		if (toDisplay.length<s.length){
			toDisplay+="_";
		} else {
			canInput=true;
		}
		
		Gfx.clearscreen(PAL.l0);

		if (frame>=0 && ende==false){
			
			if (Globals.level==3){
				Text.wordwrap = Gfx.screenwidth-6-3;
				Text.display(6,26,toDisplay,PAL.l2);	
			} else {
				Text.display(Text.CENTER,Text.CENTER,toDisplay,PAL.l2);	
			}

			if (canInput&&actiongeradegedreckt()){
				ende=true;
				haxegon.Core.delaycall(
					function(){
							if (Globals.level<3){
								haxegon.Scene.change(Game);
							} else {
								Globals.level=0;
								Particle.clear();
								haxegon.Scene.change(Main);
							}
						},
					0.5);
			}		
		}

		Particle.forcerender();
		
		Gfx.drawbox(0,0,Gfx.screenwidth,Gfx.screenheight,PAL.l1);
		Gfx.setpixel(0,0,0);
		Gfx.setpixel(93,0,0);
		Gfx.setpixel(0,93,0);
		Gfx.setpixel(93,93,0);


		

	}
}