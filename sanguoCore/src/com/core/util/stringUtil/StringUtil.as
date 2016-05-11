package com.core.util.stringUtil
{
	import flash.utils.ByteArray;

	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		/**
		 * 把数字转成  1000->1,000
		 * @param $value
		 * @return 
		 * 
		 */
		public static function formatNum($value:int):String
		{
			var strNum:String = $value.toString();
			
			if(strNum.length > 3)
			{
				var arr:Array = new Array();  
				var start:Number;  
				var end:Number = strNum.length;  
				while (end > 0) {  
					start = Math.max(end - 3, 0);  
					arr.unshift(strNum.slice(start, end));  
					end = start;  
				}
				strNum = arr.join(",");  
			}
			
			return strNum;
		}
		
		/**
		 * 获取字符串长度 （中英文混合）
		 * @param thisString
		 * @return 
		 * 
		 */
		static public function GetStringLength(thisString : String) : int
		{  
			var thisStringBytsLength :ByteArray = new ByteArray();  
			thisStringBytsLength.writeMultiByte(thisString,"utf-8");  
			return thisStringBytsLength.length;  
		} 
		
		/**
		 * 获得中文周几
		 * @param $num
		 * 
		 */
		static public function getWeekDay($num:int):String
		{
			var arr:Array = ["日","一","二","三","四","五","六"];
			return arr[$num];
		}
		
		/**
		 * 获得中文数字（0~10） 
		 * @param $num
		 * 
		 */
		static public function getChieseNum($num:int):String
		{
			var arr:Array = ["零","一","二","三","四","五","六","七","八","九","十"];
			return arr[$num];
		}
		
		/**
		 * 将一个整数的时间值格式化为00:00:00格式的时间值
		 * @param time 秒数
		 * @return 
		 * 
		 */		
		static public function formatToTime(time:uint):String
		{
			var second:int = time% 60;
			var minute:int= ((time - second) / 60 ) % 60;
			var hour:int = (time -60*minute-second) / 3600;
			var strSecond:String = second < 10 ? "0" + second.toString():second.toString();
			var strMinute:String = minute < 10 ? "0" + minute.toString():minute.toString();
			var strHour:String = hour < 10 ? "0" + hour.toString():hour.toString();
			return strHour+":"+strMinute+":"+strSecond;
		}
		
		/**
		 * 将一个整数的时间值格式化为 00小时00分00秒 格式的时间值
		 * @param time 秒数
		 * @return 
		 * 
		 */		
		static public function formatToTime_V2(time:uint):String
		{
			var second:int = time% 60;
			var minute:int= ((time - second) / 60 ) % 60;
			var hour:int = (time -60*minute-second) / 3600;
			var strMinute:String = minute == 0 ? "": minute.toString() + "分";
			var strHour:String = hour == 0 ? "": hour.toString() + "小时";
			return strHour + strMinute + second + "秒";
		}
		
		/**
		 * 将一个整数的时间值格式化为 00小时00分 格式的时间值
		 * @param time 秒数
		 * @return 
		 */		
		static public function formatToTime_V3(time:uint):String
		{
			var second:int = time% 60;
			var minute:int= ((time - second) / 60 ) % 60;
			var hour:int = (time -60*minute-second) / 3600;
			var strMinute:String = minute == 0 ? "": minute.toString() + "分";
			var strHour:String = hour == 0 ? "": hour.toString() + "小时";
			return strHour + strMinute;
		}

		/**
		* 将毫秒数转化为01:18:56格式
		* @param        time 毫秒数
		* @return  返回格式：01:08:56
		* @example
		* <listing>
		*                 convertTime(4136); // 01:08:56
		* </listing>
		*/
		public static function convertTime(time:int, separator:String = ":"):String 
		{
		        var hour:int = int(time / 3600);
		        var min:int = int(time % 3600 / 60);
		        var sec:int = int(time % 60);
		                        
		        return (hour < 10 ? "0" + hour : "" + hour)
		        + separator + (min < 10 ? "0" + min : "" + min)
		        + separator + (sec < 10 ? "0" + sec : "" + sec);
		}
		
		/**
		 * 解析时间成当前时间
		 * @param time
		 * @return 
		 * 
		 */	
		public static function resloveFormatLastLoginTime(time:Number):String
		{
			//发过来的时间是距离1970年1月1日的秒数，因此用DATE的格式化需要乘上1000
			var t:String = "";
			var d:Date = new Date(time * 1000);
			t = d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日" + d.hours + "时" + d.minutes + "分" + d.seconds +"秒";
			return t;
		}
		
		/**
		 * 解析时间(年月日)
		 * @param time
		 * @return 
		 * 
		 */	
		public static function formatTimeToDay(time:Number):String
		{
			//发过来的时间是距离1970年1月1日的秒数，因此用DATE的格式化需要乘上1000
			var t:String = "";
			var d:Date = new Date(time * 1000);
			t = d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日";
			return t;
		}
		
		/**
		 * 解析时间(年月日时分)
		 * @param time
		 * @return 
		 * 
		 */	
		public static function formatTimeToMin(time:Number):String
		{
			//发过来的时间是距离1970年1月1日的秒数，因此用DATE的格式化需要乘上1000
			var t:String = "";
			var d:Date = new Date(time * 1000);
			t = d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日" + d.hours + "时" + d.minutes + "分";
			return t;
		}
		
		
		/**
		 * 解析时间(年月日时分)
		 * 1970年1月1日10:20
		 * @param time
		 * @return 
		 * 
		 */	
		public static function formatTimeToMin2(time:Number):String
		{
			//发过来的时间是距离1970年1月1日的秒数，因此用DATE的格式化需要乘上1000
			var t:String = "";
			var d:Date = new Date(time * 1000);
			t = d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日" + (d.hours < 10 ? "0" 
				+ d.hours : "" + d.hours) + ":" + (d.minutes < 10 ? "0" + d.minutes : "" + d.minutes);
			return t;
		}
		
		/**
		 * 替换所有的字符串,通过split and join
		 * Repalce all String by split and join;
		 */
		public static function replaceAllBySplit(strSource:String, strReplaceFrom:String, strRepalceTo:String):String {
			return strSource == null ? null : strSource.split(strReplaceFrom).join(strRepalceTo);
		}
		
		/**
		 * 替换所有的字符串,通过正则
		 * Replace all String by RegEx;
		 */
		public static function replaceAllByRegex(strSource:String, strReplaceFrom:String, strRepalceTo:String):String {
			return strSource == null ? null : strSource.replace(new RegExp(strReplaceFrom, 'g'), strRepalceTo);
		}
		
		/**
		 * 区间取随机数 
		 * @param min
		 * @param max
		 * @return 
		 */		
		public static function randRange(min:Number, max:Number):Number
		{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		
		/**
		 * 从原字符串中,截取一个指定字节长度的字符串 
		 * @param name
		 * @param leng
		 * @return 
		 * 
		 */		
		public static function checkNameLength(name:String, leng:int = 16):String
		{
			var ret:String = "";
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(name, "gb2312");
			if(bytes.length > leng)
			{
				bytes.position = 0;
				ret = bytes.readMultiByte(leng, "gb2312");
			}
			else
			{
				ret = name;
			}
			return ret;
		}
		
		/**
		 * 00：00
		 * @param value 秒
		 * 
		 */		
		public static function formatTimeToMinSec(value:Number):String
		{
			var min:int = value/60;
			var sec:int = value%60;
			var t:String = (min>=10?min:"0"+min) + ":"+(sec>=10?sec:"0"+sec);
			return t;
		}
		
		/**
		 *  动态替换字符
		 *  Substitutes "{n}" tokens within the specified string
		 *  with the respective arguments passed in.
		 *
		 *  @param str The string to make substitutions in.
		 *  This string can contain special tokens of the form
		 *  <code>{n}</code>, where <code>n</code> is a zero based index,
		 *  that will be replaced with the additional parameters
		 
		 *  found at that index if specified.
		 *
		 *  @param rest Additional parameters that can be substituted
		 *  in the <code>str</code> parameter at each <code>{n}</code>
		 *  location, where <code>n</code> is an integer (zero based)
		 *  index value into the array of values specified.
		 *  If the first parameter is an array this array will be used as
		 *  a parameter list.
		 *  This allows reuse of this routine in other methods that want to
		 *  use the ... rest signature.
		 *  For example <pre>
		 *     public function myTracer(str:String, ... rest):void
		 *     { 
		 *         label.text += StringUtil.substitute(str, rest) + "\n";
		 *     } </pre>
		 *
		 *  @return New string with all of the <code>{n}</code> tokens
		 *  replaced with the respective arguments specified.
		 *
		 *  @example
		 *
		 *  var str:String = "here is some info '{0}' and {1}";
		 *  trace(StringUtil.substitute(str, 15.4, true));
		 *
		 *  // this will output the following string:
		 *  // "here is some info '15.4' and true"
		 */
		public static function substitute(str:String, ... rest):String
		{
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			
			str = str.replace(/\\t/g, "	");
			for (var i:int = 0; i < len; i++)
			{
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			return str;
		}
		
		/**
		 * 获取字串长度
		 * @param str	字符串
		 * @param ChineseLen	单个中文的长度
		 * @return 
		 * 
		 */		
		public static function getStringLen(str:String, ChineseLen:int = 2):int
		{
			var len:int = 0;
			if (str)
			{
				var tmp:String = '';
				for (var i:int = 0; i < ChineseLen; i++)
				{
					tmp += 'x';
				}
				len = str.replace(/[^\x00-\xff]/g, tmp).length;
			}
			return len;
		}
	}
}


