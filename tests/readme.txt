Each task file should contain the list of tasks separated by as many spaces as you like.
; Comments are supported everywhere except in the middle of test information, that should be contiguous.

For tasks that don't perform a substitution:

The first line of a the test should be a comparison (eg. > 0, == 2, etc.) which, if $regex() should return a value 
satisfying that condition, would render the expression invalid. 

The second line is the input text passed to $regex() for testing purposes.

The third line is an error message to return should the test fail.

You can now also implement tests that validate backrefs. For example, you can validate the content of backrefs. The syntax looks like this
regml: <validation>
Error message

<validation> should look like "string", regml_id == value, regml_id2 == value2, ..., regml_idN = valueN
If you want to use quotes, escape them as such: \"

Real life example

regml: "match against this string", 0 == 2, 1 === "string", 2 === "this"
You are not setting 2 backrefs where the first equals "string" and the other "this".


You can also include code in the messages (and infact, in the code when you compare things). For example

!= 1
test
Here is a message with a $iif($true,if conditional, wtf) $+ .

-----

Added feature to add substitution comparison to any task
sub: "text", "replacement", "comparator", "expected output"
replacement can be \1 etc too
Use USER_INPUT as replacement (in quotes) if you want to use the users replacement string.

-----

You can not create tests to validate the regex itself using mirc built in comparator functions. Such as "isin", "iswm" etc etc.
Syntax is:
validate: "comparator", "comparison1", "comparison2", ...., "comparisonN"
real life example:
validate: "!isin", "word", "word2"
Word or word2 is not in your regex

This gets translated tp
if (word !isin <your regex> || word2 !isin <your regex>) { display error }

-----
reval: is going to allow regex validation of the regex