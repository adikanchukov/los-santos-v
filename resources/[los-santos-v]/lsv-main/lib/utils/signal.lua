local _signals = { }

function TriggerSignal(name, ...)
	local signalHandlers = _signals[name]
	if not signalHandlers then
		return
	end

	local args = { ... }
	table.iforeach(signalHandlers, function(handlerFunc)
		xpcall(function() handlerFunc(table.unpack(args)) end, function(error)
			print('SCRIPT ERROR: '..error)
		end)
	end)
end

function AddSignalHandler(name, handlerFunc)
	if not _signals[name] then
		_signals[name] = { }
	end

	table.insert(_signals[name], handlerFunc)
end
