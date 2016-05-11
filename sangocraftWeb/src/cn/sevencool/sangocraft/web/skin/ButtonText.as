package cn.sevencool.sangocraft.web.skin
{
	import mx.core.UITextField;

	import flash.filters.DropShadowFilter;
	
	public class ButtonText extends UITextField
	{
		public function ButtonText()
		{
			super();
			this.filters = [new DropShadowFilter(0,45,0x141101,1,2,2,5,1)];
		}
	}
}