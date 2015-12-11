note
	description: "Additional features which should be in EQA_TEST_SET"
	date: "$Date: 2015-09-15 08:46:10 -0400 (Tue, 15 Sep 2015) $"
	revision: "$Revision: 12279 $"

class
	EXTENDED_TEST_SET

inherit
	TEST_SET_BRIDGE
		undefine
			default_create
		end

	EQA_TEST_SET

feature -- Basic Operations

	assert_equals (a_base_tag: STRING; a_expected_value: detachable ANY; a_actual_value: like a_expected_value)
		do
			if a_expected_value /= Void then
				if a_actual_value /= Void then
					if not (a_expected_value ~ a_actual_value) then
						assert_equality_failure (a_base_tag, a_expected_value, a_actual_value, "")
					end
				else
					assert (a_base_tag + "_actual_value_void %" %N[expected:%T" + a_expected_value.out + "]", False)
				end
			elseif a_actual_value /= Void then
				assert (a_base_tag + "_expected_value_void %" %N[actual:%T" + a_actual_value.out + "]", False)
			end
		end

	assert_less (a_base_tag: STRING; a_expected_value: COMPARABLE; a_is_equal: BOOLEAN; a_actual_value: like a_expected_value)
			-- Test "<=" (i.e. less-than-or-equal-to) that `a_actual_value' <= `a_expected_value'.
		do
			if a_is_equal and then not (a_actual_value <= a_expected_value) then
				assert_equality_failure (a_base_tag, a_expected_value, a_actual_value, "is greater than")
			elseif not a_is_equal and then not (a_actual_value < a_expected_value) then
				assert_equality_failure (a_base_tag, a_expected_value, a_actual_value, "is greater than and not equal to")
			end
		end

	assert_greater (a_base_tag: STRING; a_expected_value: COMPARABLE; a_is_equal: BOOLEAN; a_actual_value: like a_expected_value)
			-- Test ">=" (i.e. less-than-or-equal-to) that `a_actual_value' >= `a_expected_value'.
		do
			if a_is_equal and then not (a_actual_value >= a_expected_value) then
				assert_equality_failure (a_base_tag, a_expected_value, a_actual_value, "is less than")
			elseif not a_is_equal and then not (a_actual_value > a_expected_value) then
				assert_equality_failure (a_base_tag, a_expected_value, a_actual_value, "is less than and not equal to")
			end
		end

	assert_in_bounds (a_base_tag: STRING; a_lower_bound: COMPARABLE; a_is_lower_equal: BOOLEAN; a_upper_bound: COMPARABLE; a_is_upper_equal: BOOLEAN; a_actual_value: COMPARABLE)
			-- Test if `a_actual_value' is >= `a_lower_bound', but <= `a_upper_bound'.
		do
			assert_less (a_base_tag + "(upper bound)", a_upper_bound, a_is_upper_equal, a_actual_value)
			assert_greater (a_base_tag + "(lower bound)", a_lower_bound, a_is_lower_equal, a_actual_value)
		end

	assert_strings_equal (a_base_tag: STRING; a_expected_value, a_actual_value: detachable READABLE_STRING_GENERAL)
			-- Test assertion that `a_expected_value' and `a_actual_value' are the made up of the same characters.
		local
			l_tag: STRING_8
			l_raise: BOOLEAN
		do
			if a_expected_value /= Void then
				if a_actual_value /= Void then
						-- Raise an exception is strings are not of the same value.
					l_raise := not a_expected_value.same_string (a_actual_value)
				else
						-- Values are different
					l_raise := True
				end
			elseif a_actual_value /= Void then
					-- Values are different.
				l_raise := True
			end
			if l_raise then
					-- Create `assert' tag.
				create l_tag.make (100)
				l_tag.append ("%"")
				l_tag.append (a_base_tag)
				l_tag.append ("%" [expected: ")
				l_tag.append_string_general (string_for_display (a_expected_value))
				l_tag.append ("] [actual: ")
				l_tag.append_string_general (string_for_display (a_actual_value))
				l_tag.append_character (']')
				l_tag.append_character ('%N')
				l_tag.append_character ('%N')
				l_tag.append (diffs (a_expected_value, a_actual_value))
					-- Call `assert' with False condition to raise alert.
				assert (l_tag, False)

					-- Free memory immediately in case string is large.
				l_tag.wipe_out
				l_tag.resize (0)
			end
		end

	assert_case_insensitive_strings_equal (a_base_tag: STRING; a_expected_value, a_actual_value: detachable READABLE_STRING_GENERAL)
			-- Test assertion that `a_expected_value' and `a_actual_value' are the same characters regardless of their case.
		local
			l_actual_value, l_expected_value: detachable READABLE_STRING_GENERAL
		do
			if attached a_expected_value then
				l_expected_value := a_expected_value.twin
				l_expected_value := l_expected_value.as_upper
			end
			if attached a_actual_value then
				l_actual_value := a_actual_value.twin
				l_actual_value := l_actual_value.as_upper
			end
			assert_strings_equal (a_base_tag, l_expected_value, l_actual_value)
		end

	assert_fuzzy_equals (a_tag: STRING; a_expected, a_actual: DOUBLE; a_delta: DOUBLE)
			-- Assert that a_actual is equal to `a_expected' plus or minus `a_delta' (inclusive)
		local
			l_lower, l_upper: DOUBLE
		do
			l_lower := a_expected - a_delta
			l_upper := a_expected + a_delta
			assert (a_tag + " (Expected:" + a_expected.out + "; Actual: " + a_actual.out + "; Delta: " + a_delta.out + ")", a_actual >= l_lower and a_actual <= l_upper)
		end

	string_for_display (a_string: detachable READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			-- `a_string' as a displayable string for assertions.
		local
			l_str: STRING_8
		do
			if attached a_string then
				if a_string.count > 1000 then
					l_str := a_string.substring (1, 1000).as_string_8
						-- Add ellipsis at end to suggest string is cutoff.
					l_str.put ('.', 998)
					l_str.put ('.', 999)
					l_str.put ('.', 1000)
					Result := l_str
				else
						-- `assert' requires a STRING_8 so we make sure that the string is valid.
					if a_string.is_valid_as_string_8 then
						Result := a_string
					else
							-- Convert to STRING_8, this will result in some data loss.
						Result := "(*** DATA LOSS IN STRING_32 Conversion ***) " + a_string.as_string_8
					end
				end
			else
				Result := "Void"
			end
		end

feature -- Constants

	or_equal: BOOLEAN = True

	but_not_equal: BOOLEAN = False

feature {NONE} -- Implementation: Basic Operations

	diffs (a_expected_value: detachable ANY; a_actual_value: like a_expected_value): STRING
			-- What are the diffs between `a_expected_value' and `a_actual_value'?
		local
			l_expected, l_actual: STRING
			h, i, j, k, l, m, n: INTEGER
			l_found: BOOLEAN
		do
			create Result.make_empty
			if attached a_expected_value as al_value then
				l_expected := al_value.out
			else
				create l_expected.make_empty
				l_found := True
			end
			if attached a_actual_value as al_value then
				l_actual := al_value.out
			else
				create l_actual.make_empty
				l_found := True
			end
			from i := 1
			until l_found or (i > l_expected.count or i > l_actual.count)
			loop
				if l_actual.item (i).is_equal ('%N') then
					l := l + 1
				end
				if not (l_expected.item (i) ~ l_actual.item (i)) then
					l_found := True
				end
				i := i + 1
			end

			l_found := l_found or (l_expected.substring (1, k).same_string (l_actual.substring (1, k)) and l_expected.count /= l_actual.count)
			if l_found then
				j := i - diff_depth
				if j < 0 then
					j := 1
				end
				k := i + diff_depth
				if k > l_expected.count then
					k := l_expected.count
				end
				if k > l_actual.count then
					k := l_actual.count
				end
				if k > (l_actual.count - diff_depth) and k /= l_actual.count then
					n := l_actual.count
				else
					n := k
				end
				if k > (l_expected.count - diff_depth) and k /= l_expected.count then
					m := l_expected.count
				else
					m := k
				end
				check k_in_bounds: k <= l_expected.count and k <= l_actual.count end
				Result := "Diffs: @"
				Result.append (i.out)
				from h := 1 until h > (i - j - i.out.count) + 8 loop h := h + 1; Result.append_character ('-') end
				Result.append_character ('>')
				Result.append_character ('!')
				Result.append_character (' ')
				if l > 0 then
					Result.append ("@Line: ")
					Result.append (l.out)
				end
				Result.append_character ('%N')
				Result.append ("[Expected:%T] ")
				Result.append (single_line_from_multi_line (l_expected.substring (j, m)))
				Result.append_character ('%N')
				Result.append ("[Actual:%T] ")
				Result.append (single_line_from_multi_line (l_actual.substring (j, n)))
			end


			check result_not_empty: not Result.is_empty end
		end

	diff_depth: INTEGER = 20

	single_line_from_multi_line (a_string: STRING): STRING
			-- Strip out tabs and new-lines.
		local
			l_result: STRING
		do
			l_result := a_string.twin
			l_result.replace_substring_all ("%T", "<t>")
			l_result.replace_substring_all ("%N", "<n>")
			Result := l_result
		end

feature {NONE} -- Implementation

	assert_equality_failure (a_base_tag: STRING; a_expected_value, a_actual_value: ANY; a_between_message: STRING)
			-- Common assert failure for equality tests.
		do
			assert ("%"" + a_base_tag + "%" %N[expected:%T{" + a_expected_value.generating_type.out + "} " + a_expected_value.out + "] %N" + a_between_message + "%N[actual:%T{" + a_actual_value.generating_type.out + "} " + a_actual_value.out + "]", False)
		end

end
