package  com.core.vo.fraction
{
	import com.core.util.OnlyID;

	public class FractionVO
	{
		private var _fractionName:String = '';
		
		/**
		 *阵型id 
		 */		
		public var fractionID:int = 0  ;
		
		/**
		 * 阵型点 
		 */		
		public var nodes:Vector.<FractionNode> = null;
		public function FractionVO()
		{
		}
		
		
		/**
		 * 阵型名称 
		 */
		public function get fractionName():String
		{
			if(_fractionName == '')
			{
				_fractionName =  OnlyID.onlyID.toString() ;
			}
			return _fractionName;
		}

		/**
		 * @private
		 */
		public function set fractionName(value:String):void
		{
			_fractionName = value;
		}

	}
}