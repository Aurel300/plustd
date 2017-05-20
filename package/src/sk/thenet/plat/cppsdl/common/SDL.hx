package sk.thenet.plat.cppsdl.common;

#if cpp

import haxe.ds.Vector;
import sk.thenet.bmp.Colour;

@:build(sk.thenet.plat.cppsdl.common.SDLMacro.master())
extern class SDL {
  // flags
  @:native("SDL_INIT_TIMER") static var INIT_TIMER(default, null):cpp.UInt32;
  @:native("SDL_INIT_AUDIO") static var INIT_AUDIO(default, null):cpp.UInt32;
  @:native("SDL_INIT_VIDEO") static var INIT_VIDEO(default, null):cpp.UInt32;
  @:native("SDL_INIT_JOYSTICK") static var INIT_JOYSTICK(default, null):cpp.UInt32;
  @:native("SDL_INIT_HAPTIC") static var INIT_HAPTIC(default, null):cpp.UInt32;
  @:native("SDL_INIT_GAMECONTROLLER") static var INIT_GAMECONTROLLER(default, null):cpp.UInt32;
  @:native("SDL_INIT_EVENTS") static var INIT_EVENTS(default, null):cpp.UInt32;
  @:native("SDL_INIT_EVERYTHING") static var INIT_EVERYTHING(default, null):cpp.UInt32;
  @:native("SDL_INIT_NOPARACHUTE") static var INIT_NOPARACHUTE(default, null):cpp.UInt32;
  
  @:native("SDL_WINDOW_OPENGL") static var WINDOW_OPENGL(default, null):cpp.UInt32;
  
  @:native("SDL_RENDERER_SOFTWARE") static var RENDERER_SOFTWARE(default, null):cpp.UInt32;
  @:native("SDL_RENDERER_ACCELERATED") static var RENDERER_ACCELERATED(default, null):cpp.UInt32;
  @:native("SDL_RENDERER_PRESENTVSYNC") static var RENDERER_PRESENTVSYNC(default, null):cpp.UInt32;
  @:native("SDL_RENDERER_TARGETTEXTURE") static var RENDERER_TARGETTEXTURE(default, null):cpp.UInt32;
  
  // enums
  @:native("SDL_KEYDOWN") static var KEYDOWN(default, never):EventType;
  @:native("SDL_KEYUP") static var KEYUP(default, never):EventType;
  @:native("SDL_MOUSEMOTION") static var MOUSEMOTION(default, never):EventType;
  @:native("SDL_MOUSEBUTTONDOWN") static var MOUSEBUTTONDOWN(default, never):EventType;
  @:native("SDL_MOUSEBUTTONUP") static var MOUSEBUTTONUP(default, never):EventType;
  @:native("SDL_QUIT") static var QUIT(default, never):EventType;
  @:native("AUDIO_F32") static var AUDIO_F32:AudioFormat;
  @:native("SDL_PIXELFORMAT_ARGB8888") static var PIXELFORMAT_ARGB8888(default, null):PixelFormatEnum;
  @:native("SDL_PIXELFORMAT_RGBA8888") static var PIXELFORMAT_RGBA8888(default, null):PixelFormatEnum;
  @:native("SDL_TEXTUREACCESS_STATIC") static var TEXTUREACCESS_STATIC(default, null):TextureAccess;
  @:native("SDL_TEXTUREACCESS_STREAMING") static var TEXTUREACCESS_STREAMING(default, null):TextureAccess;
  @:native("SDL_TEXTUREACCESS_TARGET") static var TEXTUREACCESS_TARGET(default, null):TextureAccess;
  
  // ints?
  @:native("SDL_BLENDMODE_NONE") static var BLENDMODE_NONE(default, null):BlendMode;
  @:native("SDL_BLENDMODE_BLEND") static var BLENDMODE_BLEND(default, null):BlendMode;
  @:native("SDL_BLENDMODE_ADD") static var BLENDMODE_ADD(default, null):BlendMode;
  @:native("SDL_BLENDMODE_MOD") static var BLENDMODE_MOD(default, null):BlendMode;
  
  @:native("SDL_WINDOWPOS_CENTERED") static var WINDOWPOS_CENTERED(default, null):Int;
  @:native("SDL_WINDOWPOS_UNDEFINED") static var WINDOWPOS_UNDEFINED(default, null):Int;
  
  // init
  @:native("SDL_Init") static function init(flags:cpp.UInt32):Int;
  @:native("SDL_InitSubSystem") static function initSubSystem(flags:cpp.UInt32):Int;
  
  // methods
  @:native("SDL_BlitSurface") static function blitSurface(src:SurfacePointer, srcrect:RectPointer, dst:SurfacePointer, dstrect:RectPointer):RendererPointer;
  @:native("SDL_CloseAudioDevice") static function closeAudioDevice(device:Int):Void;
  @:native("SDL_ConvertSurfaceFormat") static function convertSurfaceFormat(src:SurfacePointer, pixel_format:PixelFormatEnum, flags:cpp.UInt32):SurfacePointer;
  @:native("SDL_CreateRenderer") static function createRenderer(win:WindowPointer, index:Int, flags:cpp.UInt32):RendererPointer;
  @:native("SDL_CreateRGBSurface") static function createRGBSurface(flags:cpp.UInt32, w:Int, h:Int, depth:Int,
    rmask:cpp.UInt32, gmask:cpp.UInt32, bmask:cpp.UInt32, amask:cpp.UInt32):SurfacePointer;
  @:native("SDL_CreateSoftwareRenderer") static function createSoftwareRenderer(surface:SurfacePointer):RendererPointer;
  @:native("SDL_CreateTexture") static function createTexture(renderer:RendererPointer, format:PixelFormatEnum, access:TextureAccess, w:Int, h:Int):TexturePointer;
  @:native("SDL_CreateTextureFromSurface") static function createTextureFromSurface(renderer:RendererPointer, surface:SurfacePointer):TexturePointer;
  @:native("SDL_CreateWindow") static function createWindow(title:cpp.ConstCharStar, x:Int, y:Int, w:Int, h:Int, flags:cpp.UInt32):WindowPointer;
  @:native("SDL_Delay") static function delay(ms:cpp.UInt32):Void;
  @:native("SDL_DestroyTexture") static function destroyTexture(texture:TexturePointer):Void;
  @:native("SDL_FillRect") static function fillRect(surface:SurfacePointer, rect:RectPointer, color:cpp.UInt32):Void;
  @:native("SDL_FreeSurface") static function freeSurface(surface:SurfacePointer):Void;
  @:native("SDL_GetClipRect") static function getClipRect(surface:SurfacePointer, rect:RectPointer):Void;
  @:native("SDL_GetError") static function getError():cpp.ConstCharStar;
  @:native("SDL_LockSurface") static function lockSurface(surface:SurfacePointer):Int;
  @:native("SDL_LockTexture") static function lockTexture(texture:TexturePointer, rect:RectPointer, dest:Dynamic, pitch:cpp.Reference<Int>):Int;
  @:native("SDL_LoadBMP") static function loadBMP(file:cpp.ConstCharStar):SurfacePointer;
  @:native("SDL_MUSTLOCK") static function mustLock(surface:SurfacePointer):Bool;
  @:native("SDL_OpenAudioDevice") static function openAudioDevice(device:cpp.ConstCharStar, iscapture:Int, desired:AudioSpecPointer, obtained:AudioSpecPointer, changes:Int):Int;
  @:native("SDL_PauseAudioDevice") static function pauseAudioDevice(device:Int, pause:Int):Void;
  @:native("SDL_PollEvent") static function pollEvent(event:EventPointer):Int;
  @:native("SDL_Quit") static function quit():Void;
  @:native("SDL_RenderClear") static function renderClear(renderer:RendererPointer):Int;
  @:native("SDL_RenderCopy") static function renderCopy(renderer:RendererPointer, texture:TexturePointer, srcRect:RectPointer, dstRect:RectPointer):Int;
  @:native("SDL_RenderFillRect") static function renderFillRect(renderer:RendererPointer, rect:RectPointer):Int;
  @:native("SDL_RenderPresent") static function renderPresent(renderer:RendererPointer):Void;
  @:native("SDL_RenderReadPixels") static function renderReadPixels(renderer:RendererPointer, rect:RectPointer, format:Int, pixels:cpp.Star<Dynamic>, pitch:Int):Int;
  @:native("SDL_RWFromConstMem") static function RWFromConstMem(src:cpp.Pointer<cpp.UInt8>, size:Int):RWOpsPointer;
  @:native("SDL_RWFromFile") static function RWFromFile(file:String, mode:String):RWOpsPointer;
  @:native("SDL_RWclose") static function RWclose(rw:RWOpsPointer):Void;
  @:native("SDL_RWread") static function RWread(rw:RWOpsPointer, dest:cpp.Pointer<cpp.UInt8>, size:Int, maxnum:Int):Int;
  @:native("SDL_RWsize") static function RWsize(rw:RWOpsPointer):Int;
  @:native("SDL_SetRenderDrawColor") static function setRenderDrawColor(renderer:RendererPointer, r:UInt, g:UInt, b:UInt, a:UInt):Int;
  @:native("SDL_SetRenderTarget") static function setRenderTarget(renderer:RendererPointer, texture:TexturePointer):Int;
  @:native("SDL_SetSurfaceBlendMode") static function setSurfaceBlendMode(surface:SurfacePointer, blendMode:BlendMode):Int;
  @:native("SDL_SetTextureBlendMode") static function setTextureBlendMode(texture:TexturePointer, blendMode:BlendMode):Int;
  @:native("SDL_UnlockSurface") static function unlockSurface(surface:SurfacePointer):Void;
  @:native("SDL_UnlockTexture") static function unlockTexture(texture:TexturePointer):Void;
  @:native("SDL_UpdateTexture") static function updateTexture(texture:TexturePointer, rect:RectPointer, pixels:cpp.Star<Dynamic>, pitch:Int):Void;
  @:native("SDL_zero") static function zero(struct:cpp.Pointer<cpp.Void>):Void;
}

