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
			
			// Set up fade in
			alpha = 0;
			addEventListener(Event.ENTER_FRAME, doFrame);
			
			// Set up backing
			backing.gotoAndStop(percentPacs);
		}
		
		public function doFrame(e:Event):void {
			// fade in
			if (alpha < 1) {
				alpha += 0.03;
			}
		}
		
		public function startDragging(e:MouseEvent):void {
			startDrag();
		}
		
		public function stopDragging(e:Event):void {
			stopDrag();
		}
	}
}