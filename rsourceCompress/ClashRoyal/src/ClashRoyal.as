package
{
	import com.clash.view.scene.GameScene;
	
	import flash.display.Sprite;
	
	public class ClashRoyal extends Sprite
	{
		public function ClashRoyal()
		{
			var game:GameScene = new GameScene();
			addChild(game);
			game.start();
				
		}
	}
}