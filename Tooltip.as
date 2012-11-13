package  {
	
	import flash.display.MovieClip;
	import flashx.textLayout.accessibility.TextAccImpl;
	
	
	public class Tooltip extends MovieClip {
		
		public var keepUp:Boolean;
		
		public function Tooltip(t:String) {
			
			keepUp = true;
			
			width = 200;
			height = 100;
			
			textTooltip.text = t;
			
			
			// use undocumented method to stop on frames 24 and 48
			addFrameScript(24, function():void {
				if (keepUp) {
					stop();
				}
			});
			addFrameScript(48, function():void {
				stop();
				parent.removeChild(this);
			});
		}
	}
}