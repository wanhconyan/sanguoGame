package com.core.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class CImage extends Sprite
	{
		private var bitmap:Bitmap ;
		
		private var _width:int = -1;
		
		private var _height:int = -1;
		
		private var min_size:int = 5 ;
		public function CImage()
		{
			this.mouseEnabled = false;
			bitmap = new Bitmap();
			this.addChild(bitmap);
		}
		
		
		override public function get width():Number
		{
			if(_width == -1)
			{
				return min_size ;
			}
			return _width ;
		}
		
		override public function get height():Number
		{
			if(_height == -1)
			{
				return min_size ;
			}
			return _height ;
		}
		
		
		override public function set width(value:Number):void
		{
			_width = value ;
			super.width = value ;
		}
		
		
		public function set data($data:*):void
		{
			if($data is BitmapData)
			{
				bitmap = new Bitmap($data);
			}
		}
	}
}