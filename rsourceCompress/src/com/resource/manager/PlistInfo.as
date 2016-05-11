package com.resource.manager
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class PlistInfo
	{
		
		private var _frame:String ;
		
		private var _offset:String ;
		
		private var _rotated:Boolean ;
		
		private var _sourceColorRect:String ;
		
		private var _sourceSize:String ;
		
		
		public function PlistInfo()
		{
			
		}
		
		
		private var _size:Size ;
		
		public function get rotated():Boolean
		{
			return _rotated;
		}

		public function set rotated(value:Boolean):void
		{
			_rotated = value == "false" ? false : true 
		}

		public function get size():Size
		{
			
			return new Size(frame.split(",")[2]+","+frame.split(",")[3]);
		}

		public function set sourceSize(value:String):void
		{
			_sourceSize = value;
		}


		public function set sourceColorRect(value:String):void
		{
			_sourceColorRect = value;
		}
		
		
		/**
		 * 清楚中括号 
		 * @param $value
		 * @return 
		 * 
		 */		
		private function clearBracket($value:String):String
		{
			return $value.replace(/{/g,"").replace(/}/g,"");
		
		}

	
		public function set offset(value:String):void
		{
			_offset = value;
		}
		
		

		public function get frame():String
		{
			return clearBracket(_frame);
		}

		public function set frame(value:String):void
		{
			_frame = value;
		}
		
		
		
		private var _origin:Point ;
		public function get origin():Point
		{
			if(!_origin)
			{
				_origin = new Point();;
			}
			_origin.x =  position.width ;
			_origin.y =  position.height ;
			return _origin ;
		}
		
		
		private var _offsetSize:Size ;
		public function get ofset():Size
		{
			if(!_offsetSize)
			{
				_offset = _offset.slice(1,_offset.length -1);
				_offsetSize = new Size(_offset);
			}
			return _offsetSize ;
		}
		
		
		public function get rect():Rectangle
		{
			
			return new Rectangle(origin.x,origin.y,size.width,size.height)
		}
		
		
		public function get position():Size
		{
			return new Size(frame.split(",")[0]+","+frame.split(",")[1]);
		}
		
	}
}

internal class Size
{
	private var _size:String ;
	public var width:Number ;
	public var height:Number ;
	
	public function Size(value:String = null)
	{
		if(value == null)
		{
			return ;
		}
		if(value.indexOf(",") == -1)
		{
			value += ",0";
			trace("无效参数")
			throw new Error("invalid params");
		}
		changeSize(value);
	}
	
	public function changeSize(value:String):void
	{
		_size = value ;
		width = parseInt(value.split(",")[0]);
		height = parseInt(value.split(",")[1]);
	}
	
	public function revert():Size
	{
		var size:Size = new Size();
		size.width = height ;
		size.height = width ;
		return size;
	}
}