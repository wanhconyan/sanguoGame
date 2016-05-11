package com.sevenCool.uiControl
{
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class UIManager
	{
		private var _content:Group = null;
		
		private static var _instance:UIManager = null;
		
		private var _viewDic:Dictionary = null;
		
		public function UIManager($access:Private)
		{
			if(!$access)
			{
				throw new Error("error create");
			}
			_viewDic = new Dictionary();			
		}
		
		
		/**
		 * 当前显示层 
		 */
		public function get content():Group
		{
			return _content;
		}

		/**
		 * @private
		 */
		public function set content(value:Group):void
		{
			_content = value;
		}

		public static function get instance():UIManager
		{
			if(!_instance)
			{
				_instance = new UIManager(new Private);
			}
			return _instance ;
		}
		
		
		/**
		 * 显示面板 
		 * @param $ui
		 */		
		public function show($ui:UIComponent):void
		{
			if(!_content.containsElement($ui))
			{
				_content.addElement($ui);
				$ui.x = _content.width - $ui.width >> 1 ;
				$ui.y = _content.height - $ui.height >> 1 ;
			}
		}
		
		/**
		 * 影藏面板 
		 * @param $ui
		 * 
		 */		
		public function hide($ui:UIComponent):void
		{
			if(_content.containsElement($ui))
			{
				_content.removeElement($ui);
			}
		}
		
		
		/**
		 * 移除所有的面板 
		 */		
		public function hideAll():void
		{
			_content.removeAllElements() ;
		}
	}
}

class Private{}