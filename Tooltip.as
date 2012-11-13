package  {
	
	import flash.display.MovieClip;
	import flashx.textLayout.accessibility.TextAccImpl;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Tooltip extends MovieClip {
		
		public var linkedWidget:Object;
		public var stayAlive:Boolean;
		
		public function Tooltip(_linkedWidget:Object) {
			
			linkedWidget = _linkedWidget;
			stayAlive = true;
			
			scaleX = 0.6;
			scaleY = 0.6;
			
			addEventListener(Event.ENTER_FRAME, doFrame);
			linkedWidget.addEventListener(MouseEvent.ROLL_OUT, fadeAway);
		}
		
		public function doFrame(e:Event):void {
			x = parent.mouseX;
			y = parent.mouseY - 100;
			if (currentFrame == 24 && stayAlive) {
				stop();
				e.target.textTotal.text = "$" + linkedWidget.total;
				//textPacs.text = linkedWidget.percentPacs + "%";
			} else if (currentFrame == 24 && !stayAlive) {
				play();
			} else if (currentFrame == 48) {
				removeEventListener(Event.ENTER_FRAME, doFrame);
				parent.removeChild(this);
			}
		}
		
		public function fadeAway(e:MouseEvent):void {
			stayAlive = false;
			linkedWidget.removeEventListener(MouseEvent.ROLL_OUT, fadeAway);
		}
	}
}