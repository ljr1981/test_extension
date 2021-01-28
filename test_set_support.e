note
	description: "Commands and Queries in Support of AutoTest"
	goal: "[
		Create Commands, Queries, or both that enhance (support) the testing process.
		]"

class
	TEST_SET_SUPPORT

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Support

	replace_non_printables (a_string: STRING): STRING
			-- `replace_non_printables' (space, newline, etc) with
			--	ASCII printable values not commonly used.
		note
			examples: "[
				this is an
					example of
						replacement
				
				becomes ...
				
				this·is·an¬
				»	example·of¬
				»	»	replacement
				
				Thus, non-printables become "seen" to help
				understand string comparisons where there might
				be issues stemming from non-printable characters.
				]"
		do
			Result := a_string.twin
			Result := replace_with_replacements (a_string, {ARRAY [TUPLE [CHARACTER_8, STRING_8]]}
						<<
							[' ', middle_dot_U00B7_alt_0183],
							['%N', not_sign_U00AC_alt_0172],
							['%U', degree_sign_U0080_alt_0176],
							['%T', double_angle_right_U00BB_alt_0187]
						>>)
		end

	replace_non_printables_keeping_newlines (a_string: STRING): STRING
			-- `replace_non_printables' (space, newline, etc) with
			--	ASCII printable values not commonly used.
			--  Keep newlines.
		do
			Result := a_string.twin
			Result := replace_with_replacements (a_string, {ARRAY [TUPLE [CHARACTER_8, STRING_8]]}
						<<
							[' ', middle_dot_U00B7_alt_0183],
							['%N', not_sign_U00AC_alt_0172_with_newline],
							['%U', degree_sign_U0080_alt_0176],
							['%T', double_angle_right_U00BB_alt_0187]
						>>)
		end

	not_sign_U00AC_alt_0172: STRING = "¬"
	not_sign_U00AC_alt_0172_with_newline: STRING = "¬%N"
	degree_sign_U0080_alt_0176: STRING = "°"
	middle_dot_U00B7_alt_0183: STRING = "·"
	double_angle_right_U00BB_alt_0187: STRING = "»"
		-- Each constant (above) has "name", "unicode code", "ASCII keyboard keystrokes"
		--  in the name to reveal the precise character being used and for what purpose.

	replace_with_replacements (a_string: STRING; a_replacements: ARRAY [TUPLE [original: CHARACTER; replacement: STRING]]): STRING
			-- `replace_with_replacements' in `a_replacements' into `a_string'.
		do
			Result := a_string.twin
			across
				a_replacements as ic
			loop
				Result.replace_substring_all (ic.item.original.out, ic.item.replacement)
			end
			Result.replace_substring_all ("»", "»%T")
		end

	assert_strings_equal_diff (a_tag, a_expected, a_actual: STRING)
			-- Assert that `a_expected' is the same as `a_actual'.
			--	If not, then show a list of differences as lines where
			--	the diffs happen.
		local
			l_diff: DIFF_TEXT
			l_result: BOOLEAN
			l_dst, l_src: INTEGER
		do
			create l_diff
			l_diff.set_text (a_expected, a_actual)
			l_diff.compute_diff
			l_result := attached l_diff.hunks as al_hunks and then
							attached l_diff.match as al_match and then
							al_hunks.is_empty and then
							al_match.count = a_expected.split ('%N').count and then
							al_match.count = a_actual.split ('%N').count
			if
				not l_result and then
				attached l_diff.hunks as al_hunks and then
				attached l_diff.match as al_matches and then
				attached a_expected.split ('%N') as al_expected_list and then
				attached a_actual.split ('%N') as al_actual_list
			then
				print ("Non-matching hunk indexes:%N%N")
				across
					al_hunks as ic
				loop
					across
						ic.item as ic_lines
					loop
						print ("dst: " + ic_lines.item.dst.out + "%T%Tsrc: " + ic_lines.item.src.out + "%N")
						l_dst := ic_lines.item.dst + 1
						if l_dst <= al_actual_list.count then
							print ("%Tdst-actual   : " + al_actual_list [l_dst] + "%N")
						else
							print ("%Tdst-actual : out-of-bounds%N%NExpected has more lines than Actual.%NWhat to do: Either add a line to Actual, or find missing line in Actual.%N(It might be as simple as removing a new_line (CR) from Expected text)%N")
						end
						l_src := ic_lines.item.src + 1
						if l_src <= al_expected_list.count then
							print ("%Tsrc-expected : " + al_expected_list [l_src] + "%N")
						else
							print ("%Tsrc-expected : out-of-bounds%N%NActual has more lines than Expected.%NWhat to do: Either add a line to Expected, or find missing line in Expected.%N(It might be as simple as adding new_line (CR) to Expected text)%N")
						end
					end
				end
			end
			assert_32 (a_tag, l_result)
		end

	assert_has_hash_item_for_key (a_tag: STRING; a_hash: HASH_TABLE [detachable ANY, HASHABLE]; a_value: detachable ANY; a_key: HASHABLE)
			--
		do
			if attached a_hash.item (a_key) as al_value then
				assert (a_tag, al_value ~ a_value)
			end
		end

	assert_count_equal (a_tag: STRING; a, b: attached like finite_anchor)
			-- Assert that `a' and `b' counts equal.
		do
			assert_integers_equal (a_tag, a.count, b.count)
		end

	assert_count_not_equal (a_tag: STRING; a, b: attached like finite_anchor)
			-- Assert that `a' and `b' counts not equal.
		do
			assert_integers_not_equal (a_tag, a.count, b.count)
		end

