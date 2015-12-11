note
	description: "Testing EV_APPLICATION object used to override certain routines for out of event loop testing"
	author: ""
	date: "$Date: 2014-03-25 21:01:37 -0400 (Tue, 25 Mar 2014) $"
	revision: "$Revision: 8899 $"

class
	TEST_APPLICATION

inherit
	EV_APPLICATION
		redefine
			shift_pressed, ctrl_pressed, alt_pressed
		end

feature {TEST_SET_BRIDGE} -- Key Press State for Testing Only

	shift_pressed: BOOLEAN
	ctrl_pressed: BOOLEAN
	alt_pressed: BOOLEAN

feature {TEST_SET_BRIDGE} -- Set Key Press State for Testing Only

	set_is_shift_key_pressed (a_is_pressed: BOOLEAN)
			-- Set `is_shift_key_pressed' to `a_is_pressed'
		do
			shift_pressed := a_is_pressed
		ensure
			is_shift_key_pressed_updated: shift_pressed = a_is_pressed
		end

	set_is_control_key_pressed (a_is_pressed: BOOLEAN)
			-- Set `is_control_key_pressed' to `a_is_pressed'
		do
			ctrl_pressed := a_is_pressed
		ensure
			is_control_key_pressed_updated: ctrl_pressed = a_is_pressed
		end

	set_is_alt_key_pressed (a_is_pressed: BOOLEAN)
			-- Set `is_option_key_pressed' to `a_is_pressed'
		do
			alt_pressed := a_is_pressed
		ensure
			is_option_key_pressed_updated: alt_pressed = a_is_pressed
		end

note
	copyright: "Copyright (c) 2010-2013, Jinny Corp."
	copying: "[
			Duplication and distribution prohibited. May be used only with
			Jinny Corp. software products, under terms of user license.
			Contact Jinny Corp. for any other use.
			]"
	source: "[
			Jinny Corp.
			3587 Oakcliff Road, Doraville, GA 30340
			Telephone 770-734-9222, Fax 770-734-0556
			Website http://www.jinny.com
			Customer support http://support.jinny.com
		]"
end
