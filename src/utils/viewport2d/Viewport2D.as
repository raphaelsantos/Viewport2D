package utils.viewport2d
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;


	public class Viewport2D extends Sprite
	{
		protected var _width:Number;
		protected var _height:Number;

		protected var _camera:Camera2D;
		protected var _canvas:DisplayObject;

		protected var _bmp:Bitmap;
		protected var _bmd:BitmapData;
		
		protected var _transparent:Boolean;
		protected var _backgroundColor:uint;

		private var _interactive:Boolean;

		private var _interactionContainer:Sprite;
		private var _hasInteractionFocus:Boolean=false;

		public function Viewport2D(width:Number, height:Number, camera:Camera2D, interactive:Boolean=false, transparent:Boolean = false)
		{
			_width=width;
			_height=height
			
			setCamera(camera);
			
			_transparent = transparent;
			this.interactive=interactive;
			
			backgroundColor = 0x000000;


			_bmd=new BitmapData(_width, _height, true, _backgroundColor);
			_bmp=new Bitmap(_bmd);

			addChild(_bmp);
		}

		public function render():void
		{
			_camera.update();

			var m:Matrix=_camera.getMatrix();

			m.translate((_width * .5) * (1 / scaleX), (_height * .5) * (1 / scaleY));
			m.tx=Math.round(m.tx);
			m.ty=Math.round(m.ty);

			_bmd.fillRect(_bmd.rect, _backgroundColor);
			_bmd.draw(Sprite(_camera.getCanvas()), m);

			if (_interactive && _hasInteractionFocus)
			{
				_canvas.transform.matrix=m;
			}
		}

		public function setCamera(camera:Camera2D):void
		{
			_camera=camera;
			_canvas=camera.getCanvas();
		}

		internal function setInteractionFocus():void
		{

			_interactionContainer=new Sprite();
			addChild(_interactionContainer);

			var interactionMask:Sprite=new Sprite();
			addChild(interactionMask);
			interactionMask.graphics.beginFill(0x000000);
			interactionMask.graphics.drawRect(0, 0, _width, _height);
			interactionMask.graphics.endFill();
			_interactionContainer.mask=interactionMask;

			_interactionContainer.addChild(_canvas);
			_hasInteractionFocus=true;
			stage.invalidate();
		}

		internal function removeInteractionFocus():void
		{
			if (_canvas.parent == _interactionContainer)
			{
				_interactionContainer.removeChild(_canvas)
			}
			_hasInteractionFocus=false;
		}

		public function set interactive(value:Boolean):void
		{
			_interactive=value;
			if (_interactive)
			{
				ViewportInteractivityManager.instance.addViewport(this);
			}
			else
			{
				ViewportInteractivityManager.instance.removeViewport(this);
			}
		}

		public function get interactive():Boolean
		{
			return _interactive;
		}
		
		public function set transparent(value:Boolean):void
		{
			_transparent = value;
			backgroundColor = _backgroundColor;
		}
		
		public function get transparent():Boolean
		{
			return _transparent;
		}
		
		public function set backgroundColor(value:uint):void
		{
			var alphaChannel:uint = _transparent? 0x00 : 0xFF;
			_backgroundColor = alphaChannel <<24 | ( value & 0x00FFFFFF);
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;	
		}
	}
}
