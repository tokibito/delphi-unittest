Nullpobug.Unittest
==================

Yet another unittest. TestRunner will output the report of JUnit XML Format.

::

   >cd Example
   >make
   >TestProject
   ..FS..
   ======================================================================
   FAIL: TestAddFail (TMyUnit1Test)
   ----------------------------------------------------------------------
   EAssertionError: 30 != 40

   ----------------------------------------------------------------------
   Ran 6 tests in 0.501s

   FAILED (failures=1, skipped=1)

Requires
========

* Delphi XE3 (dcc32, dccosx command)
