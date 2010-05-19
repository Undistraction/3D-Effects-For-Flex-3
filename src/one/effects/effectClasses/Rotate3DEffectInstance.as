package one.effects.effectClasses
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Tween;
	import mx.effects.effectClasses.TweenEffectInstance;
	
	import one.utils.ThreeDUtils;

	public class Rotate3DEffectInstance extends TweenEffectInstance
	{
        
        //----------------------------------------------------------------------------------
        //
        //   Properties
        // 
        //----------------------------------------------------------------------------------

        public var rotationXTo: Number;
        public var rotationXFrom: Number;
        
        public var rotationYTo: Number;
        public var rotationYFrom: Number;
        
        public var rotationZTo: Number;
        public var rotationZFrom: Number;
        
        public var useDistortionCompensation:Boolean = true;
        public var autoRemove3DMatrix:Boolean = true;
        
        private var component:UIComponent;
        
        //----------------------------------------------------------------------------------
        //
        //   Methods
        // 
        //----------------------------------------------------------------------------------
        
		public function Rotate3DEffectInstance( target: Object )
		{
			super( target );
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
            
            var radVal:Number = Math.PI * target.rotation / 180;		
            
            if(isNaN(rotationXFrom))
                rotationXFrom = target.rotationX;
            
            if(isNaN(rotationXTo)){
                rotationXTo = (target.rotationX == 0) ? 
                    ((rotationXFrom > 180) ? 360 : 0) : 
                    target.rotationX;
            }
            
            if(isNaN(rotationYFrom))
                rotationYFrom = target.rotationY;
            
            if(isNaN(rotationYTo)){
                rotationYTo = (target.rotationY == 0) ? 
                    ((rotationYFrom > 180) ? 360 : 0) : 
                    target.rotationY;
            }
            
            if(isNaN(rotationZFrom))
                rotationZFrom = target.rotationZ;
            
            if(isNaN(rotationZTo)){
                rotationZTo = (target.rotationZ == 0) ? 
                    ((rotationZFrom > 180) ? 360 : 0) : 
                    target.rotationZ;
            }
           
            tween = createTween( this, [rotationXFrom, rotationYFrom, rotationZFrom], [rotationXTo, rotationYTo, rotationZTo], duration );
            
            if(useDistortionCompensation)
                compensateForDistortion();
            
            mx_internal::applyTweenStartValues();
        }
        
        /**
         * @inheritDocs
         */
		override public function onTweenUpdate( value: Object ): void
		{
			component.rotationX = value[0] as Number;
            component.rotationY = value[1] as Number;
            component.rotationZ = value[2] as Number;
		}
        
        /**
         * @inheritDocs
         */
		override public function onTweenEnd( value: Object ): void
		{
            super.onTweenEnd( value );
            
            if(value[0] as Number == 0 && value[1] as Number == 0)
                remove3DMatrix();
            
            
		}
        
        //----------------------------------------------------------------------------------
        //  Internal
        //----------------------------------------------------------------------------------
        
        private function compensateForDistortion():void{
            var distortionCompensationX:Number = component.width/(target.width+.5);
            var distortionCompensationY:Number = component.height/(target.height+.5);
            component.scaleX = distortionCompensationX;
            component.scaleY = distortionCompensationY;
        }
        
        private function remove3DMatrix():void{
            //Defer more complex checks to this method for optimisation. We must not remove the 3DMatrix if the 
            //DisplayObject is rotated around the X or Y axis. The Z axis is equivillant to a 2D rotation, so
            //that is ok.
            if(!autoRemove3DMatrix || component.z != 0)
                return;
            ThreeDUtils.remove3DMatrix(component);
        }

	}
}
