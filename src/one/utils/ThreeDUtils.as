package one.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	public class ThreeDUtils
	{
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------

		/**
		 * Substitute a standard 2D Matrix for the DisplayObject's 3D Matrix.
		 * This will improve the DisplayObject's appearance, but should only be done when the
		 * DisplayObject is no longer in 3D space ie. it is at 0 on its z axis and not rotated 
         * around the x or y axis.
		 *
		 * @param target
		 */
		public static function remove3DMatrix( target:DisplayObject ):void
		{
			var matrix:Matrix = new Matrix();
			var rotationInRadians:Number = Math.PI * target.rotationZ / 180;
			//Order is important. Rotate THEN Translate
			matrix.rotate( rotationInRadians );
			matrix.translate( target.x, target.y );
			target.transform.matrix3D = null;
			target.transform.matrix = matrix;
		}

	}
}