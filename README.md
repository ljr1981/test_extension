# test_extension
Extension library for Eiffel testing

## GOAL: Create Isolated Testing Environment in Eiffel Studio

The goal is to have a "test target", which is completely isolated from your primary project (or library) code, such that your test code is never crossed or mixed with your primary. The way towards the goal includes having a `test` folder (directory) immediately subordinate to your primary project folder, where you will store any classes related to testing (i.e. test classes and classes used for testing like `mocks` and so on). This folder may also contain data or other files, which are relevant to testing, but not to delivery of your software.

*NOTE: These instructions are for Windows OS (not Linux--yet), so you may need to translate parts.*

## STEP: Clone this simple Eiffel library to your local GitHub folder.

## STEP: Modify your project ECF XML file with the XML below:

	<target name="test" extends="[Your_project_name]">
		<description>[Your_project_description]</description>
		<root class="ANY" feature="default_create"/>
		<file_rule>
			<exclude>/.git$</exclude>
			<exclude>/.svn$</exclude>
			<exclude>/CVS$</exclude>
			<exclude>/EIFGENs$</exclude>
			<include>tests</include>
		</file_rule>
		<option profile="false">
		</option>
		<setting name="console_application" value="false"/>
		<library name="testing" location="$ISE_LIBRARY\library\testing\testing-safe.ecf"/>
		<cluster name="tests" location=".\tests\" recursive="true"/>
	</target>

This new `test_target` will be subordinate to your primary project `target`.

*NOTE: There are a pair of dependencies in the XML above: 1) You will need a "test" folder subordinate to your primary project folder. 2) The `root_class` is set to class ANY and feature `default_create`. This is on purpose. You don't need anything else for tests.*

## STEP: Ensure your TEST_SET classes have the following inheritance:

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

If you need to test features of a class that are exported to `{NONE}`, then change the export from `{NONE}` to `{TEST_SET_BRIDGE}`, which will allow only your `TEST_SET` classes to have access to otherwise non-exported features (as far as your primary project tartget system is concerned).
