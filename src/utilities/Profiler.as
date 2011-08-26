package utilities
{
	import config.Settings;
	
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class Profiler
	{
		public var textField:TextField;
		private var startTime:Number;
		private var framesNumber:Number;
		
		public function Profiler()
		{
			startTime = 0;
			framesNumber = 0;
			textField = new TextField();
			textField.background = true;
			textField.backgroundColor = 0x000000;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat(null, 18, 0xFFFFFF, true);
		}
		
		public function update():void
		{
			var currentTime:Number = (getTimer() - startTime) / 1000;  
			framesNumber++;  
			if (currentTime > 1)  
			{  
				textField.text = "Memory :" + (System.totalMemory / 1024) / 1000;
				textField.appendText("\n" + "Framerate :" + Math.floor((framesNumber/currentTime)*10.0)/10.0);
				startTime = getTimer();  
				framesNumber = 0;  
			}  
		}
	}
}