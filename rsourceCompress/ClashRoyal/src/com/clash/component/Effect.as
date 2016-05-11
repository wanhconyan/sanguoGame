package com.clash.component
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Effect extends Sprite
	{
		[Embed(source="../assets/0_1_1.jpg")]
		private var body_1:Class ;
		
		[Embed(source="../assets/0_2_1.jpg")]
		private var body_2:Class ;
		
		[Embed(source="../assets/0_3_1.jpg")]
		private var body_3:Class ;
		
		[Embed(source="../assets/1_1.png")]
		private var city_1:Class ;
		
		[Embed(source="../assets/1_2.png")]
		private var city_2:Class ;
		
		[Embed(source="../assets/2_1.png")]
		private var city_3:Class ;
		private var bitmap:Bitmap = null;
		public function Effect($url:String)
		{
			init($url)
		}
		
		private function init(url:String):void
		{
			switch(url)
			{
				case "1":
					bitmap = new body_1() as Bitmap;
					break;
				case "2":
					bitmap = new body_2() as Bitmap;
					break;
				case "3":
					bitmap = new body_3() as Bitmap;
					break;
				case "4":
					bitmap = new city_1() as Bitmap;
					break;
				case "5":
					bitmap = new city_2() as Bitmap;
					break;
				case "6":
					bitmap = new city_3() as Bitmap;
					break;
			}
			
			if( bitmap && !this.contains(bitmap))
			{
				this.addChild(bitmap);
			}
		}
	}
}