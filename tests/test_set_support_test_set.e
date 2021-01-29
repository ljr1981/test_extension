note
	description: "[
		Assertion tests for {TEST_SET_SUPPORT}, which an extension of the
		{EQA_COMMONLY_USED_ASSERTIONS} class assertions.
	]"
	testing: "type/manual"

class
	TEST_SET_SUPPORT_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	asser_count_equal_tests
			-- Tests of `assert_count_equal' and `assert_count_not_equal'
		note
			testing: "covers/{TEST_SET_SUPPORT}.assert_count_equal",
						"covers/{TEST_SET_SUPPORT}.assert_count_not_equal",
						"execution/isolated"
			history: "[
				This assertion is inpired by Python3 "unittest" library assertion: assertCountEqual.
				]"
			EIS: "name=assertCountEqual", "src=https://docs.python.org/3/library/unittest.html#test-cases"
		do
			assert_count_equal ("assert_count_equal", ("a,b,c").split (','), ("x,y,z").split (','))
			assert_count_not_equal ("assert_count_not_equal", ("a,b,c").split (','), ("w,x,y,z").split (','))
		end

	assert_ad_hoc_tables_equal_tests
			-- Tests of `assert_ad_hoc_tables_equal' and `assert_ad_hoc_tables_not_equal'
		note
			testing:  "covers/{TEST_SET_SUPPORT}.assert_tables_equal",
						"covers/{TEST_SET_SUPPORT}.assert_tables_not_equal",
						"execution/isolated"
			history: "[
				This assertion is inpired by Python3 "unittest" library assertion: assertListsEqual.
				]"
			EIS: "name=assertListsEqual", "src=https://docs.python.org/3/library/unittest.html#test-cases"
		do
			assert_ad_hoc_tables_equal ("identical_arrays", <<1,2,3>>, <<1,2,3>>)
			assert_ad_hoc_tables_equal ("out_of_order_but_same_content", <<1,2,3>>, <<3,2,1>>)
			assert_ad_hoc_tables_not_equal ("out_of_order_and_different_content", <<1,2,3>>, <<3,2>>)

			assert_ad_hoc_tables_equal ("same_strings", "abc", "abc")
			assert_ad_hoc_tables_equal ("backward_strings", "abc", "cba")
			assert_ad_hoc_tables_equal ("backward_with_addition_string", "abc", "cbad")
			assert_ad_hoc_tables_not_equal ("reversed_backward_addition", "cbad", "abc")

			assert_ad_hoc_tables_not_equal ("string_to_array_of_int", "abc", <<1,2,3>>)
			assert_ad_hoc_tables_equal ("string_to_array_character", "abc", <<'a','b','c'>>)
			assert_ad_hoc_tables_equal ("string_to_array_character", "abc", <<'c','b','a'>>)
		end

	assert_tables_precisely_equal_tests
			-- Tests of `assert_tables_precisely_equal' and `assert_tables_not_precisely_equal'.
		note
			testing:  "covers/{TEST_SET_SUPPORT}.assert_tables_precisely_equal",
						"covers/{TEST_SET_SUPPORT}.assert_tables_not_precisely_equal",
						"execution/isolated"
			history: "[
				This assertion is inpired by Python3 "unittest" library assertion: assertListsEqual.
				In the case of Eiffel, the notion of {LIST} is an ancestor of {TABLE}, which is
				quite a bit higher in abstraction. This allows testing of {TABLE} objects in ways
				that {LIST} participates in, but it is not limited to.
				]"
			EIS: "name=assertListsEqual", "src=https://docs.python.org/3/library/unittest.html#test-cases"
			discussion: "[
				Precision here refers to both content and order.
				
				Interestingly enough--a string like "abc" can be "precisely-equal" to <<'a','b','c'>>
				as an array of CHARACTERs. Therefore, this allows one to get quite creative with
				object comparisons in testing.
				]"
		do
			assert_tables_precisely_equal ("precisely_equal_arrays", <<1,2,3>>, <<1,2,3>>)
			assert_tables_not_precisely_equal ("not_precisely_equal_arrays", <<1,2,3>>, <<1,2,4>>)
			assert_tables_precisely_equal ("string_to_array_character", "abc", <<'a','b','c'>>)
		end

	assert_in_test
			-- Test `assert_in' assertions
		do
			assert_in ("", 'a', "abc")					-- The Python way
			assert ("", ("abc").has ('a'))				-- The Eiffel way

			assert_in ("", 'a', <<'a','b','c'>>)		-- The Python way
			assert ("", (<<'a','b','c'>>).has ('a'))	-- The Eiffel way

				-- The "notted" version is not helpful either ...
			assert_not_in ("", 'z', "abc")				-- The Python way
			assert ("", not ("abc").has ('z'))			-- The Eiffel way
		end

	assert_almost_equals_test
			-- Test `assert_almost_equal'.
		do
			assert_almost_equals_by_rounding ("six_places", 10.123456, 10.123456789, 6)		-- PASSES as expected.
--			assert_almost_equals_by_rounding ("six_places", 10.123, 10.123456789, 6)		-- FAILS as expected.

			assert_almost_equals_by_rounding ("three_places", 10.123, 10.123416789, 3)		-- PASSES due to rounding down.
--			assert_almost_equals_by_rounding ("three_places", 10.123, 10.123456789, 3)		-- FAILS due to rounding up.
		end

	assert_almost_equal_by_limit_test
			-- Test `assert_almost_equal_by_limit'.
		do
--			assert_almost_equal_by_limit ("0000005", 10.123456, 10.123456789, 0.0000005)	-- FAILS as discovered.
			assert_almost_equal_by_limit ("000005", 10.123456, 10.123456789, 0.000005)
			assert_almost_equal_by_limit ("00005", 10.123456, 10.123456789, 0.00005)
			assert_almost_equal_by_limit ("0005", 10.123456, 10.123456789, 0.0005)
			assert_almost_equal_by_limit ("005", 10.123456, 10.123456789, 0.005)
			assert_almost_equal_by_limit ("05", 10.123456, 10.123456789, 0.05)
			assert_almost_equal_by_limit ("5", 10.123456, 10.123456789, 0.5)
			assert_almost_equal_by_limit ("1", 10.123456, 10.123456789, 0.1)
		end

	assert_almost_equal_by_rounded_places_test
			-- Test `assert_almost_equal_by_rounded_places'.
		do
			assert_almost_equal_by_rounded_places ("1places", 10.123456, 10.123456789, 1)
			assert_almost_equal_by_rounded_places ("2places", 10.123456, 10.123456789, 2)
			assert_almost_equal_by_rounded_places ("3places", 10.123456, 10.123456789, 3)
			assert_almost_equal_by_rounded_places ("4places", 10.123456, 10.123456789, 4)
			assert_almost_equal_by_rounded_places ("5places", 10.123456, 10.123456789, 5)
--			assert_almost_equal_by_rounded_places ("6places", 10.123456, 10.123456789, 6)	-- FAILS as expected.
		end

end


