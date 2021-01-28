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
			assert_count_equal ("blah_tag", ("a,b,c").split (','), ("x,y,z").split (','))
			assert_count_not_equal ("blah_tag", ("a,b,c").split (','), ("w,x,y,z").split (','))
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

end


