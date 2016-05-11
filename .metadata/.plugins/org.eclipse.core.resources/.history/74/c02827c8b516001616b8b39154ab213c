package com.starling.battle.view.component
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.VertexData;
	
	public class CustomImage extends DisplayObject
	{
		
		protected var mVertexData:VertexData; 
		
		protected var mIndexData:Vector.<uint>;
		
		protected var mVertexBuffer:VertexBuffer3D;
		protected var mIndexBuffer:IndexBuffer3D;
		
		protected var mTexture:Texture;
		
		protected var numTriangles:uint;
		
		private static var sProgramNameCache:Dictionary = new Dictionary();
		
		public function CustomImage()
		{
			createBuffers();
//			Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, 
//				onContextCreated, false, 0, true);
		}
		
		private function onContextCreated(event:*):void
		{
			createBuffers();
		}
		
		/** The texture that is displayed on the quad. */
		public function get texture():Texture { return mTexture; }
		public function set texture(value:Texture):void 
		{ 
			if (value == null)
			{
				throw new ArgumentError("Texture cannot be null");
			}
			else if (value != mTexture)
			{
				mTexture = value;
				mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha);
			}
		}
		
		public override function dispose():void
		{
			Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			if (mVertexBuffer) mVertexBuffer.dispose();
			if (mIndexBuffer)  mIndexBuffer.dispose();
			
			super.dispose();
		}
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if (resultRect == null) resultRect = new Rectangle();
			var transformationMatrix:Matrix = getTransformationMatrix(targetSpace);
			return mVertexData.getBounds(transformationMatrix, 0, -1, resultRect);
		}
		
		// code:
		protected function createBuffers():void
		{
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();
			
			if (mVertexBuffer) mVertexBuffer.dispose();
			if (mIndexBuffer)  mIndexBuffer.dispose();
			
			mVertexBuffer = context.createVertexBuffer(mVertexData.numVertices,VertexData.ELEMENTS_PER_VERTEX);
			mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
			
			mIndexBuffer = context.createIndexBuffer(mIndexData.length);
			mIndexBuffer.uploadFromVector(mIndexData, 0, mIndexData.length);
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			// always call this method when you write custom rendering code!
			// it causes all previously batched quads/images to render.
			support.finishQuadBatch(); // (1)
			
			// make this call to keep the statistics display in sync.
			support.raiseDrawCount(); // (2)
			
			var alphaVector:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, alpha * this.alpha];
			
			var context:Context3D = Starling.context; // (3)0
			if (context == null) throw new MissingContextError();
			
			// apply the current blendmode (4)
			support.applyBlendMode(false);
			
			// activate program (shader) and set the required attributes / constants (5)
			var p:Program3D = Starling.current.getProgram(getImageProgramName(true,mTexture.mipMapping,mTexture.repeat,mTexture.format))
			context.setProgram(p);
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, alphaVector, 1);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, support.mvpMatrix3D, true);   
			
			context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
			context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
			context.setTextureAt(0, mTexture.base);
			context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			
			// finally: draw the object! (6)
			context.drawTriangles(mIndexBuffer, 0, numTriangles);
			
			context.setTextureAt(0, null);
			context.setVertexBufferAt(2, null);
			
			// reset buffers (7)
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
		}
		
		
		protected static function getImageProgramName(tinted:Boolean, mipMap:Boolean=true, 
													  repeat:Boolean=false, format:String="bgra",
													  smoothing:String="bilinear"):String
		{
			var bitField:uint = 0;
			
			if (tinted) bitField |= 1;
			if (mipMap) bitField |= 1 << 1;
			if (repeat) bitField |= 1 << 2;
			
			if (smoothing == TextureSmoothing.NONE)
				bitField |= 1 << 3;
			else if (smoothing == TextureSmoothing.TRILINEAR)
				bitField |= 1 << 4;
			
			if (format == Context3DTextureFormat.COMPRESSED)
				bitField |= 1 << 5;
			else if (format == "compressedAlpha")
				bitField |= 1 << 6;
			
			var name:String = sProgramNameCache[bitField];
			
			if (name == null)
			{
				name = "QB_i." + bitField.toString(16);
				sProgramNameCache[bitField] = name;
			}
			
			return name;
		}
		
		
	}
}

