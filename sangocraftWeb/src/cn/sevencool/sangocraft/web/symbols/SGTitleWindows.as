package cn.sevencool.sangocraft.web.symbols
{
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import spark.components.TitleWindow;
	import spark.core.SpriteVisualElement;
	/**
	 * project: sangocraft_Web
	 * @class: SGTitleWindows
	 * @author: wangcongyan
	 * @usage: 通用TitleWindows
	 * @since: 2013-10-16
	 * @modified: 2013-10-16
	 * @modifier: wangcongyan 
	 */
	public class SGTitleWindows extends TitleWindow
	{
		private var _imgTitle:String = '';
		private var titleKey:String = MaterialKeys.PANELTITLE;
		private var _bitmap:Bitmap  =null;
		private var dic:Dictionary = new Dictionary();
		/**
		 * 作为保存title的头的容器
		 * */
		private var sp:SpriteVisualElement = new SpriteVisualElement();
		public function SGTitleWindows()
		{
			super();
		}
		
		
		public function get imgTitle():String
		{
			return _imgTitle;
		}
		
		public function set imgTitle(value:String):void
		{
			_imgTitle = value;
			if(imgTitle!='')
			{
					var arr:Array = imgTitle.split('_');
					try
					{
						if(arr.length>1)
						{
							var url:String = arr[0];
							var w:int = parseInt(arr[1])
							_bitmap = MaterialManager.getInstance().getIcon(titleKey,url)
							if(sp.numChildren)
							{
								sp.removeChildAt(0);
							}	
							sp.addChild(_bitmap);
							sp.x =  this.width -w>>1;
							sp.y =-46;
							this.addElement(sp);
						}else
						{
							if(arr.length == 0)
							{
								throw new Error("图片名称赋值为:''");
							}
							if(arr.length == 1)
							{
								throw new Error(arr[0]+"图片未设置宽度大小")
							}
						}
					} 
					catch(error:Error) 
					{
						trace(error.message)
					}
			}
			
		}
	}
}