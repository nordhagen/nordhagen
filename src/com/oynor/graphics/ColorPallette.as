package com.oynor.graphics
{
	import com.oynor.layout.GridGenerator;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author Oyvind Nordhagen
	 * @date 31. aug. 2010
	 */
	public class ColorPallette extends Sprite
	{
		private static const LABEL_COLOR:uint = 0x999999;
		private var _colors:Array;
		private var _width:uint;
		private var _height:uint;
		private var _chips:Array = [];
		private var _chipSize:uint;

		public function ColorPallette ( colors:Array , width:uint = 800 , height:uint = 600 , chipSize:uint = 100 )
		{
			_width = width;
			_height = height;
			_colors = colors;
			_chipSize = chipSize;
			_draw();
			_position();
		}

		private function _position () : void
		{
			var num:int = _chips.length;
			var positions:Array = GridGenerator.generatePositions( num , 100 , _chips[i].height , _width , 5 );
			for (var i:int = 0; i < num; i++)
			{
				var chip:Sprite = _chips[i];
				chip.x = positions[i][0];
				chip.y = positions[i][1];
			}
		}

		private function _draw () : void
		{
			var num:int = _colors.length;
			for (var i:int = 0; i < num; i++)
			{
				var chip:Sprite = _getChip( _colors[i] );
				addChild( chip );
				_chips.push( chip );
			}
		}

		private function _getChip ( color:Object ) : Sprite
		{
			var chip:Sprite = new Sprite();
			var label:TextField;
			var g:Graphics = chip.graphics;

			if (color is uint)
			{
				var uColor:uint = color as uint;
				g.beginFill( uColor );
				label = _getChipLabel( _getUintColorString( uColor ) );
			}
			else if (color is Array)
			{
				var aColor:Array = color as Array;
				var alphas:Array = [];
				var ratios:Array = [];
				var num:int = aColor.length;
				for (var i:int = 0; i < num; i++)
				{
					alphas.push( 1 );
					ratios.push( int( 255 / i ) );
				}

				var m:Matrix = new Matrix();
				m.createGradientBox( _chipSize , _chipSize , (Math.PI / 180) * 90 );
				g.beginGradientFill( GradientType.LINEAR , aColor , alphas , ratios , m );
				label = _getChipLabel( _getArrayColorString( aColor ) );
			}
			else
			{
				throw new ArgumentError( "Color must be either array of uints or array of arrays" );
			}


			g.drawRect( 0 , 0 , _chipSize , _chipSize );
			g.endFill();
			label.x = (_chipSize - label.width ) * 0.5;
			label.y = _chipSize + 3;
			chip.addChild( label );
			return chip;
		}

		private function _getChipLabel ( color:String ) : TextField
		{
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat( "_sans" , 10 , LABEL_COLOR );
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = color;
			return label;
		}

		private function _getUintColorString ( color:uint ):String
		{
			return "#" + color.toString( 16 ).toUpperCase();
		}

		private function _getArrayColorString ( color:Array ):String
		{
			return "#" + color[0].toString( 16 ).toUpperCase() + " - #" + color[color.length - 1].toString( 16 ).toUpperCase();
		}
	}
}
