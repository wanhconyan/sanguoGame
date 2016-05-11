package com.starling.battle.view.component
{
	import com.core.component.MulitPolygon;
	
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class BattlePolygon extends Sprite
	{
		private var  mulitPolygon:MulitPolygon;
		private var _image:Image ;
		public function BattlePolygon(lenU:int,lenV,size:int)
		{
			mulitPolygon = new MulitPolygon(1,1,size);
			mulitPolygon.alpha = 0.5;
			var bmp:BitmapData = new BitmapData(220,220,true);
			bmp.draw(mulitPolygon);
			var texture:Texture = Texture.fromBitmapData(bmp);
			_image = new Image(texture);
			mulitPolygon = null;
			bmp.dispose() ;
			_image.alpha = 0.3 ;
			this.addChild(_image);
			
		}
		
		
		public function show():void{
			this.visible = true ;
		}
		
		/**
		 *隐藏显示 
		 */
		public function hide():void
		{
			this.visible = false;
				
		}
	}
}