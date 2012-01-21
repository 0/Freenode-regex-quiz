/*

Syntax: $validateRegex(<ID>, <task N>, <regex and substitution>)

Eg:     $validateRegex(username, 15, /expression/ subtext)

The ID should be valid and already established in users.ini. It will
be used to keep track of the number of attempts and perhaps other 
tidbits of information and statistics. 

This performs two layers of testing. The first validates the regex
and separates it from potential substitution text (if relevant to the 
given task). The second goes through the test file and checks the
correctness of the attempt.

It will trigger a signal event named 'validated' with the following
parameters:

<ID> <task N> <response code> <optional message>

The response code is an integer encoded message which the calling routine
can use to generate error messages. The codes are as follows:

0 - Attempt was successful on all tests and is valid.
1 - Attempt failed a certain test, details in the message.
2 - User has not reached the given task yet.
3 - User has already queued a task to validate.
4 - The given regex is formatted incorrectly.
5 - Substitution text was provided on a task that doesn't require it.

*/

alias validateRegex {

  var %output = .signal validate $1-2, %isSub = 0

  ; First layer of validation

  if ($regexUser($1, info, reached) !>= $2) {
    %output 2
    return
  }

  if ($hget(regexDist, $1)) {
    %output 3
    return
  }

  ; Include an expression which fills $regml(validate, 1) with the input regex
  ; and $regml(validate, 2) with substitution text.
  if (!$reVal($3).pat || !$reVal($3).val) {
    %output 4
    return
  }

  if ($regexTask($2, sub)) {
    %isSub = 1
  }
  elseif ($reVal($3).sub) {
    %output 5
    return
  }
  if ($regexTask($2, sub) && !$reVal($3).getSub) {
    %output 7
    return
  }

  if ($malformedRegex($reval($3).pat)) {
    %output 8 $v1
    return
  }

  checkTask $2

  hadd -m regexDist $1 $+(%isSub, $lf, $2, $lf, $reVal($3).pat, $lf, $reVal($3).sub)
  .timer 1 0 regexDist $1
}

; $regexUser(<ID>, <section>, <item>)
; or 
; /regexUser <ID> <section> <item> <value>

alias regexUser {
  if ($isid) returnex $readini($regexDir $+ users\ $+ $1.ini, n, $2, $3)
  writeini -n $qt($regexDir $+ users\ $+ $1.ini) $2-
}

; $regexTask(<N>, <item>)
; or
; /regexTask <N> <item> <value>

alias regexTask {
  if ($isid) returnex $readini($regexdir $+ tasks.ini, n, task $+ $1, $2) 
  writeini -n $qt($regexdir $+ tasks.ini) task $+ $1-
}

; $regexTasks()

alias regexTasks returnex $ini($qt($+($regexDir,tasks.ini)),0)

; /checkTask <task N>
; Checks the test file to see if it's been modified since the last check.
; Updates the number of tests in tasks.ini accordingly and throws any errors
; if it detects them (for example, no substitution text).

alias checkTask {
  var %file = $qt($regexdir $+ tests\task $+ $1.txt), %mtime = $file(%file).mtime
  if ($regexTask($1, testMtime) != %mtime) {
    if ($fopen(checkTask)) .fclose checkTask
    .fopen checkTask %file
    if (!$ferr) {
      var %task = $1, %line, %testNum = 0, %inTest, %testLine, %sub = $regexTask($1, sub)
      while (!$ferr) && (!$feof) {
        %line = $fread(checkTask)
        if (;* !iswm %line) {
          if (%line != $null) {
            if (!%inTest) {
              %inTest = 1
              %testLine =
              inc %testNum
              if (validate:* iswm %line || regml:* iswm %line || sub:* iswm %line) {
                tokenize 44 $regsubex(%line, /^\s*(?:validate|sub|regml):\s*/i,)
                inc %testLine
              }
              else {
                tokenize 32 %line
                if (!%sub) && (0 $1 $2) /
              }
              :back
            }
            inc %testLine
          }
          else { 
            if (%inTest) && (%testLine != 3) echo -egac info Test %testNum has an incorrect number of lines.
            %inTest =
          }
        }
      }
      if (%inTest) && (%testLine != 3) echo -egac info Test %testNum has an incorrect number of lines.
      regexTask %task tests %testNum
      regexTask %task testMtime %mtime
    }
    .fclose checkTask
  }
  return
  :error
  if (* /if: * unknown * iswm $error) {
    reseterror
    echo -egac info Test %testNum contains an invalid comparison.
    goto back
  }
}

