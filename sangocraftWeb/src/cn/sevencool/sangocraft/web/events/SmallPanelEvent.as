package cn.sevencool.sangocraft.web.events
{
	import flash.events.Event;
	
	/**
	 * project: sangocraft_Web
	 * @class: SmallPanelEvent
	 * @author: zhoujingye
	 * @usage: 小面板事件
	 * @since: 2013-10-19
	 * @modified: 2013-10-19
	 * @modifier: zhoujingye 
	 */
	public class SmallPanelEvent extends Event
	{
		
		public static const OPENPANEL:String = 'openPanel' ;
		public static const CLOSEPANEL:String = 'closePanel' ;
		
		public function SmallPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}