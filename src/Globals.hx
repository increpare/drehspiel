package;
import haxegon.*;

#if js
import js.Browser;
#end


class Globals
{
    public static var level:Int=0;

    public static function mPlayNote(seed:Int,frequency:Float,length:Float,volume:Float){
        #if js
        untyped playNote(seed,frequency,length,volume/2);
        #end
    }



  public static var PAL = {
      l0 : 0x061519,
      l1 : 0x1d3136,
      l2 : 0x31484e,
      l3 : 0x6a7f85,

      fg : 0xedf1f9,  
      bg : 0x140c1c,
      gray : 0x888888,
      buttonTextCol : 0xedf1f9,
      buttonBorderCol : 0xedf1f9,
      buttonCol : 0x140c1c,
      buttonHighlightCol : 0xbec8cf,
      buttonHighlightCol2 : 0x8695a0,
      titelFarbe: 0x30484e,
  };

  public static var GUI = {
      smalltextsize:1,
      textsize:1,
      buttonTextSize:1,
      buttonPaddingX : 10,
      buttonPaddingY : 1,
      linethickness : 1,
      titleTextSize:1,
      subTitleTextSize:1,
      vpadding:5,
      healthbarheight:10,
      subSubTitleTextSize:1,
      
      screenPaddingTop:15,
      
      font:"pixel",
  };

  public static var state = {
      sprache:0,
      auserwaehlte:0,
      ort:0,
  };

  public static function S(de:String,en:String):String{
      if (state.sprache==0){
          return de;
      } else {
        return en;
      }
  }
}