; /regexDist <ID>
; Distribute processing time between all those who have requested to have 
; a regex validated, starting with <ID>.

alias regexDist {
  tokenize 10 $+($1, $lf, $hget(regexDist, $1))
  if ($regexUser($1, task $+ $3, attempts) !isnum 1-) {
    regexTask $3 total $calc(1 + $regexTask($3, total))
  } 
  regexUser $1 task $+ $3 attempts $calc(1 + $v1)
  regexUser $1 task $+ $3 last $4-5
  var %file = $qt($regexDir $+ tests\task $+ $3.txt)
  if ($fopen(regexDist)) .fclose regexDist
  .fopen regexDist %file
  if (!$ferr) {
    var %line, %testNum = 0, %out .signal validate $1 $3, %op ==, %v2, %input, %output, %result, %regex 1, %error, %failure $false
    while (!$ferr) && (!$feof) {
      %line = $fread(regexDist)
      if (;* !iswm %line) {
        if (%line != $null) {
          inc %testNum
          var %tests = $regsubex(%line, /^\s*(?:sub|regml|validate):\s*/i, ), %regexQuote = /\s*"((?>\\.|[^"])*)"\s*/
          if (regml: isin %line) {
            var %a = 2
            noop $regex(regexDist, $regsubex($gettok(%tests, 1, 44), %regexQuote, \1), $4)
            while ($gettok(%tests, %a, 44)) {
              var %v1 = $v1
              var %regml = $regml(regexDist, $gettok(%v1, 1, 32))
              var %regmlOp = $gettok(%v1, 2, 32)
              var %equals = $regsubex($gettok(%v1, 3, 32), %regexQuote, \1)
              if (%regml %regmlOp %equals) {
                %failure = $false
              }
              else {
                %failure = $true
                break
              }
              inc %a
            }
          }
          elseif (sub: isin %line) {
            var %subText = $regsubex($gettok(%tests, 1, 44), %regexQuote, \1)
            var %subRepl = $regsubex($gettok(%tests, 2, 44), %regexQuote, \1)
            var %subComp = $regsubex($gettok(%tests, 3, 44), %regexQuote, \1)
            var %subEquals = $regsubex($gettok(%tests, 4, 44), %regexQuote, \1)
            var %regsubex = $regsubex(regexDist, %subText, $4, %subRepl)
            if (%regsubex %subComp %subEquals) {
              %failure = $true
            }
          }
          elseif (validate: isin %line) {
            var %a = 2, %comp = $regsubex($gettok(%tests, 1, 44), %regexQuote, \1)
            var %re = $replace($4, \/, /)
            while ($gettok(%tests, %a, 44)) {
              var %v1 = $regsubex($v1, %regexQuote, \1)
              if (%v1 %comp %re) {
                %failure = 1
              }
              inc %a
            }
          }
          elseif (reval: isin %line) {
          }
          elseif ($2) {
            %input = %line
            %output = $fread(regexDist)
            noop $regsub(regexDist, %input, $4, $5, %result)
          }
          else {
            %input = $fread(regexDist)
            %regex = $regex(regexDist, %input, $4)
            %op = $gettok(%line, 1, 32)
            %v2 = $gettok(%line, 2, 32)
          }
          %error = $fread(regexDist)
          if (!%failure) {
            if (%regex %op %v2) || (%result !=== %output) {
              %failure = $true
            }
            else {
              %failure = $false
            }
          }
          if (%failure) {
            ;%out 1 Failed on test %testNum $+ . %error
            %out 1 Task $3 $+ . 5Test %testNum of $regexTask($3,tests) failed. %error
            regexUser $1 task $+ $3 fail (test %testNum of $regexTask($3,tests) $+ ) %error
            ;  %out 1 Debug: if ( $+ %regex %op %v2 $+ ) || ( $+ %result !=== %output $+ )
            ;  if (!$2) %out 1 Debug: $+($,!regex,$chr(40),regexDist,$chr(44),$chr(32),%input,$chr(44),$chr(32),$4,$chr(41))
            ;  else %out 1 Debug: $+($,!regsubex,$chr(40),regexDist,$chr(44),$chr(32),%input,$chr(44),$chr(32),$4,$chr(44),$chr(32),$5,$chr(41)) -> %result
            .fclose regexDist
            return
          }
        }
      }
    }
    if ($len($regexUser($1, task $+ $3, shortest)) == 0) || ($v1 > $len($4-5)) {
      if (!$v1) regexTask $3 success $calc(1 + $regexTask($3, success))
      regexUser $1 task $+ $3 shortest $4-5
    }
    if ($gettok($regexTask($3, shortest), 2, 32) !<= $len($4-5)) regexTask $3 shortest $1 $v2
    %out 0
  }
  .fclose regexDist
}


