package com.starling.battle.view.unit.view
{
	import com.starling.battle.view.unit.IUintDisplay;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BaseView extends Sprite implements IUintDisplay
	{
		protected var baseTexture:Texture ;
		
		private var _textureAtlas:TextureAtlas ;
		
		/**
		 *是否自动移除 
		 */		
		private var _autoMove:Boolean = false;
		
		/**
		 *当前动画播放帧频 
		 */		
		private var _frameRate:int = 0 ;
		
		
		private var _action:int = 1;
		
		private var _actions:Vector.<int> ;
		
		private var _course:int ; 
		
		private var _state:int ; 
		
		
		private var _isPlay:Boolean ;
		
		protected var _direction:int = 1;
		
		
		protected var _textureName:String ;
		public function BaseView()
		{
			super();
			if(!baseTexture)
			{
				baseTexture = Texture.fromColor(2,2,0x00ffffff);
			}
		}
		
		public function get autoMove():Boolean
		{
			return _autoMove;
		}

		public function set autoMove(value:Boolean):void
		{
			_autoMove = value;
		}

		public function get textureAtlas():TextureAtlas
		{
			return _textureAtlas;
		}

		public function set textureAtlas(value:TextureAtlas):void
		{
			_textureAtlas = value;
		}

		public function reset():void
		{
			//TODO: implement function
		}
		
		public function set actions(value:Vector.<int>):void
		{
			_actions = value;
		}
		
		public function get actions():Vector.<int>
		{
			//TODO: implement function
			return _actions;
		}
		
		public function get action():int
		{
			//TODO: implement function
			return _action;
		}
		
		public function set action(value:int):void
		{
			_action = value ;
		}
		
		public function set course(value:Number):void
		{
			_course = value ;
		}
		
		public function get course():Number
		{
			return _course;
		}
		
		public function set pointAt(value:Number):void
		{
			//TODO: implement function
		}
		
		public function set state(value:int):void
		{
			_state = value ;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		public function set frameRate(value:int):void
		{
			_frameRate = value ;
		}
		
		
		
		public function get direction():int
		{
			return _direction ;
		}
		
		public function set direction(value:int):void
		{
			_direction = value;
		}
		
		public function get onPlay():Boolean
		{
			return _isPlay;
		}
		
		public function get textureName():String
		{
			return _textureName;
		}
		
		public function set textureName(value:String):void
		{
			_textureName = value;
		}
		
		public function play():void
		{
		
		}
		
		public function stop():void
		{
		
		}
	
	}
}