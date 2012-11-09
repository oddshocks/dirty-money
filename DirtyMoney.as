package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	
	public class DirtyMoney extends MovieClip {
		
		public var dataRequest:URLRequest;
		public var dataLoader:URLLoader;	
		
		public function DirtyMoney() {
			stop();
			// Set up preloader
			preloader.stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, doLoadingProgress);
			
			// Load CSV file containing candidate IDs
			dataRequest = new URLRequest("crp_ids.csv");
			dataLoader = new URLLoader();
			
			// Call storeCSVData() when the file is fully loaded
			dataLoader.addEventListener(Event.COMPLETE, storeCSVData);
			dataLoader.load(dataRequest);
		}
		
		public function doLoadingProgress(e:ProgressEvent):void {
			var percentage:Number = Math.floor((e.bytesLoaded/e.bytesTotal) * 100);
			preloader.gotoAndStop(percentage);
			if (percentage == 100) {
				gotoAndStop("Main");
			}
		}
		
		public function storeCSVData(e:Event):void {
			// split data based on os-agnostic regex for newline
			var csvData:Array = dataLoader.data.split(/\r\n|\n|\r/);
			// make it a 2-dim array by splitting with a comma delimiter
			for (var i:int = 0; i < csvData.length; i++) {
				csvData[i] = csvData[i].split(",");
			}
		}
	}
	
}