; $reVal(/regex/)
; Validate the regex
alias reVal {
  var %input = $1-, %sre = /(*UTF8)^s([^\w\s\\])((?:\\.|(?!\\|\1).)*)\1((?:\\.|(?!\\|\1).)*)\1([gisSmoxXAU]*)\s*$/, $&
    %mre1 = /(*UTF8)^m?([^\w\s\\])((?:\\.|(?!\\|\1).)*)\1([gisSmoxXAU]*)\s*$/, %ret = $iif($isid,returnex,echo -ti12a)
  var %sub123 = $false
  if ($regex(sre,%input,%sre) isnum 1-) {
    var %delim = $regml(sre,1), %pat = $regml(sre,2), %repl = $regml(sre,3), %flags = $regml(sre,4)
    if (%delim != /) {
      if (%delim isin |^()[{.+*?\$#) var %escape = \ $+ %delim
      else var %escape = %delim
      var %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %escape $+ )/g,\1\2), %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\//g,\1\/)
    }
    var %repl = $regsubex(%repl,/(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %delim $+ )/g,\1\2)
    %sub123 = $true
  }
  elseif (($regex(mre,%input,%mre1) isnum 1-)) {
    var %delim = $regml(mre,1), %pat = $regml(mre,2), %flags = $regml(mre,3)
    if (%delim != /) {
      if (%delim isin |^()[{.+*?\$#) var %escape = \ $+ %delim
      else var %escape = %delim
      var %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %escape $+ )/g,\1\2)
      var %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\//g,\1\/)
    }
  }
  if ($prop == val) { return $iif(%pat,$true,$false) }
  var %returnPattern = $+(/,%pat,/,%flags)
  var %substitution = %repl
  if ($prop == pat) { return %returnPattern }
  if ($prop == sub) { return $iif(%substitution,$v1) }
  if ($prop == getSub) { return %sub123 }
}

/*
The signal event
0 - Attempt was successful on all tests and is valid.
1 - Attempt failed a certain test, details in the message.
2 - User has not reached the given task yet.
3 - User has already queued a task to validate.
4 - The given regex is formatted incorrectly.
5 - Substitution text was provided on a task that doesn't require it.
6 - Finished the quiz
*/
on *:signal:validate: {
  var %u2n = $username2nick($1)
  if (!$3) {
    var %a = $regexUser($1,info,reached)
    if (%a < $calc($2 +1)) regexUser $1 info reached $v2
    sendTimer %u2n 2 $+ $($regexTask($2,finalMessage),2)
    if ($regexUser($1,info,reached) <= $regexTasks && $regexUser($1,info,reached) == $calc($2 +1)) {
      sendTimer %u2n 3Task $calc($2 +1) of $regexTasks $+ : $+([,$regexTask($calc($2 +1),title),]) $regexTask($calc($2 +1),description)
    }
  }
  else if ($3 == 1) { 
    sendTimer %u2n $4-
  }
  else if ($3 == 2) { 
    ; should never happen
    sendTimer %u2n You have not reached task $2 yet $1 $+ !
  }
  else if ($3 == 3) { 
    sendTimer %u2n You already have a task queued for validation! Please be patient, I'm working as fast as I can!
  }
  else if ($3 == 4) { 
    sendTimer %u2n Your regex is incorrectly formated. It's either /regex/, m/regex/ or s/regex/sub/. The delimiter (/) can be chosen to something else if / does not suit you.
  }
  else if ($3 == 5) { 
    sendTimer %u2n You provided a substitution string on a task that does not require it, please try again without it!
  }
  else if ($3 == 6) {
    sendTimer %u2n You have finished the quiz $1 $+ ! You can now look back at your patterns with !mypattern <task> and try to refine and improve them!
  }
  else if ($3 == 7) {
    sendTimer %u2n This task requires a substituion string! Use the following format: s/regex/sub/. The delimiter (/) can be chosen to something else if / does not suit you.
  }
  else if ($3 == 8) {
    sendTimer %u2n Your regex is malformed: $4-
  }
  if ($hget(regexDist, $1)) hdel regexDist $1
}
