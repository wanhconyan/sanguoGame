package com.core.util
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MathUtil
	{
		private static var sacalMat:Matrix = null; 
		private static var m:Matrix = null;
		public function MathUtil()
		{
		}
		
		
		/**
		 * 将点转化为45度角视图 
		 * @param $point
		 * @param $angle
		 * @return 
		 */		
		public static function translationPointToPlor($point:Point,$angle:Number = Math.PI/4):Point
		{
			m.rotate($angle);
			sacalMat.scale(1,0.63);
			m.concat(sacalMat);
			return m.transformPoint($point) ;
		}
		
		/**
		 * 获取矩阵 
		 * @return 
		 */
		public static function scalMatrix():Matrix
		{
			if(!m)
			{
				sacalMat = new Matrix(); 
				m = new Matrix();
				m.rotate(Math.PI/4);
				sacalMat.scale(1,0.63);
				m.concat(sacalMat);
			}
		
			return m ;
		}
		
	}
}