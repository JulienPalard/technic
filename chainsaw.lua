chainsaw_max_charge=30000

minetest.register_tool("technic:chainsaw", {
	description = "Chainsaw",
	inventory_image = "technic_chainsaw.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" then 
		item=itemstack:to_table()
		local charge=tonumber((item["wear"])) 
		if charge ==0 then charge =65535 end
		charge=get_RE_item_load(charge,mining_drill_max_charge)
		charge_to_take=600;
		if charge-charge_to_take>0 then
		 charge_to_take=chainsaw_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user,charge_to_take)
		 charge=charge-charge_to_take;	
		charge=set_RE_item_load(charge,mining_drill_max_charge)
		item["wear"]=tostring(charge)
		itemstack:replace(item)
		end
		return itemstack
		end
	end,
})

minetest.register_craft({
	output = 'technic:chainsaw',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:battery'},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:battery'},
		{'','','moreores:copper_ingot'},
	}
})




timber_nodenames={"default:jungletree", "default:papyrus", "default:cactus", "default:tree"}

function chainsaw_dig_it (pos, player,charge_to_take)		
	charge_to_take=0
	local node=minetest.env:get_node(pos)
	local i=1
	while timber_nodenames[i]~=nil do
		if node.name==timber_nodenames[i] then
			charge_to_take=600
			np={x=pos.x, y=pos.y, z=pos.z}
			while minetest.env:get_node(np).name==timber_nodenames[i] do
				minetest.env:remove_node(np)
				minetest.env:add_item(np, timber_nodenames[i])
				np={x=np.x, y=np.y+1, z=np.z}
			end
			minetest.sound_play("chainsaw", {pos = pos, gain = 1.0, max_hear_distance = 10,})
			return charge_to_take	
		end
		i=i+1
	end

return charge_to_take
end