function laughsound(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	caster:EmitSound("goofylaugh")

	Timers:CreateTimer(duration, function ()
	        caster:StopSound("goofylaugh")
	end)
end

function stoplaughsound(keys)
	local caster = keys.caster
	local ability = keys.ability

	caster:StopSound("goofylaugh")
end