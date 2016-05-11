package com.sevenCool.manager
{
	import com.core.component.PolyState;
	import com.core.vo.fraction.FractionNode;
	import com.core.vo.fraction.FractionVO;
	import com.core.xmlHelper.XmlCreateManager;
	import com.sevenCool.fileManager.FileManager;
	
	import mx.controls.Alert;

	/**
	 * 阵型管理器 
	 * @author Administrator
	 */	
	public class FractionManager
	{
		private static var _instance:FractionManager = null;
		
		private var _fractionVO:FractionVO = null;
		
		private var _formations:Vector.<PolyState> = null;
		
		private var _fractions:Array = [];
		
		public function FractionManager()
		{
			_fractionVO = new FractionVO();
			_formations = new Vector.<PolyState>();
		}
		
		public function get formations():Vector.<PolyState>
		{
			return _formations;
		}

		public function set formations(value:Vector.<PolyState>):void
		{
			_formations = value;
		}

		public function get fractions():FractionVO
		{
			return _fractionVO;
		}

		public function set fractions(value:FractionVO):void
		{
			_fractionVO = value;
		}

		public static function getInstance():FractionManager
		{
			if(!_instance)
			{
				_instance = new FractionManager();
			}
			return _instance;
		}
		
		/**
		 * 保存阵型 
		 */		
		public function saveFraction():void
		{
			translationTOFractionVO();
			if(_fractionVO.nodes.length == 0)
			{
				Alert.show("空的阵型数据");
				return ;
			}
			var xml:XML =  XmlCreateManager.getInstance().analysisVOToXml(_fractionVO);
			FileManager.getInstance().saveAs(xml,"xml");	
		}
		
		private function translationTOFractionVO():void
		{
			var len:int = _formations.length ;
			var polyState:PolyState = null;
			var xAverange:int = 0 ;
			var yAverange:int = 0 ;
			for(var i:int = 0 ; i < len ; i ++)
			{
				polyState = _formations[i];
				if(polyState.xNode - xAverange <= 0 )
				{
					xAverange = polyState.xNode ;	
				}else if(xAverange == 0)
				{
					xAverange = polyState.xNode ;
				}
				if(polyState.yNode - yAverange <= 0 )
				{
					yAverange = polyState.yNode ;	
				}else if(yAverange == 0)
				{
					yAverange = polyState.yNode ;
				}
			}
			fractions.nodes = new Vector.<FractionNode>();
			var node:FractionNode = null;
			for( i = 0 ; i < len ; i ++)
			{
				node = new FractionNode();
				node.xNode = _formations[i].xNode - xAverange;
				node.yNode = _formations[i].yNode - yAverange;
				fractions.nodes.push(node);
			}
		}
	}
}