package cn.sevencool.sangocraft.web.manager
{
	import cn.sevencool.sangocraft.data.symbols.SoundManager;
	import cn.sevencool.sangocraft.web.events.UIEvent;
	import cn.sevencool.sangocraft.web.operators.TweenOperator;
	import cn.sevencool.sangocraft.web.symbols.BasePanel;
	import cn.sevencool.sangocraft.web.symbols.IUIView;
	
	import com.greensock.plugins.ScalePlugin;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColor;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.effects.Fade;
	import spark.effects.Scale;
	
	/**
	 * project: sangocraft_Web
	 * @class: UIManager
	 * @author: zhouyan
	 * 
	 * @usage: UI管理器
	 * ui显示管理器
	 * 管理的内容包括 Alert/Panel/Frame
	 * 显示层级从上到下为
	 * Alert (可以同时多个)
	 * modal(如果显示alert，就显示modal)
	 * panel(可以显示panel)
	 * frame (必须有且只有一个)
	 * 
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class UIMananger
	{
		public static const TYPE_ALERT:int = 0;
		public static const TYPE_PANEL:int = 1;
		public static const TYPE_FRAME:int = 2;
		public static const TYPE_CHAT:int = 3;
		public static const TYPE_WIZARD:int = 4;
		
		public function UIMananger()
		{
			if(instance!= null){
				throw new Error('signton class') ;
			}
			this.init();
		}
		
		/**
		 *  单例模式
		 *  */
		private static var instance:UIMananger;
		public static function getInstance():UIMananger
		{
			if(instance == null)
			{
				instance = new UIMananger() ;
			}
			return instance ;
		}
		
		/**
		 * frame 容器 
		 *  
		 */		
		private var _frameContainer:Group= null;
		
		/**
		 * alert 容器 
		 */
		private var _alertContainer:BorderContainer  = null;
		
		/**
		 * panel 容器 
		 */
		private var _panelContainer:Group = null;
		
		/**
		 * 指引容器
		 */		
		private var _wizardContainer:Group=null;
		
		/**
		 * 聊天容器
		 */		
		private var _chatContainer:Group=null;
		
		/**
		 *面板dic 
		 */		
		private var _uiDic:Dictionary = new Dictionary();	
		
		private var _container:Group = null;
		
		private var _tweenOperate:TweenOperator = null;
		
		public function get container():Group
		{
			return _container;
		}
		
		public function set container($container:Group):void
		{
			_container = $container;
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function init():void
		{
			_frameContainer = new Group();
			_alertContainer = new BorderContainer();
			_panelContainer = new Group();
			_wizardContainer=new Group();
			_chatContainer=new Group();
			_panelContainer.mouseEnabled=false;
			_wizardContainer.mouseEnabled=false;
			_chatContainer.mouseEnabled=false;
			if(_container ==null)
			{
				_container = new Group();
			}
			
			_container.addElement(_frameContainer);
			_container.addElement(_panelContainer);
			_container.addElement(_alertContainer);
			_container.addElement(_chatContainer);
			_container.addElement(_wizardContainer);
			reSize();
			var alertModalFill:SolidColor = new SolidColor(0x000000,0.3);
			_alertContainer.backgroundFill = alertModalFill;
			_alertContainer.visible = false;
			_tweenOperate = TweenOperator.getInstance() as TweenOperator; 
			
		}
		
		public function reSize():void
		{
			_frameContainer.width = _container.width;
			_frameContainer.height = _container.height;
			
			_panelContainer.width = _container.width;
			_panelContainer.height = _container.height;
			
			_alertContainer.width = _container.width;
			_alertContainer.height = _container.height;
			
			_wizardContainer.width=_container.width;
			_wizardContainer.height = _container.height;
			
			_chatContainer.width=_container.width;
			_chatContainer.height = _container.height;
			
			pannelUpdataDisplay() ;
		}
		
		private function pannelUpdataDisplay():void{
			var len:uint = _panelContainer.numElements ;
			for(var i:int = 0 ; i < len ; i++){
				var ui:IUIView = _panelContainer.getElementAt(i) as IUIView ;
				if(ui.type == TYPE_PANEL)
				{
					pannelResize(ui as DisplayObject) ;
				}
				
			}
		}
		
		private function pannelResize(target:DisplayObject):void{
			var centerX:Number = container.width / 2 ;
			var centerY:Number = container.height / 2 ;
			
			var tx:int = centerX - target.width / 2 ;
			var ty:int = centerY - target.height / 2 ;
			
			if(tx < 0){
				tx = 0 ;
			}
			
			if(ty < 0){
				ty = 0;
			}
			
			var index:int = getUIIndex(target as IUIView) ;
			if(index >  0){
				tx += index * 30 ;
				ty += index * 30 ;
			}
			
			target.x = tx ;
			target.y = ty ;
			
			target.dispatchEvent(new UIEvent(UIEvent.BASE_UI_REPOSITION));
		}
		
		/**
		 * 隐藏某个显示IUIVIew 实例
		 * @param $uiInstance
		 * 
		 */
		public function hide($uiInstance:IUIView):void
		{
			var type:int = $uiInstance.type;
			var obj:IVisualElement = $uiInstance as IVisualElement;
			if(!obj)
				return;
			
			switch(type)
			{
				case TYPE_ALERT:
					_alertContainer.removeElement(obj);
					if(_alertContainer.numElements==0)
						_alertContainer.visible  = false;
					break;
				case TYPE_PANEL:
					if($uiInstance.needTween)
					{
						_tweenOperate.hidePanel(_panelContainer,obj);
					}else
					{
						removeObj(obj);
					}
					break;
				case TYPE_FRAME:
					_frameContainer.removeElement(obj);
					break;
				case TYPE_CHAT:
					_chatContainer.removeElement(obj);
					break;
				case TYPE_WIZARD:
					_wizardContainer.visible = false;
					break;
			}
		}
		
		/**
		 * 设置关闭面板
		 * */
		public function removeObj($obj:IVisualElement):void
		{
			if(_panelContainer.containsElement($obj))
			{
				_panelContainer.removeElement($obj);
			}
			
			_wizardContainer.visible = false;
		}
		
		/**
		 * 根据传入的类型 显示一个IUIView对象。
		 * 传入对象需要是IUIView对象的实现 
		 * @param $classType
		 * @return 
		 * 
		 */
		public function show($classType:Class):IUIView
		{
			var obj:IVisualElement = getUIObj($classType) as IVisualElement;
			
			if(!BundleResManager.getInstance().isBundleReady($classType))
			{
				return null;	
			}
			if(!UIComponent(obj).updateCompletePendingFlag){
				obj.addEventListener(FlexEvent.UPDATE_COMPLETE , rePositionHandler) ;
			}
			obj.addEventListener(FlexEvent.ADD , rePositionHandler) ;
			var type:int = IUIView(obj).type;
			
			switch(type){
				case TYPE_ALERT:
					_alertContainer.addElement(obj);
					_alertContainer.visible = true;
					break;
				case TYPE_PANEL:
					if(IUIView(obj).needExclude)
					{
						for(var i:int = 0 ; i < _panelContainer.numElements;i++)
						{
							var tg:IUIView =  _panelContainer.getElementAt(i) as IUIView;
							if(tg.needExclude)
							{
								this.hide(tg);
							}
						}
					}
					_panelContainer.addElement(obj);
					if(IUIView(obj).needTween)
					{
						_tweenOperate.showPanel(_panelContainer);
						
					}else
					{
						_panelContainer.x = _panelContainer.y = 0
						_panelContainer.scaleX  = _panelContainer.scaleY = 1; 
					}
					break;
				case TYPE_FRAME:
					_frameContainer.addElement(obj);
					while(_frameContainer.numChildren>1)
						hide(_frameContainer.getElementAt(0) as IUIView);
					break;
				case TYPE_WIZARD:
					_wizardContainer.addElement(obj);
					_wizardContainer.visible = true ;
					break;
				case TYPE_CHAT:
					_chatContainer.addElement(obj);
					break;
			}
			return obj as IUIView;
		}
		
		
		private function creatHandler($e:FlexEvent):void
		{
			var target:IVisualElement = $e.currentTarget as IVisualElement ;
			target.removeEventListener(FlexEvent.CREATION_COMPLETE,creatHandler);
			
			show(flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName($e.currentTarget)) as Class);
		}
		
		private function rePositionHandler(evt:FlexEvent):void{
			var target:IVisualElement = evt.currentTarget as IVisualElement ;
			if(evt.type == FlexEvent.UPDATE_COMPLETE){
				target.removeEventListener(FlexEvent.UPDATE_COMPLETE , rePositionHandler) ;
			}
			
			target.removeEventListener(FlexEvent.ADD , rePositionHandler);
			
			var type:int = IUIView(target).type;
			switch(type)
			{
				case TYPE_PANEL:
					if(target.parent == _panelContainer && 
						_panelContainer.numElements>1 
						&& _panelContainer.getChildIndex(target as DisplayObject) != _panelContainer.numElements-1)
					{
						_panelContainer.setElementIndex(target,_panelContainer.numElements-1);
					}
					break;
			}
			
			pannelResize(target as DisplayObject) ;
		}
		
		
		/**
		 * 根据 传入的类 类型 返回已经存在的类或者 新对象
		 * @param $classType
		 * @return 
		 * 
		 */
		public function getUIObj($classType:Class):IUIView
		{
			var  reUI:IUIView;
			
			if(!_uiDic[$classType])
			{
				_uiDic[$classType] = new Array();
			}
			
			var uiAry:Array = _uiDic[$classType] as Array;
			
			var uiNum:int = 0;
			
			for(var i:int=0;i<uiAry.length;i++)
			{
				var ui:IUIView = uiAry[i] as IUIView;
				if((ui as DisplayObject).stage)
				{
					uiNum ++;
				}else{
					return ui ;
				}
				
				if(uiNum == ui.usableCount)
				{
					reUI = ui;
					break;
				}
			}
			
			if(!reUI)
			{
				reUI = new $classType();
				uiAry.push(reUI);
			}
			
			return reUI as IUIView;
		}
		
		public function getUIIndex(ui:IUIView):int{
			var index:int = -1 ;
			
			var classname:String = getQualifiedClassName(ui) ;
			var typeclass:Class = getDefinitionByName(classname) as Class ;
			
			var stack:Array = _uiDic[typeclass] ;
			if(stack == null){
				return index ;
			}
			
			index = stack.indexOf(ui) ;
			
			return index ;
			
		}
		
		public function hideAll(elsePanel:Class = null):void
		{
			var num:int = _panelContainer.numElements;
			
			var removeIndex:int = 0;
			
			for(var i:int=0;i<num;i++)
			{
				var ui:IUIView = _panelContainer.getElementAt(removeIndex) as IUIView;
				var classname:String = getQualifiedClassName(ui) ;
				var elseClassName:String = getQualifiedClassName(elsePanel);
				
				if(elsePanel && classname == elseClassName)
				{
					removeIndex = 1
				}
				else
				{
					_panelContainer.removeElementAt(removeIndex);
				}
			}
			_wizardContainer.visible = false;
		}
		
		public function changePanel($classTypeClose:*):void
		{
			var objClose:IUIView = getUIObj($classTypeClose) as IUIView;
			if(objClose)
			{
				hide(objClose);
			}
		}
		
		/**
		 * 打开/关闭面板
		 * @param $classType
		 * @return 
		 * 
		 */		
		public function showOrHide($classType:Class):IUIView
		{
			var iUIView:IUIView = null ;
			var obj:IVisualElement = getUIObj($classType) as IVisualElement;
			var type:int = IUIView(obj).type;
			if(type == TYPE_PANEL)
			{
				var isshow:Boolean = true ;
				var plen:uint = _panelContainer.numElements ;
				for(var pi:int = 0 ; pi < plen ; pi++ ){
					var ui:IUIView = _panelContainer.getElementAt(pi) as IUIView ;
					var classname:String = getQualifiedClassName(ui) ;
					var typeclass:Class = getDefinitionByName(classname) as Class ;
					if(typeclass == $classType)
					{
						hide(ui) ;
						isshow = false;
					}
				}
				if(isshow)
				{
					hideAll();
					iUIView = show($classType);
				}
			}
			return iUIView;
		}
	}
}
