package com.control.view
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 辅助线是一条长度 或宽度为像素1的一条直线一般一个容器都有两条辅助线
	 * 当两个容器的辅助线中心点或者某个中心点距离相差很近时则将容器的中心点重合 
	 * @author Administrator
	 */	
	public class AuxiliaryLine extends Sprite
	{
		private var _w:int = 1 ;
		
		private var _h:int = 1 ;
		
		public function AuxiliaryLine()
		{
			super();
		}

		override public function set width(value:Number):void
		{
			_w = value ;
			draw();
		}
		
		override public function set height(value:Number):void
		{
			_h = value ;
			draw();
		}

		/**
		 * 获取宽度 
		 * @return 
		 * 
		 */		
		override public function get width():Number
		{
			return _w ;
		}
		
		/**
		 * 获取当前长度 
		 * @return 
		 * 
		 */		
		override public function get height():Number
		{
			return _h;
		}
		
		/**
		 * 划线 
		 */		
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff*Math.random());
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill() ;
		}
		
		/**
		 * 获取当前点的实际位置 
		 * @return 
		 */
		public function getRealPoint():Point
		{
			return this.localToGlobal(new Point(x + int(width/2),y + int(height/2)));
		}
	}
}