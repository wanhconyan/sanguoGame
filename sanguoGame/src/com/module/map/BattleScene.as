package com.module.map
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class BattleScene extends Sprite
	{
		private var _image:Image;
		
		private var battleID:String ; 
		public function BattleScene()
		{
		
		}
		
		public function setBmp($texture:Texture):void
		{
			_image = new Image($texture);
			this.addChild(_image);
		
		}
	}
}