package art
{
	import flash.display.Sprite;
	
	public class StarGraphic extends Sprite
	{
		public function setup(diameter:Number, color:uint = 0xFFFFFF):void
		{
			var radius:Number = diameter * .5;
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawCircle(radius, radius, radius);
			graphics.endFill();
		}
	}
}