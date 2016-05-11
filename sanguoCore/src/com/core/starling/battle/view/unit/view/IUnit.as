package  com.core.starling.battle.view.unit.view
{
	import com.core.starling.battle.view.unit.IUintDisplay;
	
	import flash.geom.Point;

	public interface IUnit
	{
		function set location(value:Point):void;
		function get location():Point ;
		
		function reFormationTime(value:Number):void;
		
		function get x():Number ;
		function get y():Number ;
		
		function get isBuilding():Boolean ;
		
		function get inBattle():Boolean ;
		function set inBattle(value:Boolean):void;
		
		function get view():IUintDisplay;
		
		function get isLiving():Boolean ;
		
		function get type():int ;
		function set type(value:int):void;
		
		function get teamID():int ;
		function set teamID(value:int):void ;
		
		function get campID():int ;
		function set campID(value:int):void ;
		
	}
}