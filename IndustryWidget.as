package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flashx.textLayout.formats.Float;
	
	
	public class IndustryWidget extends MovieClip {
		
		public var industryName:String;
		public var individuals:Number;
		public var pacs:Number;
		public var total:Number;
		
		public var percentPacs:Number;		
		
		public var dX:Number; // change in x due to hovering effect
		public var dY:Number; // change in y due to hovering effect
		
		public function IndustryWidget(_industryName:String, _individuals:Number,
									   _pacs:Number, _total:Number) {
			industryName = _industryName;
			individuals = _individuals;
			pacs = _pacs;
			total = _total;
			
			percentPacs = Math.round((pacs / total) * 100);
			
			// Display info
			textIndustry.text = industryName;
			
			// Set up dragging
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			
			// Set up fade in and "hovering effect"
			alpha = 0;
			dX = 0;
			dY = 0;
			addEventListener(Event.ENTER_FRAME, doFrame);
			
			// Set up backing
			backing.gotoAndStop(percentPacs);
			
			// Set up tooltip
			addEventListener(MouseEvent.ROLL_OVER, tooltipUp);
			addEventListener(MouseEvent.ROLL_OUT, tooltipDown);
		}
		
		public function tooltipUp(e:MouseEvent):void {
			// stuff
		}
		
		public function tooltipDown(e:MouseEvent):void {
			// stuff
		}
		
		public function doFrame(e:Event):void {
			// fade in
			if (alpha < 1) {
				alpha += 0.03;
			}
			// hovering effect
			// pass
		}
		
		public function startDragging(e:MouseEvent):void {
			startDrag();
		}
		
		public function stopDragging(e:Event):void {
			stopDrag();
			/*if (e.target.dropTarget.parent.name == "basket") {
				parent.removeChild(this);
			}*/
		}
	}
}