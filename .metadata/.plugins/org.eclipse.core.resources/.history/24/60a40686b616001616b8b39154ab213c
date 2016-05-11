package  com.sanguo.manager
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
	/**
	 * 3个等级的循环
	 * 逐帧
	 * 100毫秒
	 * 1秒
	 * @author zhou
	 */	
    public class LoopManager extends Object
    {
        private static var _isInited:Boolean;
        private static var _currentFrame:int;
		private static var _currentTime:int;
        private static var lastTime:int;
        private static var frameRates:Array = [];
        private static var _realFrameRate:Number = 30;
        private static var frameLoopDic:Dictionary;
//        private static var timer:Timer;
		private static var _timeTime:int;
		private static var _secondTime:int;
        private static var timeoutDic:Dictionary;
        private static var timeLoopDic:Dictionary;
        private static var delayIDKey:int;
//        private static var secondTimer:Timer;
        private static var SecondLoopDic:Dictionary;
        private static var stage:Stage;
        private static var _frameHold:int = 30;
        private static var secFrames:int;
        private static var frameTime:int;

        public function LoopManager()
        {
        }

        public static function init($stage:Stage) : void
        {
            if (_isInited == false)
            {
                frameLoopDic = new Dictionary();
                timeoutDic = new Dictionary();
                timeLoopDic = new Dictionary();
                SecondLoopDic = new Dictionary();
                stage = $stage;
                stage.addEventListener(Event.ENTER_FRAME, frameLoop);
                _isInited = true;
				_currentTime = getTimer();
            }
        }

		/**
		 * 帧循环
		 * @param event
		 */		
        private static function frameLoop(event:Event) : void
        {
			doFrameRate();
			for each(var loopFun:Function in frameLoopDic)
			{
//					try
//					{
						loopFun.call();
//					}
//					catch (e:Error)
//					{
//					}
			}
			if(_currentTime - _timeTime >= 50)
			{
				_timeTime = _currentTime;
				timerLoop();
			}
			if(_currentTime - _secondTime >= 1000)
			{
				_secondTime = _currentTime;
				secondLoop();
			}
        }

		/**
		 * 100毫秒循环
		 * @param event
		 */	
        private static function timerLoop() : void
        {
			var obj:Object;
			for each(obj in timeoutDic)
			{
				if(_currentTime - obj.startTime >= obj.count)
				{
					obj.handler.apply(null, obj.arg);
					timeoutDic[obj.key] = null;
					delete timeoutDic[obj.key];
				}
			}
			for each(obj in timeLoopDic)
			{
				if(_currentTime - obj.startTime >= obj.count)
				{
					obj.startTime = _currentTime;
//					if (Config.isDebug == true)
//					{
//						obj.handler.apply(null, obj.arg);
//					}
//					else
//					{
//						try
//						{
							obj.handler.apply(null, obj.arg);
//						}
//						catch (e:Error)
//						{
//						}
//					}
				}
			}
        }

		/**
		 * 1秒循环
		 * @param event
		 */	
        private static function secondLoop() : void
        {
			for each(var fun:Function in SecondLoopDic)
			{
//				if (Config.isDebug == true)
//				{
//					fun.call();
//				}else
//				{
//					try
//					{
						fun.call();
//					}
//					catch (e:Error)
//					{
//					}
//				}
			}
        }

        public static function addToFrame(loopKey:String, loopFun:Function) : void
        {
			if (frameLoopDic[loopKey] == null)
			{
				frameLoopDic[loopKey] = loopFun;
			}
        }

        public static function removeFromFrame(loopKey:String) : void
        {
            if (frameLoopDic[loopKey])
            {
                frameLoopDic[loopKey] = null;
                delete frameLoopDic[loopKey];
            }
        }

        public static function hasFrame(loopKey:String) : Boolean
        {
            if (frameLoopDic[loopKey])
            {
                return true;
            }
            return false;
        }

        public static function addToSecond(scendKey:String, scendFun:Function) : void
        {
            if (SecondLoopDic[scendKey] == null)
            {
                SecondLoopDic[scendKey] = scendFun;
            }
        }

        public static function removeFromSceond(scendKey:String) : void
        {
            if (SecondLoopDic[scendKey])
            {
                SecondLoopDic[scendKey] = null;
                delete SecondLoopDic[scendKey];
            }
        }
		
		public static function hasScendKey(scendKey:String) : Boolean
		{
			if (SecondLoopDic[scendKey])
			{
				return true;
			}
			return false;
		}

		/**
		 * 延迟回调
		 * @param handler
		 * @param time
		 * @param param3
		 * @return 
		 */		
        public static function setTimeout(handler:Function, time:int, arg:Array = null) : int
        {
            if (time == 0)
            {
				handler.apply(null, arg);
                return 0;
            }
			delayIDKey++;
            var data:Object = {key:delayIDKey, startTime:getTimer(), count:time, handler:handler, arg:arg};
            if (timeoutDic[delayIDKey] == null)
            {
                timeoutDic[delayIDKey] = data;
            }
            return delayIDKey;
        }

        public static function clearTimeout(key:int) : void
        {
            if (timeoutDic[key])
            {
                timeoutDic[key] = null;
                delete timeoutDic[key];
            }
        }

        public static function hasTimeout(key:int) : Boolean
        {
            return timeoutDic[key] != null;
        }
		
		/**
		 * 设置循环调用
		 * @param handler  循环方法
		 * @param time     循环时间  毫秒级  100豪秒一次检查   
		 * @param arg      参数
		 * @return    KEY
		 */		
		public static function setInterval(handler:Function, time:int, arg:Array = null):int
		{
			if (time == 0)
			{
				handler.apply(null, arg);
				return 0;
			}
			delayIDKey++;
			var data:Object = {key:delayIDKey, startTime:getTimer(), count:time, handler:handler, arg:arg};
			if (timeLoopDic[delayIDKey] == null)
			{
				timeLoopDic[delayIDKey] = data;
			}
			return delayIDKey;
		}
		
		public static function clearInterval(key:int):void
		{
			if (timeLoopDic[key])
			{
				timeLoopDic[key] = null;
				delete timeLoopDic[key];
			}
		}
		
		public static function hasInterval(key:int) : Boolean
		{
			return timeLoopDic[key] != null;
		}

		/**
		 * 实际帧速
		 * @return 
		 */		
        public static function get realRate() : int
        {
            return _realFrameRate;
        }

		/**
		 * 上一帧的毫秒数
		 * @return 
		 */		
        public static function get frameHold() : int
        {
            return _frameHold;
        }

        private static function doFrameRate() : void
        {
			_currentFrame++;
			_currentTime = getTimer();
            _frameHold = _currentTime - lastTime;
            lastTime = _currentTime;
			secFrames++;
            if (_currentTime - frameTime >= 1000)
            {
                _realFrameRate = secFrames;
                frameTime = _currentTime;
                secFrames = 0;
            }
            return;
        }

        public static function get currentFrame() : int
        {
            return _currentFrame;
        }
		
		public static function get currentTime():int
		{
			return _currentTime;
		}

		/**
		 * 帧数转毫秒
		 * @param numFrame
		 * @return 
		 */		
        public static function frameToTime(numFrame:int) : int
        {
            return numFrame * (1000 / stage.frameRate);
        }

		/**
		 * 秒数转帧数
		 * @param time
		 * @return 
		 */		
        public static function timeToFrame(time:Number) : int
        {
            return time / 1000 * stage.frameRate;
        }

    }
}
