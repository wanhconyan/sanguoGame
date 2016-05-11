package com.core.util
{
	

	/**
	 * @project DotaHerosGame
	 * @class OnlyID
	 * @usage 	NPCid
	 * @since 2014-5-28
	 * @modified 2014-6-5
	 * @modifier wangcongyan
	 */
	public class OnlyID
	{
		private static var _onlyID:int = 0;
		public function OnlyID()
		{
		}
		public static function get onlyID():int
		{
			_onlyID ++　 ;
			return  _onlyID ;
		}
	}
}