package cn.sevencool.sangocraft.web.symbols.itemsBox{
	import flash.events.Event;
	
	public class LatticeEvent extends Event{
		/**点击格子*/
		public static const LATTICE_CLICK:String = 'latticeClick' ;
		
		/**格子摆放完成*/
		public static const LIST_PAVE_COMPLETE:String = 'listPaveComplete' ;
		
		public function LatticeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable) ;
			
		}
	}
}