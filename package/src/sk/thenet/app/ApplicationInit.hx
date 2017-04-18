package sk.thenet.app;

/**
##Aplication - System initialisers##

Values of this enum should be passed to the constructor of
`sk.thenet.app.Application` to initialise the relevant systems. The application
uses the `init` functions of `sk.thenet.plat.Platform` under the hood. See
`sk.thenet.plat.Platform` for the descriptions of the parameters to the enum
constructors below.

@see `sk.thenet.plat.Platform`
 */
enum ApplicationInit {
  Assets(assets:Array<Asset>);
  Console;
  ConsoleRemote(host:String, port:Int);
  Framerate(fps:Float);
  Keyboard;
  Mouse;
  Surface(width:Int, height:Int, scale:Int);
  Window(title:String, width:Int, height:Int);
}
