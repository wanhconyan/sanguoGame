package cn.sevencool.sangocraft.web.symbols
{
	import cn.sevencool.sangocraft.data.manager.abstract.AbstractMediator;
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.web.events.UIEvent;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import org.oswxf.rpc.event.ModelEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;

	/**
	 * project: sangocraft_Web
	 * @class: BasePanel
	 * @author: zhouyan
	 * @usage: 面板基类
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class BasePanel extends Group implements IUIView
	{
		/** 是否需要触发显示行为 */	
		internal var isShowDo:Boolean = true;

		public function BasePanel()
		{
			super();
			this.focusEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			
			if(type == UIMananger.TYPE_PANEL && dragEnable){
				addEventListener(MouseEvent.MOUSE_DOWN , mouseDownHandler) ;
				addEventListener(MouseEvent.MOUSE_UP   , mouseUpHandler) ;
				addEventListener(MouseEvent.CLICK , clickHandler) ;
			}
			
		}

		
		private var _panelID:int = -1 ;
		

		public function get panelID():int
		{
			return _panelID;
		}

		public function set panelID(value:int):void
		{
			_panelID = value;
		}

		public function get mediatorUI():AbstractMediator
		{
			return _mediatorUI;
		}

		public function get dragEnable():Boolean{
			return false ;
		}
		
		public function get needBundleList():Array
		{
			return [];	
		}
		
		
		
		
		
		protected function mouseDownHandler(evt:MouseEvent):void{
			if(mouseY <= 30 && !(evt.target is SkinnableComponent)){
				var rect:Rectangle = systemManager.screen.clone() ;
				rect.width = rect.width - width ;
				rect.height = rect.height - height ;
				startDrag(false , rect) ;
			}
			
		}
		
		private function clickHandler(evt:MouseEvent):void{
			var myparent:Group = this.parent as Group ;
			if(myparent && mouseY <= 30){
				isShowDo = false;
				setChildrenIsShowDo(this,isShowDo);
				myparent.addElement(this);
				isShowDo = true;
				setChildrenIsShowDo(this,isShowDo);
			}
		}
		internal static function setChildrenIsShowDo(container:DisplayObjectContainer,isDo:Boolean):void
		{
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);        
				if (child is BasePanel)
				{
					(child as BasePanel).isShowDo = isDo;
				}
				if(child is DisplayObjectContainer)
				{
					BasePanel.setChildrenIsShowDo((child as DisplayObjectContainer),isDo);
				}
			}
		}
		
		protected function mouseUpHandler(evt:MouseEvent):void{
			stopDrag() ;	
		}
		
		private function stage_mouseLeaveHandler(evt:Event):void{
			stopDrag() ;
		}
		
		private var _dataArray:Vector.<Class> = new Vector.<Class> ;
		
		
		public function get dataArray():Vector.<Class>
		{
			return _dataArray;
		}
		/**
		 * 面板关心的数据类型 传入VO类Class的数组 
		 * @param v
		 * 
		 */		
		public function set dataArray(v:Vector.<Class>):void
		{
			_dataArray = v;
		}
		
		private var onShowing:Boolean = false;
		
		private function addToStageHandler(event:Event):void
		{
			if(isShowDo)
			{
				onShowing = true;
				
				setTimeout(closeOnShowing,2000);
				
				systemManager.stage.addEventListener(   
					Event.MOUSE_LEAVE, stage_mouseLeaveHandler) ;
				addDataEvent();
				onShow();
				
				dispatchEvent(new UIEvent(UIEvent.BASE_UI_ADD)) ;
			}
		}
		
		private function closeOnShowing():void
		{
			onShowing = false;
		}
		
		private function removeFromStageHandler(event:Event):void
		{
			if(isShowDo)
			{
				systemManager.stage.removeEventListener(   
					Event.MOUSE_LEAVE, stage_mouseLeaveHandler) ;
				addDataEvent(false);
				onClose();
				
				dispatchEvent(new UIEvent(UIEvent.BASE_UI_REMOVE)) ;
			}
		}
		
		/**
		 *增加或删除VO变化事件 
		 * @param isAdd
		 * 
		 */		
		private function addDataEvent(isAdd:Boolean=true):void
		{
			if(!_dataArray)
			{
				return;
			}
			for(var i:int=0;i<_dataArray.length;i++)
			{
				var dataClass:Class = dataArray[i];
				var event:String = SystemModelLocator.getInstance().getDataChangeEventNameByVoClass(dataClass);
				if(isAdd)
				{
					SystemModelLocator.getInstance().addEventListener(event,dataChangeHandler);
				}else
				{
					SystemModelLocator.getInstance().removeEventListener(event,dataChangeHandler);
				}
			}
		}
		
		
		private function dataChangeHandler(event:ModelEvent):void
		{
			onDataChange(event.type);
		}
		
		/**
		 *面板打开时调用  需要override 
		 * 
		 */		
		protected function onShow():void
		{
			
		}
		
		/**
		 * 面板关闭时调用 需要override 
		 * 
		 */		
		protected function onClose():void
		{
			
		}
		
		/**
		 * VO变化时调用 需要override 
		 * @param type
		 * 
		 */		
		protected function onDataChange( type:String = "" ):void
		{
			
		}
			
		
		public function get type():int
		{
			return UIMananger.TYPE_PANEL;
		}
		
		public function get usableCount():int
		{
			return 1;
		}
		
		public function get needExclude():Boolean
		{
			return false;
		}
		
		public function get needTween():Boolean
		{
			return true;
		}
		
		private var _mediatorUI:AbstractMediator = null;
		/**
		 * 需要塞一个mediator,否则面板拿不到mediator
		 * @param $value
		 * 
		 */		
		public function set mediatorUI($value:AbstractMediator):void
		{
			_mediatorUI = $value ;
			throw new Error("Need to plug a mediator！");
		}
	}
}