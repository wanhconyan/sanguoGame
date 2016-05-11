package com.clash.component
{
	import flash.display.Sprite;
	
	public class Avatar extends Sprite
	{
		private var effect:Effect;
		private var bar:HPBar;
		private var tag:String = "";
		private var id:String  = "";
		public function Avatar(id:String)
		{
			this.id = id;
			effect = new Effect(id);
			this.addChild(effect);
		}
		
		public function showBar($bool:Boolean):void
		{
			
			if(!bar)
			{
				bar = new HPBar();
				this.addChild(bar);
				this.bar.x = this.width - bar.width >> 1 ;
				this.bar.x = this.y - bar.height ;
			}
			if($bool)
			{
				bar.visible = $bool;
			}
		
		}
	}
}