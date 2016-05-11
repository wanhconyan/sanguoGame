package cn.sevencool.sangocraft.web.ui.battleField.view.itemrender
{
	import cn.sevencool.sangocraft.web.ui.battleField.view.SmallCity;

	public class CityPool
	{
		/**
		 * 舞台上存在的对象的总数
		 * */
		private const total:int = 11 ;
		
		/**
		 * 当前创建的个数
		 * */
		private var _createNum:int = 0;
		
		private static var _instance:CityPool = null;
		
		private var pools:Vector.<SmallCity> = null;
		
		
		private var useCitys:Vector.<SmallCity> = null;;
		
		public function CityPool($access:Private)
		{
			if(!$access)
			{
				throw new Error("you can create object directly!")
			}
				pools = new Vector.<SmallCity>();
				useCitys= new Vector.<SmallCity>();
		}
		
		public  function getSmallCity():SmallCity
		{
			var smallCity:SmallCity = null;
			for(var i:int = 0;i<pools.length;i++)
			{
				if(!pools[i].stage)
				{
					return pools[i];
				}
			}
			
			smallCity = new SmallCity();
			pools.push(smallCity);
			
			return smallCity;
		}
		
		public function recycleSmallCity():void
		{
			var len:int = useCitys.length;
			
			_createNum = pools.length;
		}
		
		public static function getPool():CityPool
		{
			if(!_instance)
			{
				_instance = new CityPool(new Private);
			}
		
			return _instance;
		}
	}
}
class Private{}