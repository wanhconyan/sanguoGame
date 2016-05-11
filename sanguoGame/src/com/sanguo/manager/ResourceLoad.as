package com.sanguo.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ResourceLoad extends EventDispatcher
	{
		public function ResourceLoad(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}