package cn.sevencool.sangocraft.web.operators
{
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.BasePanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.PreBattlePanel;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.plugins.VisiblePlugin;
	import com.sevencool.rtslogic.team.Team;
	
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	
	import mx.core.IVisualElement;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import spark.effects.Scale;

	public class TweenOperator implements IUIManangerTweenOperator
	{
		
		static private var _instance:TweenOperator = null;
		/**
		 * 缩放特效
		 * */
		private var effect:Scale = null;
		
		/**
		 * 缩小特效
		 * */
		private var smallEffect:Scale = null;
		
		private var fade:Fade = null;
		
		private var visFade:Fade = null;
		
		/**
		 * 缩放特效
		 * */
		private var scaleToSmall:ScalePlugin = null;
		
		/**
		 * 放大特效
		 * */
		private var scaleToLarge:ScalePlugin = null;
		
		private var _musicOperate:MusicOperatorManager = null;
		
		private var _visualElements:IVisualElement = null;
		public static function getInstance():IUIManangerTweenOperator
		{
			if(!_instance)
				_instance = new TweenOperator();
			return _instance;
		}
		
		
		public function TweenOperator()
		{
			
			effect = new Scale();
			effect.scaleXFrom  = 0.001;
			effect.scaleYFrom = 0.001;
			effect.scaleXTo = 1;
			effect.scaleYTo = 1;
			effect.autoCenterTransform = true;
			effect.duration = 300;
			
			smallEffect = new Scale();
			smallEffect.scaleXFrom  = 1;
			smallEffect.scaleYFrom = 1;
			smallEffect.scaleXTo = 0.001;
			smallEffect.scaleYTo = 0.001;
			smallEffect.autoCenterTransform = true;
			smallEffect.duration = 300;
			
			fade = new Fade();
			fade.alphaFrom = 0.0;
			fade.alphaTo = 1;
			fade.duration = 300;
			
			visFade = new Fade();
			visFade.alphaFrom = 1;
			visFade.alphaTo = 0.0;
			visFade.duration = 300;
			
			_musicOperate = MusicOperatorManager.getInstance();
		}
		
		
		private var oldX:Number = 0;
		private var oldY:Number = 0;
		private var transform:Transform = null;
		public function showPanel($panel:IVisualElement):void
		{
			effect.target = $panel;
			effect.play();
			_musicOperate.effectMusicPlay("Interface05");
			
		}
		
		private function onEffectEnd(event:EffectEvent =null):void
		{
			UIMananger.getInstance().removeObj(visualElements);
		}
		
		public function hidePanel($panel:IVisualElement,$visualElement:IVisualElement):void
		{
			visualElements = $visualElement;
			if($visualElement is PreBattlePanel)
			{
				onEffectEnd()
				return;
			}
			smallEffect.target = $panel;
			smallEffect.play();
			_musicOperate.effectMusicPlay("Interface02");
			smallEffect.addEventListener(EffectEvent.EFFECT_END,onEffectEnd);
		}

		public function get visualElements():IVisualElement
		{
			return _visualElements;
		}

		public function set visualElements(value:IVisualElement):void
		{
			_visualElements = value;
		}
		
		
	}
}