package cn.sevencool.sangocraft.web.operators
{
	import cn.sevencool.sangocraft.data.symbols.SoundManager;

	public class MusicOperatorManager implements IUIManagerMusicOperator
	{
		private var _sound:SoundManager = null
			
		private static var _instance:MusicOperatorManager = null;	
		public function MusicOperatorManager()
		{
			_sound = SoundManager.getInstance();
		}
		
		public function backMusicPlay($isBattle:Boolean):void
		{
			if($isBattle)
			{
				_sound.musicPlay("",0);
				
			}else
			{
				_sound.musicPlay("",0);
			}
			
		}
		
		public function clickSoundPlay():void
		{
			_sound.musicPlay("Interface01");
		}
		
		
		public function effectMusicPlay($sound:String):void
		{
			_sound.musicPlay($sound);
		}
		
		
		public function skillEffectplay($sound:String):void
		{
			_sound.musicPlay($sound,1);
		}
		public static function getInstance():MusicOperatorManager
		{
		
			if(!_instance)
			{
				_instance = new MusicOperatorManager();
			}
			return _instance;
		}
		
	}
}