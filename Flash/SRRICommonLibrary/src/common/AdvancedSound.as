﻿package common{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	public class AdvancedSound extends EventDispatcher{
		
		private static const TICK_TIME:int = 40; //40 miliseconds between each timer tick on fade out. Roughly equivolent to 24fps.
		
		private var sound:Sound;	// the sound file.
		
		private var _channel:SoundChannel = new SoundChannel();
		private var _volume:Number = 1;
		private var fadeTimer:Timer; // used to fade out the sound
		private var ticker:int;	// counts for fading.
		private var ticksToComplete:int; // how many ticks must elapse to meet a certain duration. 
		private var soundID:String;

		private var _isPlaying:Boolean = false;		
		private var percentageCounter:Timer = new Timer(1, 1); // used to dispatch events based on percentage reached
		
		private var startPosition:Number = 0; //records the starting positon in ms for fading in this sound. 
											 //changed every time a fadeIn is called; if no start position 
											 //is passed to fadeIn, gets set to 0. 

		public function AdvancedSound(s:Sound){
			sound = s;
			soundID = String(Math.round(Math.random()*1000)/1000) //random ID truncated to .000 places
		}
		
		//setters and getters
		public function getChannel():SoundChannel{
			return _channel;
		}
		
		public function getLength():Number{
			return sound.length;
		}
		
		public function setStartPosition(sp:Number):void{
			startPosition = sp;
		}
		
		public function getStartPosition():Number{
			return startPosition;
		}
		
		public function isPlaying():Boolean{
			return _isPlaying;
		}
		
		
		
		// works exactly like sound.play
		public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel{
			_channel.stop();
			_channel = sound.play(startTime, loops, sndTransform);
			percentageCounter.reset();
			percentageCounter.start();
			_isPlaying = true;
			return _channel;
		}
		
		// stops & resets the sound
		public function stop():SoundChannel{
			_channel.stop();	
			percentageCounter.stop();
			_isPlaying = false;
			return _channel;
		}
				
		public function fadeOut(duration:Number = 1000):void{
			trace("fadeOut ID:" + soundID + " Sound:" + sound.toString());
			if(duration < 1)
				throw new Error("fade duration must be longer than 1 millisecond.");
				
			ticksToComplete = Math.ceil(duration/40);
			
			ticker = ticksToComplete;
			fadeTimer = new Timer(TICK_TIME, ticksToComplete);
			fadeTimer.addEventListener(TimerEvent.TIMER, tickFadeOut);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cleanFadeOut);
			fadeTimer.start();
		}
		
		public function fadeIn(duration:Number = 1000, numLoops:int = 0, startPos:Number = 0):void{
			trace("fadeIn ID:" + soundID + " Sound:" + sound.toString());
			
			if(startPos != 0){
				trace("start position: " + startPos); // for debugging
			}
			
			if(duration < 1)
				throw new Error("fade duration must be longer than 1 millisecond.");
				
			ticksToComplete = Math.ceil(duration/40);
			
			ticker = 0;
			fadeTimer = new Timer(TICK_TIME, ticksToComplete);
			fadeTimer.addEventListener(TimerEvent.TIMER, tickFadeIn);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cleanFadeIn);
			fadeTimer.start();
			
			_volume = 0;
			startPosition = startPos; 
			_channel = play(startPos, numLoops, null);
		}
		
		private var _toDoFunction:Function = function():void{};
		
		public function doOnPercentPlayed(arg:Number, func:Function):void{
			if(arg < 0 || arg > 1)
				throw new Error("Percent must range from 0 to 1.");
			
			var percentLength:int = arg * (sound.length-startPosition);
			
			if(_isPlaying){
					throw new Error("Cannot add function to an already playing sound.");
			}
			percentageCounter = new Timer(percentLength, 1);
			
			_toDoFunction = func;
			percentageCounter.addEventListener(TimerEvent.TIMER_COMPLETE, notifyInner);
		}		
		
		private function notifyInner(e:Event):void{
			_toDoFunction(e);
		}
		
		private function tickFadeOut(e:Event):void{
			ticker--;
			innerTick();
		}
		
		private function cleanFadeOut(e:Event):void{
			fadeTimer.removeEventListener(TimerEvent.TIMER, tickFadeOut);
			fadeTimer.removeEventListener(TimerEvent.TIMER, cleanFadeOut);	
			_volume = 0;
			stop();
		}
		
		private function tickFadeIn(e:Event):void{
			ticker++;
			innerTick();
		}
		
		private function cleanFadeIn(e:Event):void{
			fadeTimer.removeEventListener(TimerEvent.TIMER, tickFadeIn);
			fadeTimer.removeEventListener(TimerEvent.TIMER, cleanFadeIn);
			_volume = 1;
			dispatchEvent(new AdvancedSoundEvent(AdvancedSoundEvent.FULL_VOL));
		}
		
		// sets the volume based on ticker & ticksToComplete
		private function innerTick():void{
			_volume = ticker/ticksToComplete;
			var st:SoundTransform = _channel.soundTransform;
			st.volume = _volume;
			_channel.soundTransform = st;
		}
	}
}