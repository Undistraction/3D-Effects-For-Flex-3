package one.effects
{
	import mx.effects.IEffectInstance;
	import mx.effects.TweenEffect;

	import one.effects.effectClasses.Move3DEffectInstance;

	public class Move3DEffect extends TweenEffect
	{

		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------

		private const AFFECTED_PROPERTIES:Array = [ "x", "y", "z" ];

		public var xTo:Number;
		public var xFrom:Number;
		public var xBy:Number;

		public var yTo:Number;
		public var yFrom:Number;
		public var yBy:Number;

		public var zTo:Number;
		public var zFrom:Number;
		public var zBy:Number;

		/**
		 * Yet another of the bugs that Adobe must have known about but chose not
		 * to share with us developers, is the distortion that occurs when a
		 * DisplayObject is moved in 3D space. The distortion seems to involve the
		 * Bitmap rendering of the DisplayObject to increase in scale by 1px on the
		 * x and y axis. This means that the DisplayObject looks blury (especially text)
		 * and will appear to resize slightly if and when you remve the 3DMatrix when the
		 * DisplayObject is at 0,0,0. Setting this property to true means the effect will
		 * scale the DisplayObject to compensate for this distortion.
		 *
		 * @default true
		 */
		public var useDistortionCompensation:Boolean = true;

		/**
		 * Setting this property to true means that whenever the DisplayObject returns to a
		 * position of 0 on the z axis, it's 3DMatrix will be nulified and replaced by a
		 * standard 2DMatrix. This improves the rendering of the DisplayObject significantly.
		 *
		 * @defalt true
		 */
		public var autoRemove3DMatrix:Boolean = true;

		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------

		public function Move3DEffect( target:Object=null )
		{
			super( target );
			instanceClass = Move3DEffectInstance;
		}

		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------

        /**
         * @inheritDocs
         */
		override public function getAffectedProperties():Array
		{
			return AFFECTED_PROPERTIES;
		}

		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------

		/**
		 * @inheritDocs
		 */
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
			var effectInstance:Move3DEffectInstance = Move3DEffectInstance( instance );
			effectInstance.xTo = xTo;
			effectInstance.xFrom = xFrom;
			effectInstance.xBy = xBy;
			effectInstance.yTo = yTo;
			effectInstance.yFrom = yFrom;
			effectInstance.yBy = yBy;
			effectInstance.zTo = zTo;
			effectInstance.zFrom = zFrom;
			effectInstance.zBy = zBy;
		}
	}
}