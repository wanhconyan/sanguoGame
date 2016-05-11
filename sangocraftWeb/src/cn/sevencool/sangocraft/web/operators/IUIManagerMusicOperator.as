package cn.sevencool.sangocraft.web.operators
{
	public interface IUIManagerMusicOperator
	{
		function backMusicPlay($isBattle:Boolean):void;
		function effectMusicPlay($sound:String):void;
		function skillEffectplay($sound:String):void;
		function clickSoundPlay():void;
	}
}