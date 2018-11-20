-- Author: Stravant
-- Modified by: Austin Reuschle (Nimblz)

--[[
	class Signal

	Description:
		Lua-side duplication of the API of Events on Roblox objects. Needed for nicer
		syntax, and to ensure that for local events objects are passed by reference
		rather than by value where possible, as the BindableEvent objects always pass
		their signal arguments by value, meaning tables will be deep copied when that
		is almost never the desired behavior.

	API:
		void Fire(...)
			Fire the event with the given arguments.

		Connection Connect(Function handler)
			Connect a new handler to the event, returning a connection object that
			can be disconnected.

		... Wait()
			Wait for fire to be called, and return the arguments it was given.
--]]

local Signal = {}

function Signal.Create()
	local sig = setmetatable({},{__index = Signal})

	sig.mSignaler = Instance.new('BindableEvent')

	sig.mArgData = nil
    sig.mArgDataCount = nil

	return sig
end

function Signal:Fire(...)
	self.mArgData = {...}
	self.mArgDataCount = select('#', ...)
	self.mSignaler:Fire()
end

function Signal:Connect(f)
	if not f then error("connect(nil)", 2) end
	return self.mSignaler.Event:connect(function()
		f(unpack(self.mArgData, 1, self.mArgDataCount))
	end)
end

function Signal:Wait()
	self.mSignaler.Event:wait()
	assert(self.mArgData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
	return unpack(self.mArgData, 1, self.mArgDataCount)
end

-- Support legacy implementations
Signal.wait = Signal.Wait
Signal.connect = Signal.Connect
Signal.fire = Signal.Fire

return Signal