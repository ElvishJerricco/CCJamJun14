Cinnamon
==========

An event based, modular, monitoring system. It comes default with power and system modules. It uses LuaLua to make everything object oriented, making code cleaner. It's designed to show any number of modules on any number of screens, even remote ones.

Modular
=======

In the modules folder, you will find files for each module. The modules are loaded through LuaLua's require function, so modules have to return something. That something in this case, is a class that subclasses Module and implements all the specific behavior for the module.

Modules have five methods

```
function (loadModule)
-- Load all things for the module, and make sure to set self.name

function (drawInWindow:win)
-- Draw the module in this particular window
-- Will be called for any screens displaying this module

function (update)
-- This function is here because the module is an event handler. Not really used for much in modules

function (respondToEvent:event)
-- Also only here because modules are event handlers. But this one can be used for quite a lot

function (navBarColors)
-- If a module would like to change the appearance of the nav bar when on this module's page,
-- override this method and return the desired colors
```

Event Based
===========

Any module can respond to any event. This allows a module to react to any event however it needs, and it can immediately display the results.

Any handlers added to the event manager need only implement two methods

```
function (update)
-- Called whenever a display update is requested.

function (respondToEvent:event)
-- Asks you to respond to an event. Return true if you'd like an update to result from this event, or false if you don't care
```

Usage
=====

Install via grin-get. Run cinnamon. Any monitors configured (via monitors.cfg) to display modules will begin showing the specified screen. Use the navigation buttons to switch screens on the fly.

This program can also display on remote screens. Use any computer capable of communicating with the main (server) computer via rednet. Put client.lua on that computer. Run client.lua <hostname>. Hostname is specified in server.cfg. Now the client computer will be used as a monitor, just like in-world monitors or the screen of the server computer.