extern class Image {
  // flags
  @:native("IMG_INIT_PNG") static var INIT_PNG(default, null):cpp.UInt32;
  
  // init
  @:native("IMG_Init") static function init(flags:cpp.UInt32):Int;
  
  // functions
  @:native("IMG_Load") static function load(file:cpp.ConstCharStar):SurfacePointer;
  @:native("IMG_LoadPNG_RW") static function loadPNG_RW(rwops:RWOpsPointer):SurfacePointer;
}

extern class Mixer {
  // flags
  @:native("MIX_INIT_FLAC") static var INIT_FLAC(default, null):cpp.UInt32;
  @:native("MIX_INIT_MOD") static var INIT_MOD(default, null):cpp.UInt32;
  @:native("MIX_INIT_MP3") static var INIT_MP3(default, null):cpp.UInt32;
  @:native("MIX_INIT_OGG") static var INIT_OGG(default, null):cpp.UInt32;
  
  // init
  @:native("Mix_Init") static function init(flags:cpp.UInt32):Int;
  
  // functions
  @:native("Mix_ChannelFinished") static function channelFinished(callback:cpp.Callable<Int->Void>):Void;
  @:native("Mix_GetError") static function getError():cpp.ConstCharStar;
  @:native("Mix_HaltChannel") static function haltChannel(channel:Int):Int;
  @:native("Mix_LoadWAV_RW") static function loadWAV_RW(rwops:RWOpsPointer, freesrc:Int):MixChunkPointer;
  @:native("Mix_OpenAudio") static function openAudio(frequency:Int, format:cpp.UInt16, channels:Int, chunksize:Int):Int;
  @:native("Mix_PlayChannel") static function playChannel(channel:Int, chunk:MixChunkPointer, loops:Int):Int;
}

