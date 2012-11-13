package  {
	
	import flash.display.MovieClip;
	import flashx.textLayout.accessibility.TextAccImpl;
	import flash.events.Event;
	
	
	public class Tooltip extends MovieClip {
		
		public var keepUp:Boolean;
		public var linkedWidget:Object;
		
		public function Tooltip(_linkedWidget:Object) {
			
			linkedWidget = _linkedWidget;
			keepUp = true;
			
			scaleX = 0.6;
			scaleY = 0.6;
			
			x = linkedWidget.x + (linkedWidget.width / 2);
			y = linkedWidget.y - (linkedWidget.height / 2);
			
			addEventListener(Event.ENTER_FRAME, doFrame);
		}
		
		public function doFrame(e:Event):void {
			if (currentFrame == 24 && keepUp) {
				stop();
				textTotal.text = "$" + linkedWidget.total;
				textPacs.text = linkedWidget.percentPacs + "%";
			} else if (currentFrame == 24 && !keepUp) {
				play();
			} else if (currentFrame == 48) {
				removeEventListener(Event.ENTER_FRAME, doFrame);
				parent.removeChild(this);
			}
		}
	}
}