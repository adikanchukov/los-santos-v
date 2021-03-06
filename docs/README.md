# Los Santos V Documentation

## Table of Contents
1. [Project Structure](#project-structure)
2. [Player Initialization](#player-initialization)
3. [Code Style](#code-style)
	1. [Module](#module)
	2. [Class](#class)
	3. [Script](#script)
4. [Networking Entities](#networking-entities)
5. [World Object Handling](#world-object-handling)

## Project Structure
Game mode resource is called `lsv-main` and located in `resources/[los-santos-v]` directory.

* `client/` contains client **scripts**
* `server/` contains server **scripts**
* `lib/` contains shared **modules** and **classes**
* `lib/client/` contains client **modules** and **classes**
* `lib/server/` contains server **modules** and **classes**

## Player Initialization
TriggerServerEvent(`lsv:loadPlayer`) ->
TriggerClientEvent(`lsv:playerLoaded`) ->
TriggerEvent(`lsv:init`), TriggerServerEvent(`lsv:playerInitialized`)

## Code Style
### Module
Module is a singleton object with public interface

```lua
-- Module declaration
Module = { }
Module.__index = Module

-- Module constants
Module.GLOBAL_CONST = 1

-- Module variables
Module.Token = nil

-- Logger
local logger = Logger.New('Module')

-- Local variables
local _wasInitialized = false

-- Local functions
local function generateToken()
	return '12345'
end

-- Module functions
function Module.Init()
	if _wasInitialized then
		return
	end

	local token = generateToken()
	Module.Token = token

	_wasInitialized = true
end

-- Threads
-- Event handlers
```

### Class
Class is a [class](https://en.wikipedia.org/wiki/Class_(computer_programming))

```lua
-- Class declaration
Class = { }
Class.__index = Class

-- Logger
-- Local variables
-- Local functions

-- Constructors
function Class.New(func)
	local self = { }
	setmetatable(self, Class)

	self._func = func

	return self
end

-- Class methods
function Class:foo(params)
	self._func(table.unpack({ params }))
end
```

### Script
Script is a file, which defines game event handling (`game mode` itself)

```lua
-- Logger
-- Local variables
local _isPlayerLoaded = false

-- Local functions
local function loadPlayer()
	_isPlayerLoaded = true
end

-- Net event handlers
RegisterNetEvent('resource:playerLoaded')
AddEventHandler('resource:playerLoaded', function()
	if not _isPlayerLoaded then
		TriggerEvent('resource:loadPlayer')
	end
end)

-- Threads

-- Event handlers
AddEventHandler('resource:loadPlayer', function()
	loadPlayer()
end)
```

### Networking Entities
*WIP module*

**Files**: `lib/client/network.lua`, `lib/server/network.lua`

Use `Network.CreatePed`/`Network.CreateVehicle` to create network entities (preload models first!)
You can attach additional shared data (`table`) to them.
These entities will be handled by server and shared across all game clients.

Always check for `NetworkDoesEntityExistWithNetworkId` before working with networked entity.
Use `Network.RequestEntityControl` for setters (`SET_ENTITY_SOMETHING` methods), not needed for getters (`GET_ENTITY_SOMETHING`) though (?).
Use `NetToPed`/`NetToVeh` to work with them like with local entities.

Use `Network.DeletePed`/`Network.DeleteVehicle` to delete networked entities.
You don't need to remove them manually after their creator was disconnected - it will be done by server (make it configurable?).

### World Object Handling
**File**: `lib/client/world.lua`

Use `World.AddPedHandler`/`World.AddVehicleHandler/World.AddObjectHandler` to do something with entities, which are available for your game client.
**Avoid doing heavy job in your handler, as it will affect game performance a lot!**

Use `World.DeleteEntity` to delete local entities.

You don't need to call `DoesEntityExist` while working with entities by using this module.
