package cn.sevencool.sangocraft.web.manager
{
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.web.skin.dropDownListSkin.PreBattleDropDownListSkin;
	import cn.sevencool.sangocraft.web.symbols.NetTracePanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.BattleInfo;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.engine.TextLine;
	
	import mx.controls.TextInput;
	
	import spark.components.Button;
	import spark.components.RichEditableText;
	import spark.components.VScrollBar;
	
	/**
	 * project: sangocraft_Web
	 * @class: KeyboardManager
	 * @author: zhouyan
	 * @usage: 键盘初始化
	 * @since: 2013-9-2
	 * @modified: 2013-9-2
	 * @modifier: zhouyan 
	 */
	public class KeyboardManager
	{
		public var canUseKeyBoard:Boolean = true;
		
		public function KeyboardManager()
		{
			if ( instance != null)
			{				
				throw new Error( "Singleton Class" );
			}
			CommonData.stage.addEventListener(MouseEvent.CLICK , mouseClickHandler) ;
		}
		/** 定义单例模式的getInstance方法 */
		public static function getInstance():KeyboardManager
		{
			if ( instance == null )
			{
				instance = new KeyboardManager();
			}
			return instance;
		}
		
		/**
		 * 单例模式
		 */		
		private static var instance:KeyboardManager = null ;
		
		/**
		 * 标识文本框是否需要抢夺焦点
		 * -- 从好友面板点击后焦点到聊天框
		 * -- @wangfuyuan 2013-10-17
		 */
		public static var isToText:Boolean;
		
		private function mouseClickHandler(evt:MouseEvent):void
		{
			if(evt.target is RichEditableText || evt.target is TextInput || evt.target is TextLine 
				|| evt.target is TextField || evt.target is VScrollBar
			    || (evt.target is Button && evt.target.document is PreBattleDropDownListSkin))
			{
				return ;
			}
			if(!isToText){
				CommonData.stage.focus = CommonData.stage ;
			}else{
				isToText = false;
			}
		}
		
		public function addListener(displayObject:DisplayObject):void
		{
			if(displayObject && !displayObject.hasEventListener(KeyboardEvent.KEY_UP))
			{
				displayObject.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
//			if(!canUseKeyBoard)
//			{
//				return;
//			}
			if(event.ctrlKey && event.shiftKey && event.keyCode == 86)//V
			{
				UIMananger.getInstance().show(BattleInfo);
			}
			if(event.ctrlKey && event.shiftKey && event.keyCode == 88)
			{
				UIMananger.getInstance().show(NetTracePanel);
			}
		}
	}	
}