note
	description: "[
		Assertion tests for {TEST_SET_SUPPORT}.
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
		do
			assert_count_equal ("blah_tag", ("a,b,c").split (','), ("x,y,z").split (','))
			assert_count_not_equal ("blah_tag", ("a,b,c").split (','), ("w,x,y,z").split (','))
		end

	test_set_support_assert_tables_tests
			-- Tests of `assert_tables_equal' and `assert_tables_not_equal'
		note
			testing:  "covers/{TEST_SET_SUPPORT}.assert_tables_equal",
						"covers/{TEST_SET_SUPPORT}.assert_tables_not_equal",
						"execution/isolated"
		do
			assert_tables_equal ("blah_tag_4", <<1,2,3>>, <<1,2,3>>)
			assert_tables_equal ("blah_tag_4", <<1,2,3>>, <<3,2,1>>)
			assert_tables_not_equal ("blah_tag_4", <<1,2,3>>, <<3,2>>)

			assert_tables_equal ("blah_tag_5", "abc", "abc")
			assert_tables_equal ("blah_tag_6", "abc", "cba")
			assert_tables_equal ("blah_tag_7", "abc", "cbad")
			assert_tables_not_equal ("blah_tag_8", "cbad", "abc")

			assert_tables_not_equal ("blah_tag_9", "abc", <<1,2,3>>)
			assert_tables_equal ("blah_tag_9", "abc", <<'a','b','c'>>)
		end

end


