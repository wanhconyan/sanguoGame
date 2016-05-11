package com.starling.battle.view.component 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.utils.VertexData;
	
	public class Polygon extends CustomImage
	{
		
		private var mNumEdges:int;

		
		private static var sProgramNameCache:Dictionary = new Dictionary();
		
		public function Polygon(radius:Number, texture:Texture, numEdges:int=6)
		{
			this.mNumEdges = numEdges;
			mTexture = texture;
			mVertexData = new VertexData(numEdges+1);
//			mVertexData.setUniformColor(0xffffff);
			mVertexData.setTexCoords(numEdges, 0.0, 1.0);
			mVertexData.setPosition(numEdges, 0.0, 0.0); // center vertex
			
			
			for (var i:int=0; i<numEdges; ++i)
			{
				var edge:Point = Point.polar(radius, i * 2*Math.PI / numEdges);
				mVertexData.setPosition(i, edge.x, edge.y);
				
				mVertexData.setTexCoords(i, 1 / numEdges * i,0.0);
				
			}
			
			mIndexData = new <uint>[];
			for (var j:int=0; j<numEdges; ++j)
			{
				mIndexData.push(numEdges, j, (j+1) % numEdges);
			}
			
			numTriangles = numEdges;
			
			super();
		}
		
	}
}