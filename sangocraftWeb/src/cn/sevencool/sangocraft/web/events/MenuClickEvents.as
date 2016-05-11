package cn.sevencool.sangocraft.web.events
{
	/**
	 * project: sangocraft_Web
	 * @class: MenuClickEvents
	 * @author: wangtaofeng
	 * @usage: 点击菜单事件
	 * @since: 2013-9-25
	 * @modified: 2013-10-8
	 * @modifier: wangtaofeng
	 */

	import cn.sevencool.sangocraft.data.model.ReinforcementsVO;
	import cn.sevencool.sangocraft.data.vo.FriendDisplayVO;
	
	import flash.events.Event;
	
	public class MenuClickEvents extends Event
	{
		
		/**
		 * 援军 菜单事件 
		 */		
		public static const MENUCLICK_REINFORCE:String = 'menuClick_Reinforce';
		
		/**
		 * 我的好友 菜单事件 
		 */		
		public static const MYFRIEND:String = 'myfriend';
		
		/**
		 * 好友申请 菜单事件 
		 */		
		public static const FRIENDAPPLY:String = 'friendApply';
		
		/**
		 * 援军VO
		 * */
		private var _param:ReinforcementsVO = null ;
		
		/**
		 * 好友
		 * */
		private var _friendVO:FriendDisplayVO = null; 
		
		/**
		 * 坐标X
		 * */
		private var _menuX:int = -1 ;
		
		/**
		 * 坐标Y
		 * */
		private var _menuY:int = -1 ;
		
		
		public function MenuClickEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * 被点击的援军数据 
		 */
		public function get param():ReinforcementsVO
		{
			return _param;
		}
		
		/**
		 * @private
		 */
		public function set param(value:ReinforcementsVO):void
		{
			_param = value;
		}
		
		
		/**
		 * 被点击的好友数据 
		 */
		public function get friendVO():FriendDisplayVO
		{
			return _friendVO;
		}
		
		public function set friendVO(value:FriendDisplayVO):void
		{
			_friendVO = value;
		}

		
		/**
		 *坐标X 
		 */
		public function get menuX():int
		{
			return _menuX;
		}
		
		/**
		 * @private
		 */
		public function set menuX(value:int):void
		{
			_menuX = value;
		}
		
		
		/**
		 *坐标Y
		 */
		public function get menuY():int
		{
			return _menuY;
		}

		/**
		 * @private
		 */
		public function set menuY(value:int):void
		{
			_menuY = value;
		}
	}
}