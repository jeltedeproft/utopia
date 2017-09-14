function dropcoin(keys)
	local caster = keys.caster
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local targetdroppoint = origin + forward

	--local goldbag = CreateUnitByName("item_bag_of_gold", targetdroppoint, true, nil, nil, teamnumber)
	print("1")
	local newItem = CreateItem( "item_bag_of_gold_goofy", nil, nil )
	print("2")
	local drop = CreateItemOnPositionForLaunch( targetdroppoint, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, targetdroppoint + RandomVector( 50 ) )
end




