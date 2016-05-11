package cn.sevencool.sangocraft.web.symbols
{
	/**
	 * 格式化日期类
	 * @author dmh2002
	 * 
	 */	
	public class MyDateFormat 
	{		
		/**
		 * 
		 * @param seconds 需要计算的秒数
		 * @param hourStr 用于显示小时的文字
		 * @param minuteStr 用于显示分钟的文字
		 * @param secondStr 用于显示秒数的文字
		 * @return
		 *  1 01秒
		 *	2 02秒
		 *	10 10秒
		 *	59 59秒
		 *	60 01分00秒
		 *	61 01分01秒
		 *	100 01分40秒
		 *	120 02分00秒
		 *	121 02分01秒
		 *	300 05分00秒
		 *	305 05分05秒
		 *	3200 53分20秒
		 *	3600 1小时00分00秒
		 *	3601 1小时00分01秒
		 *	3660 1小时01分00秒
		 *	3660 1小时01分00秒
		 *	3720 1小时02分00秒
		 *	3721 1小时02分01秒
		 *	13660 3小时47分40秒
		 *	13721 3小时48分41秒
		 *	2133721 592小时42分01秒
		 */		
		public static function getTimeStringBySecond( seconds:int,hourStr:String="小时",minuteStr:String="分",secondStr:String="秒" ,needSecond:Boolean = true):String
		{
			const secondsPerMinute:uint = 60;
			const secondsPerHour:uint = 60 * 60;
			
			var _HStr:String = "";
			var _MStr:String = "";
			var _SStr:String = "";
			
			var _h:int = Math.floor( seconds / secondsPerHour );
			
			if ( _h > 0 )
			{
				_HStr = _h.toString() + hourStr;
			}
			
			var _m:int = seconds - ( _h * secondsPerHour  );
			_m = Math.floor( _m / secondsPerMinute );
			
			_MStr = addZero( _m ) + minuteStr;
			
			var _s:int = seconds - ( _h * secondsPerHour + _m * secondsPerMinute );
			
			_SStr = addZero( _s ) +  secondStr;
			
			if(!needSecond)
			{
				_SStr = '';
			}
			
			
			if ( _h <= 0 )
			{
				_HStr = "";
//				_MStr = "";
			}
			
			return _HStr + _MStr + _SStr;
			
			function addZero( num:int ):String
			{
				var _str:String = "";
				
				_str = num.toString();
				
				if ( num < 10 )
				{
					_str =  '0'+num.toString();
				}
				
				return _str;
			}
			
		}
		
		
		public static function getTimeStringByMinute( seconds:int,hourStr:String="小时",minuteStr:String="分" ):String
		{
			const secondsPerMinute:uint = 60;
			const secondsPerHour:uint = 60 * 60;
			
			var _HStr:String = "";
			var _MStr:String = "";
			
			var _h:int = Math.floor( seconds / secondsPerHour );
			
			if ( _h > 0 )
			{
				_HStr = _h.toString() + hourStr;
			}
			
			var _m:int = seconds - ( _h * secondsPerHour  );
			_m = Math.floor( _m / secondsPerMinute );
			
			_MStr = addZero( _m ) + minuteStr;
			

			
			if ( _h <= 0 && _m <= 0 )
			{
				_HStr = "";
				_MStr = "";
			}
			
			return _HStr + _MStr;
			
			function addZero( num:int ):String
			{
				var _str:String = "";
				
				_str = num.toString();
				
				if ( num < 10 )
				{
					_str =  "0"+num.toString();
				}
				
				return _str;
			}
			
		}
		
		
		public static function getTimeStringByMinuteWithDay( seconds:int,dayStr:String="天",hourStr:String="小时",minuteStr:String="分" ):String
		{
			const secondsPerDay:uint = 24 * 60 * 60;
			
			var _DStr:String = "";
			
			var _d:int = Math.floor( seconds / secondsPerDay );
			
			var _hStr:String = getTimeStringByMinute( seconds - _d * secondsPerDay,hourStr,minuteStr );
			if(seconds<10*60)
			{
				_hStr = getTimeStringBySecond(seconds)
			}
			
			if ( _d > 0 )
			{
				_DStr = String( _d ) + dayStr + _hStr;
			}
			else
			{
				_DStr = _hStr;
			}
			
			return _DStr;
		}

		/**
		 * 根据时间返回天时间（天） 
		 * @param seconds
		 * @param hourStr
		 * @param minuteStr
		 * @param secondStr
		 * @return 
		 * 
		 */			  
		public static function getTimeStringBySecondWithDay( seconds:int,dayStr:String="天",hourStr:String="小时",minuteStr:String="分",secondStr:String="秒" ):String
		{
			const secondsPerDay:uint = 24 * 60 * 60;
			
			var _DStr:String = "";
			var _d:int = Math.floor( seconds / secondsPerDay );
			
			var _hStr:String = getTimeStringBySecond( seconds - _d * secondsPerDay,hourStr,minuteStr,secondStr );
			
			if ( _d > 0 )
			{
				_DStr = String( _d ) + dayStr + _hStr;
			}
			else
			{
				_DStr = _hStr;
			}
			
			return _DStr;
		}
		
		
		
		
		/**返回中文星期 使用了方法重载
		 * 参数 ...args 
		 * 如果对象是Date
		 * 则使用Date的getDay()方法获取星期
		 * 如果对象是uint
		 * 则直接使用该数字，数字尝过6，返回null
		 * 
		 */
		 public static function getChineseWeekLable(...args):String
		 {
		 	var weekDayLabels:Array = new Array("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
	   
	        switch ( typeof(args[0]) ) 
	        {             
	             case "object" :
	             	return weekDayLabels[args[0].getDay()];
	                break;
	             case "number" :
	                if(args[0]>6){
	                 return null;
	                }else{
	                 return weekDayLabels[args[0]];
	                }             
	                break;
	             default :
	                return  null;
	        }
		 }
	}
}