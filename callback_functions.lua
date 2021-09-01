local C = {}

function C.UseCard(card, fn)
	lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, p, ...)
		return fn(p)
	end, card)
end

return C
