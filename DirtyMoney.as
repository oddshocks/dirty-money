package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	
	public class DirtyMoney extends MovieClip {
		
		public const API_KEY:String = "ac40037846c017c68fc9f5b804bd015d";
		
		public var dataRequest:URLRequest;
		public var dataLoader:URLLoader;
		public var csvData:Array;
		
		public var politicianName:String;
		
		public function DirtyMoney() {
			stop();
			// Set up preloader
			preloader.stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, doLoadingProgress);
			
			// Load CSV file containing candidate IDs
			dataRequest = new URLRequest("crp_ids.csv");
			dataLoader = new URLLoader();
			dataLoader.load(dataRequest);
			
			// Call storeCSVData() when the file is fully loaded
			dataLoader.addEventListener(Event.COMPLETE, storeCSVData);
			

		}
		
		public function doLoadingProgress(e:ProgressEvent):void {
			var percentage:Number = Math.floor((e.bytesLoaded/e.bytesTotal) * 100);
			preloader.gotoAndStop(percentage);
			if (percentage == 100) {
				gotoAndStop("Main");
				// Set up searching
				
				tfSearch.textInput.addEventListener(KeyboardEvent.KEY_UP, doSearchFieldChange);
			}
		}
		
		public function doSearchFieldChange(e:KeyboardEvent):void {
			for (var line:int = 0; line < csvData.length; line++) {
				// concatinate name, remove double quotes, and strip leading and trailing whitespace
				politicianName = (csvData[line][2] + " " + csvData[line][1]).replace(/"/gi, "").replace(/^\s+|\s+$/g, "");
				if (politicianName.toLowerCase() == e.target.text.toLowerCase()) {
					textStatus.text = "Found politician!";
					break;
				} else {
					// Display politician name capitalized properly with regex
					textStatus.text = "Politician "
						+ e.target.text.replace(/\b[a-z]/g, function($0){return $0.toUpperCase();})
						+ " not found.";
				}
			}
		}
		
		public function storeCSVData(e:Event):void {
			// split data based on os-agnostic regex for newline
			csvData = dataLoader.data.split(/\r\n|\n|\r/);
			// make it a 2-dim array by splitting with a comma delimiter
			for (var i:int = 0; i < csvData.length; i++) {
				csvData[i] = csvData[i].split(",");
			}
		}
	}
	
}
