package com.starling.battle.view.unit
{
	
	
	public interface IUintDisplay
	{
		function reset():void;
		
		function set actions(value:Vector.<int>):void ;
		function get actions():Vector.<int>;
		
		function get action():int ;
		function set action(value:int):void;
		
		function set course(value:Number):void;
		function get course():Number ;
		
		function set pointAt(value:Number):void ;
		
		function set x(value:Number):void;
		function get x():Number ;
		
		function get y():Number ;
		function set y(value:Number):void ;
		
		function set state(value:int):void ;
		function get state():int ;
		
		function get frameRate():int ;
		function set frameRate(value:int):void;
		
		function get onPlay():Boolean ;
		
		function set direction(value:int):void;
		function get direction():int ;
		
		function play():void;
		
		function stop():void;
	}
}