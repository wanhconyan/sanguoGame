package  com.core.starling.battle.view.unit.view
{
	import com.core.component.MulitPolygon;
	import com.core.starling.battle.ai.BattleField;
	import com.core.starling.battle.view.GameRoot;
	import com.core.vo.fraction.FractionVO;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;

	public class Team
	{
		/**
		 *阵型模型 
		 */		
		private var _formation:FractionVO = null;
		
		private var _type:String ='';
		
		private var _formationID:int = 0 ;
		
		/**
		 *目标对象 
		 */		
		private var _target:Team ;
		
		/**
		 *是否是远程攻击 
		 */		
		private var _isFarFire:Boolean = false;
		
		private var _formationIndex:int = 0 ;
		
		public var units:Vector.<UnitView>;
		
		/**
		 *当前队伍朝向 0: 左向，1:右向 
		 */		
		public var course:int ;
		public function Team()
		{
			
			
		}
		
		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get formationIndex():int
		{
			return _formationIndex;
		}

		public function set formationIndex(value:int):void
		{
			_formationIndex = value;
			changePosition();
		}
		
		private function changePosition():void
		{
	     var u:int  =formationIndex%15;
		 var v:int = formationIndex/15;
		 var point:Point = 	MulitPolygon.getPolyPosition(u,v,120);
		 _x  = point.x ;
		 _y = point.y;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 *当前阵型ID 
		 */
		public function get formationID():int
		{
			return _formationID;
		}

		/**
		 * @private
		 */
		public function set formationID(value:int):void
		{
			_formationID = value;
			reFormation();
		}

		public function get target():Team
		{
			return _target;
		}
		
		public function set target(value:Team):void
		{
			_target = value;
		}
		
		
		public function get formation():FractionVO
		{
			return _formation;
		}

		public function set formation(value:FractionVO):void
		{
			_formation = value;
			reSetFormation();
		}
		
		
		public function reFormation():void
		{
//			formation = XmlCreateManager.getInstance().getFraction(formationID);
			reSetFormation();
		}
		
		public function fire():void
		{
			
			
		}
		
		
		private function reSetFormation():void
		{
			
			
			
		
		}


		public function addMember(iunit:IUnit):void
		{
			BattleField.instance.battleContainer.addViewAt(iunit.view as DisplayObject,GameRoot.VIEW_INDEX);
			trace("Team.addMember(iunit)"+iunit.view.x);
			
		}
		
		
		private var _x:int ;
		private var _y:int ;
	}
}