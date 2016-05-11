package com.clash.component
{
	import com.clash.MathUtil;
	import com.clash.iunit.Itarget;
	import com.clash.manager.Dispatcher;
	import com.clash.manager.Time;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Target  implements Itarget 
	{
		public var speed:Number = 1.5;
		
		protected var avatar:Avatar;
		
		private var _damagePoint : int ;
		
		private var _hp:int ;
		
		private var parent:Sprite;
		
		private var _x:Number ;
		private var _y:Number ;
		public function Target(type:String)
		{
			init(type);
		}
		
		private function init(type:String):void
		{
			avatar = new Avatar(type);
		
		}
		
		public function get hp():int
		{
			return _hp;
		}
		
		public function get x():Number 
		{
			return _x ;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			avatar.x = _x;
		}
		
		public function get y():Number 
		{
			return _y ;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			avatar.y = _y ;
		}
		
		public function set hp(value:int):void
		{
			_hp = value;
		}
		
		public function set demagePoint(value:int):void
		{
			_damagePoint = value ;
		}
		
		public function get damagePoint():int
		{
			return _damagePoint;
		}
		
		public function checkDie():void
		{
			if(hp <= 0)
			{
				dispose();
				Dispatcher.dispatch("SoliderDie",this);
			}
		}
		
		private var p1:Point = new Point(0,0);
		private var p2:Point = new Point(0,0);
		
		
		public function moveTo(target:Itarget):void
		{
			p2.setTo(target.x,target.y);
			p1.setTo(x,y);
			var destance:int = MathUtil.distance(p1,p2);
			var moveLen:Number = Time.detal * speed ;
			var angle:Number = MathUtil.angle(p1,p2);
			this.x = x + moveLen * Math.cos(angle);
			this.y = y + moveLen * Math.sin(angle);
		}
		
		
		
		public function attack(target:Itarget,loseHp:int):void
		{
				target.loseHp(loseHp);
		}
		
		public function loseHp(loss:int):void
		{
			hp -= loss;
			checkDie();
		}
		
		public function addTo(parent:Sprite):void
		{
			parent.addChild(avatar);
		}
		
		public function dispose():void
		{
		
		
		}
	}
}