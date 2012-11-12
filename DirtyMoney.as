package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.errors.IOError;
	
	
	public class DirtyMoney extends MovieClip {
		
		public const API_KEY:String = "ac40037846c017c68fc9f5b804bd015d";
		public const API_BASE_URL:String
			= "http://www.opensecrets.org/api/?method=candIndustry&cid=";
		public const DATE:Date = new Date();
		public const DRAG_BOUND_X_MIN = 20;
		public const DRAG_BOUND_X_MAX = 700;
		public const DRAG_BOUND_Y_MIN = 250;
		public const DRAG_BOUND_Y_MAX = 400;
		
		public var csvRequest:URLRequest;
		public var csvLoader:URLLoader;
		public var csvData:Array;
		public var xmlRequest:URLRequest;
		public var xmlLoader:URLLoader;
		public var xmlData:XML;
		public var dataInfo:XMLList;
		public var industries:XMLList;
		
		public var candidateName:String;
		
		public var industryWidgets:Array;
		
		public var topContribution:Number;
		public var zoomLevel:Number;
		
		public function DirtyMoney() {
			stop();
			// Set up preloader
			preloader.stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, doLoadingProgress);
			
			// set up array to hold industry widgets
			industryWidgets = new Array();
			
			// Load CSV file containing candidate IDs
			csvRequest = new URLRequest("crp_ids.csv");
			csvLoader = new URLLoader();
			csvLoader.load(csvRequest);
			
			// Call storeCSVData() when the file is fully loaded
			csvLoader.addEventListener(Event.COMPLETE, storeCSVData);
		}
		
		public function doLoadingProgress(e:ProgressEvent):void {
			var percentage:Number = Math.floor((e.bytesLoaded/e.bytesTotal) * 100);
			preloader.gotoAndStop(percentage);
			if (percentage == 100) {
				gotoAndStop("Main");
				
				// Set up searching
				textInput.addEventListener(KeyboardEvent.KEY_UP, doSearchFieldChange);
				
				// Set up zooming
				zoomLevel = sliderZoom.value;
				sliderZoom.addEventListener(Event.CHANGE, changeZoom);
				
				// Do a default candidate search, to show an example
				candidateSearch("N00007360");
			}
		}
		
		public function changeZoom(e:Event):void {
			zoomLevel = e.target.value;
			renderZoom();
		}
		
		public function doSearchFieldChange(e:KeyboardEvent):void {
			if (textInput.text != "") {
				for (var line:int = 0; line < csvData.length; line++) {
					// concatinate name, remove double quotes, and strip leading and trailing whitespace
					candidateName = (csvData[line][2] + " "
									 + csvData[line][1]).replace(/"/gi, "").replace(/^\s+|\s+$/g, "");
					if (candidateName.toLowerCase() == e.target.text.toLowerCase()) {
						// make the API request
						candidateSearch(csvData[line][0]);
						break;
					} else {
						// Display candidate name capitalized properly with regex
						textName.text = e.target.text.replace(/\b[a-z]/g,
															  function($0){return $0.toUpperCase();})
							+ " not found.";
					}
				}
			}
		}
		
		public function candidateSearch(cid:String):void {
			// Load XML data based on candidate ID
			/* Disable API requests while the API is being goofy
			xmlRequest = new URLRequest(API_BASE_URL
											+ cid + "&cycle="
											+ DATE.fullYear + "&apikey="
											+ API_KEY);
			trace(API_BASE_URL
											+ cid + "&cycle="
											+ DATE.fullYear + "&apikey="
											+ API_KEY);
			*/
			xmlRequest = new URLRequest("docs/example_response.xml");
			xmlLoader = new URLLoader();
			xmlLoader.load(xmlRequest);
			
			// Watch for IO errors (missing candidate info)
			// Unfortunately, an error will still print in the Flash output frame
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			// Call storeXMLData() when the file is fully loaded
			xmlLoader.addEventListener(Event.COMPLETE, storeXMLData);
		}
		
		public function onIOError(e:IOErrorEvent):void {
			textName.text = "No info for " + candidateName + ".";
		}
		
		public function storeCSVData(e:Event):void {
			// split data based on os-agnostic regex for newline
			csvData = csvLoader.data.split(/\r\n|\n|\r/);
			// make it a 2-dim array by splitting with a comma delimiter
			for (var i:int = 0; i < csvData.length; i++) {
				csvData[i] = csvData[i].split(",");
			}
		}
		
		public function storeXMLData(e:Event):void {
			xmlData = new XML(xmlLoader.data);
			
			// get response
			dataInfo = xmlData.elements("industries");
			industries = dataInfo.elements("industry");
			
			// display the info
			displayCandidateInfo();
		}
		
		public function displayCandidateInfo():void {
			/** There will only be one XML object, but a for loop works to get it
			 * I'm not sure how to get a specific element from an XMLList, if you
			 * can at all. The docs don't seem to expose a method of XMLList which
			 * returns an XML object.
			 */
			
			// get metadata
			for each (var d:XML in dataInfo) {
				textName.text = d.@cand_name;
			
				// set footer info
				textFooter.text = d.@cycle + " cycle data for candidate ID "
									+ d.@cid
									+ " pulled from: " + d.@origin
									+ "\nData last updated " + d.@last_updated
									+ ". Source: " + d.@source;
			}
			
			// get industry data
			for each (var i:XML in industries) {
				// create IndustryWidget in random location
				var widget = new IndustryWidget(i.@industry_name,
												i.@indivs, i.@pacs, i.@total);
				widget.x = Math.random() * (DRAG_BOUND_X_MAX - DRAG_BOUND_X_MIN)
							+ DRAG_BOUND_X_MIN;
				widget.y = Math.random() * (DRAG_BOUND_Y_MAX - DRAG_BOUND_Y_MIN)
							+ DRAG_BOUND_Y_MIN;
				industryWidgets.push(widget);
				addChild(widget);
			}
			
			// get largest total contribution
			topContribution = 0;
			for each (var w:IndustryWidget in industryWidgets) {
				if (w.total > topContribution) {
					topContribution = w.total;
				}
			}
			
			renderZoom();
		}
		
		public function renderZoom():void {
			// scale IndustryWidgets based on zoom level
			for each (var w:IndustryWidget in industryWidgets) {
				w.scaleX = (w.total / topContribution) * (zoomLevel / 100);
				w.scaleY = (w.total / topContribution) * (zoomLevel / 100);
			}
		}
	}
}