feature -- Access: Collection Assertions

	assert_ad_hoc_tables_equal (a_tag: STRING; a, b: attached like collection_anchor)
			-- Is ad-hoc TABLE `a' equal to `b'?
		do
			assert_32 (a_tag, is_ad_hoc_table_equal (a, b))
		end

	assert_ad_hoc_tables_not_equal (a_tag: STRING; a, b: attached like collection_anchor)
			-- Is ad-hoc TABLE `a' not equal to `b'?
		do
			assert_32 (a_tag, not is_ad_hoc_table_equal (a, b))
		end

	assert_tables_precisely_equal (a_tag: STRING; a, b: attached like collection_anchor)
			-- Assert `a' and `b' match in item type, count, order, and content.
		do
			assert_32 (a_tag, is_table_precisely_equal (a, b))
		end

	assert_tables_not_precisely_equal (a_tag: STRING; a, b: attached like collection_anchor)
			-- Assert `a' and `b' do not match in item type, count, order, or content.
		do
			assert_32 (a_tag, not is_table_precisely_equal (a, b))
		end

feature {NONE} -- Implementation: Assert TABLE Support

	finite_anchor: detachable FINITE [detachable ANY]

	collection_anchor: detachable TABLE [ANY, ANY]
			-- FINITE [detachable ANY] type anchor

	is_ad_hoc_table_equal (a, b: attached like collection_anchor): BOOLEAN
			-- Are tables A and B equal with an ad-hoc order?
			--	Equality based on B items same as A items regardless of order.
		do
			Result := across
							a as ic_a
						all
							b.has (ic_a.item)
						end
		end

	is_table_precisely_equal (a, b: attached like collection_anchor): BOOLEAN
			-- Is TABLE A precisely equal to B in order and content?
		local
			l_a_linear,
			l_b_linear: LINEAR [ANY]
		do
			l_a_linear := a.linear_representation
			l_b_linear := b.linear_representation
			Result := True -- Presumption of equality is the best we can do.

			from
				l_a_linear.start
				l_b_linear.start
			until
				(l_a_linear.after or l_b_linear.after) or else (not Result)
			loop
				Result := l_a_linear.item = l_b_linear.item
				l_a_linear.forth
				l_b_linear.forth
			end
		end

feature -- Access: Collection Item Assertions

	assert_in (a_tag: STRING; a_item: ANY; a_collection: attached like collection_anchor)
			-- Assert `a_item' is in `a_collection'.
		local
			l_tag: STRING
		do
			l_tag := a_tag.twin
			if not a_collection.has (a_item) then
				l_tag.append_character ('%N')
				l_tag.append_string_general ("Expected `item' in `collection': %N")
				l_tag.append_string_general ("Item: " + a_item.out + "%N----------------%N")
				l_tag.append_string_general (a_collection.out)
			end
			assert_32 (l_tag, a_collection.has (a_item))
		end

	assert_not_in (a_tag: STRING; a_item: ANY; a_collection: attached like collection_anchor)
			-- Assert `a_item' is not in `a_collection'.
		local
			l_tag: STRING
		do
			l_tag := a_tag.twin
			if a_collection.has (a_item) then
				l_tag.append_character ('%N')
				l_tag.append_string_general ("Expected `item' not in `collection': %N")
				l_tag.append_string_general ("Item: " + a_item.out + "%N----------------%N")
				l_tag.append_string_general ("Collection:%N" + a_collection.out)
				l_tag.append_character ('%N')
			end
			assert_32 (l_tag, not a_collection.has (a_item))
		end

feature -- Access: Assertions

	assert_strings_equal_for_item_for_key (a_tag: STRING; a_table: DYNAMIC_TABLE [detachable ANY, HASHABLE]; a_value: detachable ANY; a_key: HASHABLE)
			-- Can `a_key' be found in `a_table'? If so, does `a_value' match found value?
		do
			if attached a_value and then attached a_table.item (a_key) as al_actual_value then
				assert_strings_equal (a_tag, a_value.out, al_actual_value.out)
			end
		end

	assert_strings_equal_diff_for_item_for_key (a_tag: STRING; a_table: DYNAMIC_TABLE [detachable ANY, HASHABLE]; a_value: detachable ANY; a_key: HASHABLE)
			-- Can `a_key' be found in `a_table'? If so, does `a_value' match found value?
			-- 	What are the diffs if they do not match?
		do
			if attached a_value and then attached a_table.item (a_key) as al_actual_value then
				assert_strings_equal_diff (a_tag, a_value.out, al_actual_value.out)
			end
		end

feature -- Access: Almost Equal Assertions

	assert_almost_equals_by_rounding (a_tag: STRING; a, b: REAL; a_places: NATURAL)
			-- Assert that `a' and `b' REAL numbers are almost or about equal.
		local
			l_a,
			l_b: DECIMAL
		do
			create l_a.make_from_string (a.out)
			l_a := l_a.round_to (a_places.to_integer_32)
			create l_b.make_from_string (b.out)
			l_b := l_b.round_to (a_places.to_integer_32)
			assert_equal (a_tag, l_a, l_b)
		end

	assert_almost_equals_by_truncation (a_tag: STRING; a, b: REAL; a_places: NATURAL)
			-- Assert that `a' and `b' REAL numbers are almost or about equal.
		local
			l_a,
			l_b: STRING
		do
			l_a := (a.truncated_to_integer.out)
			l_a.replace_substring_all (".0", "")
			l_a.append_string_general ( (a - a.truncated_to_integer).out )
			assert_equal (a_tag, l_a, l_b)
		end

end
