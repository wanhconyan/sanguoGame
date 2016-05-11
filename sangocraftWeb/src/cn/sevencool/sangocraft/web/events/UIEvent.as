package cn.sevencool.sangocraft.web.events{
	import flash.events.Event;
	
	/**
	 * project: sangocraft_Web
	 * @class: UIEvent
	 * @author: zhouyan
	 * @usage: UI事件
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class UIEvent extends Event{
		
		public static const BASE_UI_REMOVE:String = 'base_ui_remove' ;
		public static const BASE_UI_ADD:String = 'base_ui_add' ;
		
		/**
		 * 重新设置面板的位置 
		 */		
		public static const BASE_UI_REPOSITION:String = 'base_ui_rePosition' ;
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}