package cn.sevencool.sangocraft.web.symbols.itemsBox
{
	import flash.display.Graphics;

	public class GraphicsDraw
	{
		
		private static const curveDistrance:Number = 0.2;
		
		public function GraphicsDraw()
		{
		}
		
		/**
		 * 
		 * @param graphics Graphics对象
		 * @param x 圆心坐标x
		 * @param y 圆心坐标y
		 * @param startDeg 开始弧度
		 * @param endDeg 结束弧度
		 * @param radius 半径
		 * 
		 */		
		public static function drawRadian(graphics:Graphics,x:Number,y:Number,startDeg:Number,endDeg:Number,radius:Number):void
		{
			var curveNum:int = Math.ceil((endDeg - startDeg) / curveDistrance);
			var realCurveDistrance:Number = (endDeg - startDeg) / curveNum;
			
			for(var i:int=0;i<curveNum;i++)
			{
				var contrlX:Number = x + Math.cos(startDeg + (i + 0.5) * realCurveDistrance ) * radius * 1.005;
				var contrlY:Number = y + Math.sin(startDeg + (i + 0.5) * realCurveDistrance ) * radius * 1.005;
				
				var endX:Number = x + Math.cos(startDeg + (i + 1) * realCurveDistrance ) * radius;
				var endY:Number = y + Math.sin(startDeg + (i + 1) * realCurveDistrance ) * radius;
				
				graphics.curveTo(contrlX,contrlY,endX,endY);
			}
			
		}
	}
}