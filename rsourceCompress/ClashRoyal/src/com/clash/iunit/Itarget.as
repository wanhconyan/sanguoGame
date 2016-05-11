package com.clash.iunit
{
	import flash.display.Sprite;

	public interface Itarget
	{
		function get hp():int ;
		function set hp(value:int):void;
		
		function set demagePoint(value:int):void;
		function get damagePoint():int;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/**检查当前对象是否死亡，如死亡则清楚并同时舞台*/
		function checkDie():void;
		
		function attack(target:Itarget,loseHp:int):void
		
		function moveTo(target:Itarget):void;
		
		function loseHp(loss:int):void;
	
		function addTo(parent:Sprite):void;
			
			
	}
}