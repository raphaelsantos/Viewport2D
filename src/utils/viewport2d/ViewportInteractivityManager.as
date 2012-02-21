package utils.viewport2d
{
	import flash.events.MouseEvent;

	public class ViewportInteractivityManager
	{

		private static var _instance:ViewportInteractivityManager
		private static var _singletonLock:Boolean=true;

		private var _interactiveViewports:Vector.<Viewport2D>

		public static function get instance():ViewportInteractivityManager
		{
			if (!_instance)
			{
				_singletonLock=false;
				_instance=new ViewportInteractivityManager();
				_singletonLock=true;
			}

			return _instance;
		}


		public function ViewportInteractivityManager()
		{
			if (_singletonLock)
				throw new Error("ViewportManager is a Singleton, use it's 'instance' property instead.");

			_interactiveViewports=new Vector.<Viewport2D>();
		}

		public function addViewport(viewport:Viewport2D):void
		{

			_interactiveViewports.push(viewport);


			viewport.addEventListener(MouseEvent.ROLL_OVER, viewportMouseRollHandler, false, 0, true);
			viewport.addEventListener(MouseEvent.ROLL_OUT, viewportMouseRollHandler, false, 0, true);
		}

		public function removeViewport(viewport:Viewport2D):void
		{
			var index:int=_interactiveViewports.indexOf(viewport);
			if (index != -1)
			{
				_interactiveViewports.splice(index, 1);
			}

			viewport.removeEventListener(MouseEvent.ROLL_OVER, viewportMouseRollHandler);
			viewport.removeEventListener(MouseEvent.ROLL_OUT, viewportMouseRollHandler);

		}

		private function viewportMouseRollHandler(e:MouseEvent):void
		{
			var viewport:Viewport2D=e.target as Viewport2D;

			if (e.type == MouseEvent.ROLL_OVER)
			{
				viewport.setInteractionFocus();
			}
			else
			{
				viewport.removeInteractionFocus();
			}
		}



	}
}