/*
abstract InitFlag(cpp.UInt32) {
  @:op(A|B) static function _(a:InitFlag, b:InitFlag):InitFlag;
}

abstract CreateWindowFlag(cpp.UInt32) {
  @:op(A|B) static function _(a:CreateWindowFlag, b:CreateWindowFlag):CreateWindowFlag;
}

abstract CreateRendererFlag(cpp.UInt32) {
  @:op(A|B) static function _(a:CreateRendererFlag, b:CreateRendererFlag):CreateRendererFlag;
}
*/
//@:native("SDL_EventType") extern class EventType {}
@:native("SDL_AudioFormat") extern class AudioFormat {}
abstract EventType(cpp.UInt32) {}
@:native("SDL_PixelFormatEnum") extern class PixelFormatEnum {}
@:native("SDL_TextureAccess") extern abstract TextureAccess(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {}
@:native("SDL_BlendMode") extern class BlendMode {}

@:native("::cpp::Reference<SDL_AudioSpec>") extern class AudioSpecPointer {
  public var freq:Int;
  public var format:AudioFormat;
  public var channels:cpp.UInt8;
  public var silence:cpp.UInt8;
  public var samples:cpp.UInt16;
  public var size:cpp.UInt32;
  public var callback:cpp.Callable<cpp.Pointer<cpp.Void>->cpp.Pointer<cpp.UInt8>->Int->Void>;
//  public var callback:cpp.Callable<Int->cpp.Star<cpp.UInt8>->Int->Void>;
  //public var userdata:Int;
  public var userdata:cpp.Pointer<cpp.Void>;
}
@:native("SDL_Event") extern class Event {}
@:native("::cpp::Reference<SDL_Event>") extern class EventPointer {}
@:native("::cpp::Reference<Mix_Chunk>") extern class MixChunkPointer {
  public var allocated:Int;
  public var abuf:cpp.Pointer<cpp.UInt8>;
  public var alen:cpp.UInt32;
  public var volume:cpp.UInt8;
}
@:native("::cpp::Reference<SDL_Rect>") extern class RectPointer {
  public var x:Int;
  public var y:Int;
  @:native("w") public var width:Int;
  @:native("h") public var height:Int;
}
@:native("::cpp::Reference<SDL_Renderer>") extern class RendererPointer {}
@:native("::cpp::Reference<SDL_RWops>") extern class RWOpsPointer {}
@:native("::cpp::Reference<SDL_Surface>") extern class SurfacePointer {
  @:native("w") public var width:Int;
  @:native("h") public var height:Int;
  public var pixels:cpp.Pointer<cpp.Void>;
  public var pitch:cpp.UInt16;
}
@:native("::cpp::Reference<SDL_Texture>") extern class TexturePointer {}
@:native("::cpp::Reference<SDL_Window>") extern class WindowPointer {}
@:native("::cpp::Reference<void*>") extern class VoidPointer {}

#end
