package cn.sevencool.sangocraft.web.symbols.itemsBox
{
	
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class OperationCD{
		
		private var _cdTimer:Timer = new Timer(100) ;
		private var _commandTimer:Timer = new Timer(100) ;
		
		public function OperationCD(){
		}
		


		/**cd计时器*/
		public function get cdTimer():Timer{
			return _cdTimer ;
		}
		
		/**公共cd计时器*/
		public function get commmandTimer():Timer{
			return _commandTimer ;
		}
		
		/**使用的操作类型 0：魔法 1：物品*/
		public var type:int = -1 ;
		
		/**当前使用使用对象唯一id*/
		public var unique:int = 0 ;
		
		/**判断依据的尾巴,附加内容*/
		public var stinger:String = '' ;
		
		public function get key():String{
			return type + '|' + unique + '|' + stinger ;
		}
		
		private var _cdtime:Number = 0 ;
		/**技能cd时间*/
		public function get cdtime():Number{
			return _cdtime ;
		}
		public function set cdtime(value:Number):void{
			_cdtime = value ;
			
			//在后台开始计时
			_cdTimer.stop() ;
			_cdTimer.reset() ;
			_cdTimer.delay = _cdtime * 1000 / 100 ;
			_cdTimer.repeatCount = 100 ;
			_cdTimer.start() ;
		}
		
		private var _cdcommand:Number = 0 ;
		/**公共cd时间*/
		public function get cdcommand():Number{
			return _cdcommand ;
		}

		public function set cdcommand(value:Number):void{
			_cdcommand = value ;

			_commandTimer.stop() ;
			_commandTimer.reset() ;
			_commandTimer.delay = _cdcommand * 1000 / 100 ;
			_commandTimer.repeatCount = 100 ;
			_commandTimer.start() ;
		}

		/**取需时最长的计时器*/
		public function get lastingTimer():Timer{
			return _cdtime > cdcommand ? _cdTimer : _commandTimer ;
		}
		
		public function get lastingTimer_time():Number{
			return _cdtime > cdcommand ? _cdtime :  cdcommand ;
		}
		
		/**公共技能所属组*/
		public var commandGroup:String = '' ;
		
		
		
		//******************************************************** 改写**********************************************		
		/**技能CD*/
		public function get privateCDTimer():Number
		{
			return _privateCDTimer;
		}
		public function set privateCDTimer(value:Number):void
		{
			_privateCDTimer = value;
		}
		
		/**公共CD*/
		private var publicCDTimer:Timer = new Timer(100);
		
		/**倒计时*/
		private var _publicCDTimer:Number = 0;		
		
		/**当前技能CD时间*/
		public var publicCDvalue:Number = 0;
		
		/**公共技能CD时间*/
		public var _privateCDTimer:Number = 0;
		
		/**技能总时间*/
		public var countTime:Number = 0;
		/**CD技能时间入口*/
		public function set publicCDtime(i:Number):void
		{
			countTime = i;
			publicCDvalue = i;
			_publicCDTimer = i * 1000 + CommonData.serverTime;
			
			if(i <= 0)
			{
				return;
			}
			
			if(publicCDTimer.running)
			{
				publicCDTimer.reset();
				publicCDTimer.removeEventListener(TimerEvent.TIMER,publicCDTimerHandler);
			}
			
			publicCDTimer.start();
			publicCDTimer.addEventListener(TimerEvent.TIMER,publicCDTimerHandler);
		}
		
		private function publicCDTimerHandler(e:TimerEvent):void
		{
			if(publicCDvalue <= 0)
			{
				_publicCDTimer =0;
				publicCDTimer.reset();
				publicCDTimer.removeEventListener(TimerEvent.TIMER,publicCDTimerHandler);
			}
			
			publicCDvalue = (_publicCDTimer - CommonData.serverTime) / 1000;
		}
		
		public function  get cdTime():Number
		{
			return publicCDvalue < countTime && publicCDvalue >=0 ? publicCDvalue : countTime;
		}
		
		public function get cdCount():Number
		{
			return countTime;
		}
		
		/**判断技能是否在CD*/
		public function get run():Boolean
		{
			return publicCDTimer.running;
		}
		
	}
}