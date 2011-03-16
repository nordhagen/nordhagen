package com.oyvindnordhagen.animation {

	public class CrossFadeBanner {
		private var imageArray : Array;					//Array of mcs that must exist on timeline in the .fla-file
		private var intervalArray : Array;				//Array of intervals used to "wait" between fading the images

		private var speed : Number;
		private var waitInterval : Number;
		private var currentImageIndex : Number;

		public function CrossFadeBanner() {
			this.intervalArray = new Array();
			this.imageArray = new Array();
		}
		/*
		public function startCrossFadeBanner()
		{
			setAlphas();
			this.currentImageIndex = 0;
			this.waitInterval = setInterval(crossFade, this.intervalArray[this.currentImageIndex], this);
		}	
		
		private function crossFade(thisObj:CrossFadeBanner) {
		
			clearInterval(thisObj.waitInterval);
		
			var nextImageIndex:Number;
	
			if (thisObj.currentImageIndex + 1 < thisObj.imageArray.length)
				{
					nextImageIndex = thisObj.currentImageIndex + 1;
				}
				else
				{
					nextImageIndex = 0;
				}
	
			var mc1:MovieClip = thisObj.imageArray[thisObj.currentImageIndex];
			var mc2:MovieClip = thisObj.imageArray[nextImageIndex];
	
	
			mc1.onEnterFrame = function() {
	
				if (this._alpha > 0) 
	
				{
					this._alpha = this._alpha-thisObj.speed;
				}
				else 
				{
					this.onEnterFrame = null;
					delete this.onEnterFrame;
				}
	
			};
	
			mc2.onEnterFrame = function() {
	
				if (this._alpha<100)
				{
					this._alpha = this._alpha + thisObj.speed;
				}
				else 
				{
					this.onEnterFrame = null;
					delete this.onEnterFrame;
				}
				
			};
	
			thisObj.currentImageIndex = nextImageIndex;
			thisObj.reloadInterval();
		}
		
		private function reloadInterval():void
		{
			this.waitInterval = setInterval(crossFade, this.intervalArray[this.currentImageIndex], this);
		}
		
		private function setAlphas()
		{
			this.imageArray[0]._alpha = 100;
			for (var i=1; i < this.imageArray.length; i++)
			{
				this.imageArray[i]._alpha = 0;
			}
		}
		
		public function setBannerInfo(imgArray:Array, intArray:Array, fadeSpeed:Number)
		{
			this.imageArray = imgArray;
			this.intervalArray = intArray;
			this.speed = fadeSpeed;		
		} 
		*/	
	}
}
