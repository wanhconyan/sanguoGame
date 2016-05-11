package com.core
{
	public class Global
	{
		//远程加载路径
		public static const RES_URL:String = "http://127.0.0.1:8080/flashres/res/";
		
		public static const LOCAL_UR:String = "file:///Developments/unity/flashres/res/";
		
		public static var isFarLoad:Boolean = false;
		public static function getUnitUrl($unitID:String):String
		{
			var url:String = "file:///Developments/unity/flashres/res/unit/blueunit/"+$unitID+".obj"	 ;
			if(isFarLoad)
			{
				 url  =Global.RES_URL + "unit/blueunit/" + $unitID + ".obj";
			}
			return url ;
		}
			
		
		public static function getImgUrl($unitID:String):String
		{
			var url:String  =Global.RES_URL + $unitID;
			return url ;
		}
			
		
		
	}
}