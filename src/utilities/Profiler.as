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
		private var time:Number;
		private var frames:Number;
		
		public function Profiler()
		{
			time = 0;
			frames = 0;
			textField = new TextField();
			textField.background = true;
			textField.backgroundColor = 0x000000;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat(null, 16, 0xFFFFFF, true);
		}
		
		public function update():void
		{
			var currentTime:Number = (getTimer() - time) / 1000;  
			frames++;  
			if (currentTime > 1) //lets do this only once a second
			{  
				textField.text = "Stars :" + Settings.MAX_STARS;
				textField.appendText("\n" + "Memory :" + (System.totalMemory / 1024) / 1000);
				textField.appendText("\n" + "Framerate :" + Math.floor((frames / currentTime) * 10) / 10);
				time = getTimer();  
				frames = 0;  
			}  
		}
	}
}