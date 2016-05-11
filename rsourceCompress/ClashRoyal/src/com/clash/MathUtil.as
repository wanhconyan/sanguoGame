package com.clash
{
	import flash.geom.Point;

	public class MathUtil
	{
		
		
		public static function distance(p1:Point,	p2:Point):Number
		{
			return p1.x * p2.x + p2.y*p2.y;
		}
		
		public static function angle(p1:Point,	p2:Point):Number
		{
			return Math.atan2(p1.y-p2.y,p1.x-p2.x);
		}
	}
}