package cn.sevencool.sangocraft.web.symbols
{
	import flash.display.Sprite;
	
	import mx.preloaders.SparkDownloadProgressBar;

	/**
	 * project: sangocraft_Web
	 * @class: ProLoaderBar
	 * @author: zhouyan
	 * @usage: 预加载面板显示
	 * @since: 2013-10-16
	 * @modified: 2013-10-16
	 * @modifier: zhouyan 
	 */
	public class ProLoaderBar extends SparkDownloadProgressBar
	{
		
		private var loadBar:LoadingProgress = null;
		public function ProLoaderBar()
		{
			super();
			loadBar = new LoadingProgress();
			
		}
		
		override protected function createChildren():void
		{ 
			var _background:Sprite = new Sprite();
			
			this.addChild(_background);
			_background.x = stageWidth / 2 - 203;
			_background.y = stageHeight / 2 - 100;
			loadBar.loadText.text = "主文件加载当前加载进度1%";
			_background.addChild(loadBar);
			
		}
		
		protected override function setInitProgress(completed:Number, total:Number):void
		{
			
		}
		
		protected override function setDownloadProgress(completed:Number, total:Number):void
		{
			if(loadBar)
			{
				var percent:Number = completed/total;
				loadBar.loadProgressBar.width = 470 * percent ; 
				loadBar.loadSpark.x = -36 + 472 * percent   ; 
				loadBar.loadText.text = "主文件加载当前加载进度"+ (percent * 100).toFixed(2) +"%";
			}
		}
		
	}
}