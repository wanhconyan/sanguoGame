package cn.sevencool.sangocraft.web.symbols.itemsBox
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	
	public class LatticeManager extends EventDispatcher
	{
		public function LatticeManager(target:IEventDispatcher=null)
		{
			super(target);
			
			initialize() ;
		}
		
		private function initialize():void{
		}
		
		private var cdinfo:OperationCD = null;
		
		
		private function cdGroups(cdinfo:OperationCD , group:String):void
		{
			/**获取相关组别的列表*/
			var larray:Array = fetch(group) ;
			var len:uint = larray.length ;
			
			for(var i:int = 0 ; i < len ; i++)
			{
				var lattice:LatticeUltra = larray[i] ;
				
				if(!lattice.element)
				{
					continue ;
				}
				
				var stinger:String = '' ;
//				lattice.cdElement(cdinfo,stinger);
			}
		}
		
		private var _table:Dictionary = new Dictionary ;
		
		public function add(lattice:LatticeUltra):void
		{
			var list:Array = _table[lattice.group] ;
			if(list == null)
			{
				list = [] ;
				_table[lattice.group] = list ;
			}
			
			if(list.indexOf(lattice) == -1)
			{
				
				list.push(lattice) ;
			}
			
		}
		
		public function fetch(group:String):Array
		{
			var list:Array = _table[group] ;
			if(list == null)
			{
				list = [] ;
				_table[group] = list ;
			}
			return list ;
		}
		
		private static var _instance:LatticeManager = null ;
		
		public static function getInstance():LatticeManager
		{
			if(_instance == null)
			{
				_instance = new LatticeManager ;
			}
			
			return _instance ;
		}
	}
}