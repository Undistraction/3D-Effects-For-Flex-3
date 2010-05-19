package one.effects.effectClasses
{
	import flash.display.DisplayObject;

	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.EffectManager;
	import mx.effects.Tween;
	import mx.effects.effectClasses.TweenEffectInstance;
	import mx.styles.IStyleClient;

	import one.utils.ThreeDUtils;

	use namespace mx_internal

	public class Move3DEffectInstance extends TweenEffectInstance
	{

		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------

		public var xTo:Number;
		public var xFrom:Number;
		public var xBy:Number;

		public var yTo:Number;
		public var yFrom:Number;
		public var yBy:Number;

		public var zTo:Number;
		public var zFrom:Number;
		public var zBy:Number;

		public var useDistortionCompensation:Boolean = true;
		public var autoRemove3DMatrix:Boolean = true;

		private var component:UIComponent;

		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------

		public function Move3DEffectInstance( target:Object )
		{
			super( target );
			//Cache it here so we don't need to keep casting.
			component = target as UIComponent;
		}

		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------
        
        /**
         * @inheritDocs
         */
		override public function play():void
		{
			super.play();

			//Calling the method commented out below doesn't seem to have any effect on performance,
			//probably because when moving an object in 3D space, the player seems to render the 
			//Object as a Bitmap anyway (It uses Bitmap caching already). I've left it here in case 
			//you want to try yourself.
			//EffectManager.mx_internal::startBitmapEffect(IUIComponent(target));

			if  ( isNaN( xFrom ))
				xFrom = ( !isNaN( xTo ) && !isNaN( xBy )) ? xTo - xBy : target.x;

			if  ( isNaN( xTo ))
			{
				if  ( isNaN( xBy ) && propertyChanges && propertyChanges.end[ "x" ] !== undefined )
				{
					xTo = propertyChanges.end[ "x" ];
				}
				else
				{
					xTo = ( !isNaN( xBy )) ? xFrom + xBy : target.x;
				}
			}

			if  ( isNaN( yFrom ))
				yFrom = ( !isNaN( yTo ) && !isNaN( yBy )) ? yTo - yBy : target.y;

			if  ( isNaN( yTo ))
			{
				if  ( isNaN( yBy ) && propertyChanges && propertyChanges.end[ "y" ] !== undefined )
				{
					yTo = propertyChanges.end[ "y" ];
				}
				else
				{
					yTo = ( !isNaN( yBy )) ? yFrom + yBy : target.y;
				}
			}

			if  ( isNaN( zFrom ))
				zFrom = ( !isNaN( zTo ) && !isNaN( zBy )) ? zTo - zBy : target.z;

			if  ( isNaN( zTo ))
			{
				if  ( isNaN( zBy ) && propertyChanges && propertyChanges.end[ "z" ] !== undefined )
				{
					zTo = propertyChanges.end[ "z" ];
				}
				else
				{
					zTo = ( !isNaN( zBy )) ? zFrom + zBy : target.z;
				}
			}

			// Create a Tween object. The tween begins playing immediately.
			tween = createTween( this, [ xFrom, yFrom, zFrom ], [ xTo, yTo, zTo ], duration );

			if  ( useDistortionCompensation )
				compensateForDistortion();

			mx_internal::applyTweenStartValues();
		}

		/**
		 * @inheritDocs
		 */
		override public function onTweenUpdate( value:Object ):void
		{
			component.move( value[ 0 ], value[ 1 ]);
			component.z = value[ 2 ] as Number;
		}
        
        /**
         * @inheritDocs
         */
		override public function onTweenEnd( value:Object ):void
		{
            super.onTweenEnd( value );
            //I've left this here so you can try using it for performance gains.
            //EffectManager.mx_internal::endBitmapEffect(IUIComponent(target));

			if  ( value[ 2 ] as Number == 0 )
				remove3DMatrix();

			
			
		}

		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------

		private function compensateForDistortion():void
		{
			var distortionCompensationX:Number = component.width / ( target.width + .5 );
			var distortionCompensationY:Number = component.height / ( target.height + .5 );
			component.scaleX = distortionCompensationX;
			component.scaleY = distortionCompensationY;
		}

		private function remove3DMatrix():void
		{
			//Defer more complex checks to this method for optimisation. We must not remove the 3DMatrix if the 
			//DisplayObject is rotated around the X or Y axis. The Z axis is equivillant to a 2D rotation, so
			//that is ok.
			if  ( !autoRemove3DMatrix || component.rotationX != 0 || component.rotationY != 0 )
				return;

			ThreeDUtils.remove3DMatrix( component );

		}


	}
}
