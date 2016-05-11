package cn.sevencool.sangocraft.web.events
{
	/**
	 * 资源包相关事件
	 * @author dan
	 * 
	 */	
	public class BundlerEvent extends SCEvent
	{
		/**
		 * 资源缺失 
		 */
		public static const MISS:String = 'bundler_miss';

		/**
		 * 没有资源需要加载
		 */
		public static const NOT_REQUIRED_LOAD:String = 'bundler_not_required_load';
		
		/**
		 * 本地资源发生变化 
		 */
		public static const CHANGE:String = 'bundler_change';
		
		public function BundlerEvent(type:String,$miss_bundlers:Array = null)
		{
			super(type)
			this.data = $miss_bundlers;
		}
		
		public function get missing_bundlers():Array
		{
			return this.data as Array;
		}
	}
}