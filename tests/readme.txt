Each task file should contain the list of tasks separated by as many spaces as you like.
; Comments are supported everywhere except in the middle of test information, that should be contiguous.

For tasks that don't perform a substitution:

The first line of a the test should be a comparison (eg. > 0, == 2, etc.) which, if $regex() should return a value 
satisfying that condition, would render the expression invalid. 

The second line is the input text passed to $regex() for testing purposes.

The third line is an error message to return should the test fail.