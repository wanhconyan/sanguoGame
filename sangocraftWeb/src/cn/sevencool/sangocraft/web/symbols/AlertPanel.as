package cn.sevencool.sangocraft.web.symbols
{
	import cn.sevencool.sangocraft.data.symbols.SoundManager;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.skin.titleWindow.AlertBtnSkin;
	import cn.sevencool.sangocraft.web.skin.titleWindow.AlertSkin;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.TitleWindow;
	import spark.filters.GlowFilter;
	import spark.layouts.HorizontalAlign;
	
	/**
	 * 提示框 
	 * @author Foster 
	 * 
	 */	
	public class AlertPanel extends TitleWindow implements IUIView{
		/**
		 *文本框 
		 */		
		private static var messageTxt:Label = new Label() ;
		/**
		 *总容器 
		 */		
		private static var elementGroup:Group = new Group();
		/**
		 *按钮容器 
		 */		
		private static var btnGroup:HGroup = new HGroup() ;
		/**
		 *接受按钮 
		 */		
		private static var yesBtn:Button = new Button();
		/**
		 *拒绝按钮 
		 */		
		private var noBtn:Button = new Button();
		/**
		 *确定按钮 
		 */		
		private var okBtn:Button = new Button();
		/**
		 *取消按钮 
		 */		
		private var cancelBtn:Button = new Button();
		
		public function AlertPanel(){
			super();
		}

		public override function initialize():void
		{
			super.initialize() ;
			this.setStyle("skinClass",cn.sevencool.sangocraft.web.skin.titleWindow.AlertSkin);
			this.width = 420 ;
			
			this.addElement(elementGroup) ;
			elementGroup.addElement(messageTxt);
			elementGroup.addElement(btnGroup) ;

			elementGroup.top = 0;
			elementGroup.left = 0;
			elementGroup.right = 0;
			elementGroup.bottom = 0;
			elementGroup.percentWidth = 420;
			elementGroup.percentHeight = 100;
			
			messageTxt.top = 13;
			messageTxt.left = 75;
			messageTxt.right = 75;
			messageTxt.setStyle('color','#d4d4c2');
			messageTxt.filters = [new GlowFilter(0x101010, 100, 2, 2, 5, 1, false, false)];
			
			btnGroup.gap = 100 ;
			btnGroup.bottom = 22+10;
			btnGroup.percentWidth = 100;
			btnGroup.horizontalAlign = HorizontalAlign.CENTER;
			
			yesBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			noBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			okBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			cancelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);

			yesBtn.setStyle("skinClass",cn.sevencool.sangocraft.web.skin.titleWindow.AlertBtnSkin);
			noBtn.setStyle("skinClass",cn.sevencool.sangocraft.web.skin.titleWindow.AlertBtnSkin);
			okBtn.setStyle("skinClass",cn.sevencool.sangocraft.web.skin.titleWindow.AlertBtnSkin);
			cancelBtn.setStyle("skinClass",cn.sevencool.sangocraft.web.skin.titleWindow.AlertBtnSkin);
			
			this.addEventListener(CloseEvent.CLOSE,closeHandler);
		}
		
		
		/**
		 *按钮点击事件 
		 * @param event
		 * 
		 */		
		private function btnClickHandler(event:MouseEvent):void
		{
			var detail:int = -1;
			switch(event.currentTarget)
			{
				case yesBtn:
					detail = Alert.YES;
					break;
				case noBtn:
					detail = Alert.NO;
					break;
				case okBtn:
					detail = Alert.OK;
					break;
				case cancelBtn:
					detail = Alert.CANCEL;
					break;
				
			}
			
			var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE,false,false,detail);
			this.dispatchEvent(closeEvent);
		}
		/**
		 *关闭面板 
		 * @param event
		 * 
		 */		
		private function closeHandler(event:CloseEvent):void
		{
			UIMananger.getInstance().hide(this);
		}
		
		/**
		 * 显示一个提示框
		 * @param text 提示文字
		 * @param title 提示标题
		 * @param flags 显示的按钮 Alert.OK|Alert.NO|Alert.YES|Alert.CANCEL
		 * @param closeHandler 关闭执行的函数
		 * @return 
		 * 
		 */		
		public static function show(text:String = "" , 
									title:String = "" , 
									flags:uint = 0x4 , 
									closeHandler:Function = null):AlertPanel{
			
			_alert = UIMananger.getInstance().show(AlertPanel) as AlertPanel ;
			SoundManager.getInstance().musicPlay("Interface01");
			_alert.message = text;
			_alert.title = title;
			_alert.flags = flags;
			if(_alert.hasEventListener(CloseEvent.CLOSE) && _alert._fun != null )
			{
				_alert.removeEventListener(CloseEvent.CLOSE,_alert._fun);
			}
			if(closeHandler != null)
			{
				_alert.addEventListener(CloseEvent.CLOSE,closeHandler);
			}
			_alert._fun = closeHandler;
			return _alert ;
		}
		
		private static var _alert:AlertPanel =null;
		private var _fun:Function = null ;
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		private var _message:String;
		/**
		 * 提示文本
		 * @return 
		 * 
		 */		
		public function get message():String
		{
			return _message;
		}
		/**
		 * 提示文本
		 * @param value
		 * 
		 */		
		public function set message(value:String):void
		{
			_message = value;
			messageTxt.text = message;
			var leng:int = (value.length%19)==0?0:1;
			var txtH:int = (int(messageTxt.text.length/19) + leng)*20 ;
			this.height = txtH+41+20+21+22+10;
			messageTxt.height= txtH;
			if(int(messageTxt.text.length/19)==0)
			{
				messageTxt.setStyle('textAlign','center');
			}else
			{
				messageTxt.setStyle('textAlign','left');
			}
		}
		
		
		private var _flags:uint;
		/**
		 * 显示按钮 
		 * @return 
		 * 
		 */		
		public function get flags():uint
		{
			return _flags;
		}
		/**
		 * 显示按钮 
		 * @param value
		 * 
		 */		
		public function set flags(value:uint):void
		{
			_flags = value;
			
			btnGroup.removeAllElements();
			
			if(flags == Alert.NONMODAL)
			{
				okBtn.label = Alert.okLabel;
				btnGroup.addElement(okBtn);
			}else
			{
				if(flags & Alert.YES)
				{
					yesBtn.label = Alert.yesLabel;
					btnGroup.addElement(yesBtn);
				}
				
				if(flags & Alert.OK)
				{
					okBtn.label = Alert.okLabel;
					btnGroup.addElement(okBtn);
				}
				
				if(flags & Alert.NO)
				{
					noBtn.label = Alert.noLabel;
					btnGroup.addElement(noBtn);
				}
				
				if(flags & Alert.CANCEL)
				{
					cancelBtn.label = Alert.cancelLabel;
					btnGroup.addElement(cancelBtn);
				}
			}
		}
		
		public function get type():int{
			return UIMananger.TYPE_ALERT ;
		}
		
		public function get usableCount():int{
			return 10 ;
		}
		
		public function get needExclude():Boolean
		{
			return false;
		}
		public function get needTween():Boolean
		{
			return false;
		}
		
	}
}