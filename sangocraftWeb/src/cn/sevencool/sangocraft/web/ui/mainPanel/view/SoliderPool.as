package cn.sevencool.sangocraft.web.ui.mainPanel.view
{
	import cn.sevencool.sangocraft.web.symbols.SolderType;

	public class SoliderPool
	{
		private static const TOTAL:int = 30;
		
		private var nowNum:int = 0;
		
		private static var _instance:SoliderPool = null;
		
		private var totalSoliders:Vector.<SoliderMovation> = null;
		private var createdSoliders:Vector.<SoliderMovation> = null;
		public function SoliderPool($access:Private)
		{
			if(!$access)
			{
				throw new Error("can't create obj directly")
			}
			
			totalSoliders = new Vector.<SoliderMovation>();
			createdSoliders = new Vector.<SoliderMovation>();
		}
		
		public static function getPool():SoliderPool
		{
			if(!_instance)
			{
				_instance = new SoliderPool(new Private);
			}
			return _instance;	
		}
		public function getSolider():SoliderMovation
		{
			var solider:SoliderMovation = null;
			if(totalSoliders.length>0)
			{
				solider = totalSoliders.shift();
			}else
			{
				solider = new SoliderMovation();
				nowNum ++;
			}
			createdSoliders.push(solider);
			if(nowNum > TOTAL)
			{
				throw new Error("create illegal");
			}
			return solider;
		}
		
		public function recycleSolider():void
		{
			var len:int = createdSoliders.length;
			var solider:SoliderMovation = null;
			for(var i:int = 0 ; i < len ; i ++)
			{	
				solider = createdSoliders.pop() as SoliderMovation;
				solider.disposeChild();
//				if(solider.parent)
//				{
//					solider.parent.removeChild(solider);
//				}
				totalSoliders.push(solider);
			}
			nowNum = totalSoliders.length;
		}
		
	}
}
class Private{}