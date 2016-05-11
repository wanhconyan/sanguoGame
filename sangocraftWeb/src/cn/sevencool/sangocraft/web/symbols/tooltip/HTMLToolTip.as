package cn.sevencool.sangocraft.web.symbols.tooltip
{
	import mx.controls.ToolTip;

	import flash.filters.GlowFilter;

	public class HTMLToolTip extends ToolTip
	{
		public function HTMLToolTip()
		{
			super();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			textField.htmlText = text;
			var myGlowFilter:GlowFilter=new GlowFilter(0, 100, 2, 2, 5, 1, false, false);
			textField.filters=[myGlowFilter];
		}
		
	}
}