package com.starling.battle.view.unit
{
	public class ActionType
	{
		
		
		public function ActionType()
		{
		}
		
		
		private static const direction:Array = [];
		
		
		
		private static const actionLvls:Array = [ACTION_STAND_BY,ACTION_MOVE,ACTION_BE_ATTACK,ACTION_THROW,ACTION_ATTACK,ACTION_DEFENSE,ACTION_DIE];
		
		/**
		 *站立 
		 */		
		public static const ACTION_STAND_BY:int = 3;
		
		/**
		 *移动 
		 */		
		public static const ACTION_MOVE:int = 1;
		
		/**
		 *攻击 
		 */		
		public static const ACTION_ATTACK:int = 2;
		
		/**
		 *死亡 
		 */		
		public static const ACTION_DIE:int = 5;
		
		/**
		 *被攻击 
		 */		
		public static const ACTION_BE_ATTACK:int = 4;
		
		/**
		 *射箭 
		 */		
		public static const ACTION_THROW:int = 6;
		
		/**
		 *防御 
		 */		
		public static const ACTION_DEFENSE:int = 7;
		
		
		
		
		public static const DIR_UP:int = 1 ;
		
		public static const DIR_RIGHT_UP:int = 2 ;
		
		public static const DIR_RIGHT : int = 3;
		
		public static const DIR_DOWN_RIGHT:int = 4 ;
		
		public static const DIR_DOWN:int = 5 ;
		
		public static const DIR_DOWN_LEFT : int = 6 ;
		
		public static const DIR_LEFT:int = 7 ;
		
		public static const DIR_LEFT_UP:int = 8 ;
	
		
		
		public static function getActionLvl(action:int):int
		{
			return actionLvls.indexOf(action);
		}
		
		
	}
}