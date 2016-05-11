package cn.sevencool.sangocraft.web.symbols
{
	public class PagingArray extends Array
	{
		/**
		 * 当前页
		 * */
		private var _nowPage:int;
		
		/**
		 * 总页数
		 * */
		private var _totalPage:int;
		
		/**
		 * 每一页数目
		 * */
		private var _pageCount:int;
		
		private var _array:Array = [];
		private var _totalArray:Array = [];
		
		public function PagingArray($arr:Array,$perCount:int)
		{
			_totalArray = $arr;
			pageCount = $perCount;	
			
		}
		
		public function get pageCount():int
		{
			return _pageCount;
		}
		
		public function set pageCount(value:int):void
		{
			_pageCount = value;
			
			totalPage = Math.ceil(_totalArray.length/pageCount);
		}
		
		public function get totalPage():int
		{
			return _totalPage;
		}
		
		public function set totalPage(value:int):void
		{
			_totalPage = value;
		}
		
		
		public function get nowPage():int
		{
			return _nowPage;
		}
		
		public function set nowPage(value:int):void
		{
			if(value<1)
			{
				_nowPage = 1;
			}else if(value>totalPage)
			{
				_nowPage = totalPage;
			}else
			{
				_nowPage = value;
			}
		}
		
		public function source():Array
		{
			
			if(nowPage==totalPage)
			{
				_array = _totalArray.slice(nowPage*pageCount,_totalArray.length);
			}
			_array = _totalArray.slice((nowPage-1)*pageCount,nowPage*pageCount);
			
			return _array;
		}
	}
}