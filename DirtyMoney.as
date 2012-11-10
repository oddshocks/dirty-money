﻿package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.errors.IOError;
	
	
	public class DirtyMoney extends MovieClip {
		
		public const API_KEY:String = "ac40037846c017c68fc9f5b804bd015d";
		public const API_BASE_URL:String
			= "http://www.opensecrets.org/api/?method=candIndustry&cid=";
		public const DATE:Date = new Date();
		
		public var csvRequest:URLRequest;
		public var csvLoader:URLLoader;
		public var csvData:Array;
		public var xmlRequest:URLRequest;
		public var xmlLoader:URLLoader;
		public var xmlData:XML;
		public var dataInfo:XMLList;
		public var industries:XMLList;
		
		public var candidateName:String;
		
		public function DirtyMoney() {
			stop();
			// Set up preloader
			preloader.stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, doLoadingProgress);
			
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
				
				// Do a default candidate search, to show an example
				candidateSearch("N00007360");
			}
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
			xmlRequest = new URLRequest(API_BASE_URL
											+ cid + "&cycle="
											+ DATE.fullYear + "&apikey="
											+ API_KEY);
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
			
			// get metadata
			dataInfo = xmlData.elements("industries");
			// get data 
			industries = xmlData.elements("industry");
			
			// display the info
			displayCandidateInfo();
		}
		
		public function displayCandidateInfo():void {
			textName.text = dataInfo.@cand_name;
		}
	}
}