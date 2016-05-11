package cn.sevencool.sangocraft.web.manager
{
	import avmplus.getQualifiedClassName;
	
	import cn.sevencool.sangocraft.data.events.HttpLocatorEvent;
	import cn.sevencool.sangocraft.data.symbols.HttpLocator;
	import cn.sevencool.sangocraft.data.symbols.MessageUtil;
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.web.symbols.AlertPanel;
	import cn.sevencool.sangocraft.web.symbols.NetTracePanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.LoadingPanel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import org.oswxf.rpc.interfaces.ISend;
	import org.oswxf.rpc.interfaces.IVO;
	
	/**
	 * project: sangocraft_Web
	 * @class: LoadingManager
	 * @author: zhouyan
	 * @usage: 账号登陆管理器 
	 * @since: 2013-9-2
	 * @modified: 2013-9-2
	 * @modifier: zhouyan 
	 */
	public class LoadingManager extends EventDispatcher
	{
		
		private var _http:HttpLocator = null;
		
		/**
		 *播放等待swf 
		 */		
		private var _loading:LoadingPanel = null;
		
		public function LoadingManager()
		{
			if ( _instance != null)
			{				
				throw new Error( "Singleton Class" );
			}
			_http = HttpLocator.getInstance() ;
			_timer = new Timer(5000,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
			initialized();
		}
		
		/**
		 * 单例模式
		 */		
		private static var _instance:LoadingManager = null;	
		public static function getInstance():LoadingManager
		{
			if ( _instance == null )
			{
				_instance = new LoadingManager();
			}
			return _instance;
		}
		
		private function initialized():void
		{
			SystemModelLocator.getInstance().addEventListener(HttpLocatorEvent.RECBYTEARRAY,RecbytearrayHandler);
			SystemModelLocator.getInstance().addEventListener(HttpLocatorEvent.IOERROR,IOHandler);
			SystemModelLocator.getInstance().addEventListener(HttpLocatorEvent.RECEIVEHANDLER,GameReceiveHandler);
			SystemModelLocator.getInstance().addEventListener(HttpLocatorEvent.RECEIVEHANDLER_CHAT,ChatReceiveHandler);
			SystemModelLocator.getInstance().addEventListener(HttpLocatorEvent.SENDHANDLER,SendHandler);
		}
		/**
		 * 发送数据成功 
		 * @param $evt
		 * 
		 */		
		private function SendHandler($evt:HttpLocatorEvent):void
		{
			var parameters:Array = $evt.parameters;
			NetTracePanel.addSendConnected(parameters[0]);
			_send = parameters[0] ;
			_timer.reset();
			_timer.start();
			if(_send.command.toString(16)=='239')
			{
				return ;
			}
			if(!_loading)
			{
				_loading = UIMananger.getInstance().show(LoadingPanel) as LoadingPanel;
			}
		}
		
		private var _send:ISend = null;
		private var _timer:Timer = null;
		
		protected function completeHandler($evt:Event):void
		{
			if(_send)
			{
				AlertPanel.show(_send.command.toString(16)+'没有返回');
			}
		}
		
		
		private function GameReceiveHandler($evt:HttpLocatorEvent):void
		{
			ReceiveHandler($evt);
		}
		private function ChatReceiveHandler($evt:HttpLocatorEvent):void
		{
			ReceiveHandler($evt,'Chat');
		}
		
		/**
		 * 接受后端发来的数据 
		 * @param $evt
		 * 
		 */		
		private function ReceiveHandler($evt:HttpLocatorEvent,$severType:String=''):void
		{
			var parameters:Array = $evt.parameters;
			var byarray:ByteArray = parameters[0] as ByteArray ;
			var incmd:int = parameters[1]  ;
			var target:IVO = parameters[3]  ;
			NetTracePanel.addReceiveConnected(incmd , byarray , target , $severType);
			
			var propertyErrors:Array = ['nErrorCode' , 'nErrorCode_tip'] ;
			var property:String = '' ;
			
			for(var i:int = 0 ; i < propertyErrors.length ; i++){
				var properyname:String = propertyErrors[i] ;
				if(Object(target).hasOwnProperty(properyname)){
					property = properyname ;
					break ;
				}
			}
			
			if(property){
				var code:int = parseInt(target[property]) ;
				var error:String = getErrorString(target , code) ;
				switch(property){
					case 'nErrorCode' :
						if(code != 0 && error){
							AlertPanel.show(error) ;
						}
						break ;
					case 'nErrorCode_tip' :
						MessageUtil.sendMessageCentral(error) ;
						break ;
				}
			}
			
		}
		
		/**
		 * 错误编号
		 * @param target
		 * @param eid
		 * @return 
		 * 
		 */		
		private function getErrorString($target:IVO , $eid:int):String
		{
			var classname:String = getQualifiedClassName($target).replace('::' , '.') ;
			var xmllist:XMLList = MaterialManager.errorCodeConfig.children().(attribute('name') == classname) ;
			var errorlist:XMLList = xmllist.children().(attribute('code') == $eid.toString()) ;
			
			var error:String = '' ;
			if(errorlist && errorlist.length()){
				error = errorlist.attribute('description').toString() ;
			}
			return error ;
		}
		
		
		/**
		 * 连接断开  通信中断
		 * @param e
		 */		
		private function IOHandler(e:HttpLocatorEvent):void
		{
			AlertPanel.show('您与服务器断开连接' , '' , Alert.OK) ;
		}
		
		/**
		 * 接收到后端数据 
		 * @param e
		 */		
		private function RecbytearrayHandler(e:HttpLocatorEvent):void
		{
			if(_timer.running)
			{
				_timer.stop();
			}
			if(_loading && _loading.stage)
			{
				UIMananger.getInstance().hide(_loading);
				_loading = null;
			}
		}
		
	}
}