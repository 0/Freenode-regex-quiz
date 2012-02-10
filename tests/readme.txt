Each task file should contain the list of tasks separated by as many spaces as you like.
; Comments are supported everywhere except in the middle of test information, that should be contiguous.

For tasks that don't perform a substitution:

The first line of a the test should be a comparison (eg. > 0, == 2, etc.) which, if $regex() should return a value 
satisfying that condition, would render the expression invalid. 

The second line is the input text passed to $regex() for testing purposes.

The third line is an error message to return should the test fail.

-------------------------------------
IN DEPTH VALIDATION
-------------------------------------

You have three extended ways to validate an expression. These are with:
	- regml:
	- sub:
	- validate:
These work regardless of task type.
All of these functions are two-liners. One validation, next error message.

* regml:
This function allows you to check the contents of backrefs, including how many backrefs there are set.
Example:
regml: content to match against, regml_id1 comparator1 value1, ..., regml_idN comparatorN valueN
Real life use:
regml: this is a test, 0 != 1, 1 !== this is a test
It runs an if-statement like this:
if (regml(0) != 1) { error }
if (regml(1) !== this is a test) { error }
If you want to check if a backref is null, use $null


* sub:
This function allows you run a substitution on a string.
sub: text, replacement, comparator, output
If you do not wish to specify replacement and use the user submitted one, use USER_INPUT. If you want to replace with nothing, leave the field empty
Use USER_INPUT as replacement (in quotes) if you want to use the users replacement string.


* validate:
This function allows you to validate the regex using mirc built in comparator functions. Such as "isin", "iswm" etc etc.
validate: comparator, comparison1, comparison2, ...., comparisonN
real life example:
validate: !isin, word, word2
This means word and word2 is not in your regex

This gets translated to
if (word !isin <your regex>) { display error }
if (word2 !isin <your regex>) { display error }


WARNING:
These functions all use COMMA to separate things. If you want to use a COMMA in your tests, use _C_.