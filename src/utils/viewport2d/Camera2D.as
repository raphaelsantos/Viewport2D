package utils.viewport2d  
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	public class Camera2D 
	{
		
		private const DEFAULT_DISTANCE:Number = 1;
		
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		
		private var _xOffset:Number = 0;
		private var _yOffset:Number = 0;
		
		private var _rotationOffset:Number = 0;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _followTarget:Object;
		private var _alignRotation:Boolean;
		
		private var _zoom:Number = 1;
		private var _distance:Number;
		
		private var _rotation:Number = 0;
		
		private var _canvas:DisplayObject;
		
		
		public function Camera2D(canvas:DisplayObject) {
			_canvas = canvas;
			_width = canvas.width;
			_height = canvas.height;
			
			_distance = DEFAULT_DISTANCE;
		}

	
		public function follow(obj:DisplayObject, offsetX:Number = 0, offsetY:Number = 0, 
							   alignRotation:Boolean =false, rotationOffset:Number=0):void
		{
			_followTarget = obj;
			
			_xOffset = offsetX;
			_yOffset = offsetY
			
			_alignRotation = alignRotation
			_rotationOffset = rotationOffset
		}
		
		public function followPoint(obj:Point, offsetX:Number = 0, offsetY:Number = 0):void
		{
			_followTarget = obj;
			
			_xOffset = offsetX;
			_yOffset = offsetY
				
			_alignRotation = false;
			_rotationOffset = 0;
		}
		
		public function stop():void
		{
			_followTarget = null;
			_alignRotation = false;
		}
		
		//TODO: needs reworking
		
		/*public function fitObject(obj:DisplayObject):void
		{
			stop();
			x = obj.x;
			y = obj.y;
			
			var heightRatio:Number = _height/obj.height;
			var widthRatio:Number = _width / obj.width;
			
			_distance = DEFAULT_DISTANCE * 1/Math.max(heightRatio, widthRatio);
		}*/
		
		public function multiplyZoom(zoomMultiplier:Number):void
		{
			_zoom *= zoomMultiplier
			_distance = DEFAULT_DISTANCE * (1 / _zoom);
		}
		
		
		
		public function set zoom(value:Number):void
		{
			_zoom = value;
			_distance = DEFAULT_DISTANCE * (1/value);
		}
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set distance(distance:Number):void
		{
			_distance = distance;
		}
		
		public function get distance():Number
		{
			return _distance
		}
		

		public function set rotation(value:Number):void
		{
			_rotation = value +_rotationOffset;
		}
		
		
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		
		internal function update():void
		{
			if (_followTarget) {
				var obj:Object= _followTarget;
				
				_alignRotation? rotation = _followTarget.rotation  :  null;
				
				var rad1:Number = Math.atan2(obj.y, obj.x)
				
				var d:Number = Math.sqrt(obj.x * obj.x + obj.y * obj.y);
				
				x = Math.cos( rad1) * d;
				y = Math.sin( rad1) * d;

			}
		}
	
		
		internal function getCanvas():DisplayObject 
		{
			return _canvas;
		}
		
		internal function getMatrix():Matrix 
		{
			var m:Matrix = new Matrix();
			
			m.scale(scaleDistance, scaleDistance);
			m.translate( -x +_xOffset, -y +_yOffset );
			m.rotate( ( -rotation) * Math.PI / 180);
			m.translate(_xOffset, _yOffset);
			
			return m;
		}
	
		internal function get scaleDistance():Number
		{
			return 1 / (_distance / DEFAULT_DISTANCE);
		}
		
		public function set x(value:Number):void
		{
			_x = value* scaleDistance;
		}
		
		
		public function get x():Number
		{
			return _x +_xOffset;
		}
		
		public function set y(value:Number):void
		{
			_y = value* scaleDistance;
		}
		
		public function get y():Number
		{
			return _y +_yOffset;
		}
	}
}