on *:join:#: {
  if ($nick == $me) {
    .who $chan
  }
}
raw 352:*: haltdef
on *:TEXT:!submission *:#regex-bot: {
  if ($2 isnum 1-) {
    msg $chan $iif($read($regexDir $+ \submission.txt,n,$2),[By: $gettok($v1,1,32) @ $asctime($gettok($v1,2,32)) $+ ]: $gettok($v1,3-,32),No such submission ID!)
  }
  else if ($2 == 0) {
    msg $chan Submission count: $lines($regexDir $+ \submission.txt)
  }
}
on $*:TEXT:/^!(commands|help|login|register|regexquiz|stop|submit|info|try|task|newtry|testtry|lasttry|mypattern|alltasks)(\s+|$)/Si:?: {
  var %target = $iif($chan,$v1,$nick)

  if (%target !ischan && (%target !ison #regexen && %target !ison #regex && %target !ison #fittit)) {
    msg %target You need to be on either #regex or #regexen!
    return
  }

  if (!$findUserFromHost($address($nick,5)) && !$istok(commands help login register regexquiz submit stop,$regml(1),32)) { 
    sendTimer %target You need to 3!register before you can use me! If you have registered, use 3!login For further information use 3!help.
    return 
  }

  if ($regml(1) == login) || ($regml(1) == register) {
    var %file $+($regexDir,users\,$2,.ini)
    if ($2 && $3) {
      if ($regml(1) == login) {
        if ($readini(%file,n,info,password) == $md5($3)) {
          if ($readini(%file,n,info,host) != $address($nick,5)) {

            if ($nick != $2) {
              %extra = $+(,$chr(40),or should I say,$chr(32),$2,?,$chr(41),!)
            }
            sendTimer %target Welcome3 $nick %extra
            if ($address($nick,5) != $null) {
              writeini -n %file info host $address($nick,5)
              sendTimer %target Your host has been updated to $+(3,$address($nick,5),.) If your host changes again, just re-login!
            } 
            else {
              sendTimer %target I noticed your host changed but I can not grab it for some reason. You are however logged in for now.
            }
          }
          else {
            sendTimer %target 3You are already logged in $nick $+ , no need to do it twice!
          }
        }
        else {
          sendTimer %target 4Username or password incorrect. Are you looking to !register ?
        }
      }
      else {
        if (!$readini(%file,n,info,password)) {
          if (!$findUserFromHost($address($nick,5))) {
            ; the function above will return the username if it finds the ip is not unique, thus the !
            if ($2 isalnum) {
              if ($address($nick,5)) {
                writeini -n %file info username $2
                writeini -n %file info password $md5($3)
                writeini -n %file info host $address($nick,5)
                writeini -n %file info reached 1
                write -n hosts.txt $address($nick,5)
                sendTimer %target Congratulations $nick $+ ! You are now registered. Your IP $+($chr(40),4,$address($nick,5),,$chr(41)) has been stored. If your IP changes you will need to re-login, and you do so by typing 3!login <username> <password>. The indrotuction should begin shortly. Have fun!
                regexQuiz %target
              }
              else {
                sendTimer %target 4I was unable to aquire your IP for some reason. Please try again later
              }
            }
            else {
              sendTimer %target 3You may only use the following chracters in your username: [a-zA-Z0-9]
            }
          }
          else {
            sendTimer %target It would seem that you have previously registered with the username $+("4,$findUserFromHost($address($nick,5)),".) If you have forgotten your password contact an administrator!
          }
        }
        else {
          sendTimer %target 2This username is already taken, please try another.
        }
      }
    }
    else {
      sendTimer %target Syntax: ! $+ $regml(1) <username> <password>
    }
  }
  else if ($regml(1) == help || $regml(1) == commands) {
    sendTimer %target Welcome to the Freenode regex quiz. The purpose of this quiz is to help you learn regex quick and easy. We will be here with you all the way to help you. If you have any question feel free to ask them in channel ( $+ #regex $+ ).
    sendTimer %target Tutorial: 12http://www.regular-expressions.info/tutorialcnt.html
    sendTimer %target The commands are: !help, !login <username> <password>, !register <username> <password>, !regexquiz for the intro, !task for your current task, !lasttry the last pattern you tried, !mypattern <level> shows your solution for that level, $&
      !newtry <level> <pattern> to modify a solution, !alltasks shows all tasks, !submit <idea> send some feedback, !stop to stop your sending queue
    sendTimer %target !explain /regex/ will explain it bit by bit, !regex <text> /regex/ to test your pattern, !regex <text> s/regex/replacement/ to run a regub,  !credits The credits
    sendTimer %target Admins: !info [-u] <nick> [level|last] Shows nick's solutions for a certain lvl/his last try. The 3-u switch will conduct a username only search.
  }
  else if ($regml(1) == regexquiz) {
    var %f = $findUserFromHost($address(%target,5))
    if (%f) {
      regexQuiz %target
    }
    else {
      sendTimer %target 3Please !register first in order to take part of this amazing quiz.
    }
  }
  else if ($regml(1) == stop) {
    $+(.timer,%target,*) off
    sendTimer %target 2Queue halted.
  }
  else if ($regml(1) == submit) {
    if ($5) {
      sendTimer %target 3Thank you. We have received your submission and will review it shortly.
      write $+($regexDir,\submission.txt) $nick $ctime $2-
    }
    else {
      sendTimer %target 3I'm sure you have more to say than that ;-)!
    }
  }
  else if ($regml(1) == info) {
    if ($2) {
      var %u = $iif($2 == -u,$3,$2), %t = $iif($2 == -u,$4,$3)
      if ($findUserFromHost($address($2,5)) || ($2 == -u && $isfile($+($regexDir,users\,$3,.ini)))) {
        var %f = $findUserFromHost($address($nick,5)), %q = $iif($2 == -u,$3,$findUserFromHost($address($2,5)))
        %t = $replace($iif(%t isnum || %t == last,%t,last),last,$regexUser(%q,info,reached))
        if ($regexUser(%f,info,reached) >= $regexUser(%q,info,reached)) {
          if ($regexUser(%f,task $+ %t,shortest)) {
            if ($regexUser(%q,task $+ %t,shortest)) {
              if ($len($regexUser(%f,task $+ %t,shortest)) <= $len($regexUser(%q,task $+ %t,shortest))) {
                sendTimer %target 3 $+ %u LEVEL $regexUser(%q,info,reached) Sol  %t $+ : $regexUser(%q,task $+ %t,shortest) 15( $+ $len($regexUser(%q,task $+ %t,shortest)) chars)
              }
              else {
                sendTimer %target 4Sorry,3 %q $+ 's4 solution is shorter than yours. I will not show it to you! 
              }
            }
            else {
              if ($regexUser(%q,task $+ %t,last)) {
                sendTimer %target LVL: $regexUser(%q,info,reached) $+ , $regexTask(%t,description) Last try: $regexUser(%q,task $+ %t,last)
                sendTimer %target Fails on: $regexUser(%q,task $+ %t,fail)
              }
              else {
                sendTimer %target 3 $+ %u LEVEL $regexUser(%f,info,reached) has not $iif($regexUser(%q,info,reached) >= %t,started on,reached) 3task %t $+  yet
              }
            }
          }
          else {
            sendTimer %target 4You have not solved 3task %t $+  4yet
          }
        }
        else {
          sendTimer %target 4You have not solved 3task %t $+  4yet
        }
      }
      else {
        sendTimer %target $+(3,%u,4) not found. Syntax: !info [-u] <nickname|username> [level|last]
      }
    }
    else {
      sendTimer %target 3You need to specifiy a nick- or username!
    }
  }
  else if ($regml(1) == task) {
    if ($2 isnum 1-) {
      if ($2 <= $regexTasks) {
        var %f = $findUserFromHost($address($nick,5))
        if ($2 <= $regexUser(%f,info,reached)) {
          if ($regexUser(%f,task1,attempts)) {
            sendTimer %target 3Task $2 of $regexTasks $+ : $+([,$regexTask($2,title),]) $regexTask($2,description)
          }
          else {
            regexQuiz %target
          }
        }
        else {
          sendTimer %target 4You have not reached task $2 yet!
        }
      }
      else {
        sendTimer %target 2Task $2 does not exist yet! Perhaps you could !submit it?
      }
    }
    else {
      var %f = $findUserFromHost($address($nick,5))
      if ($regexUser(%f,info,reached) > $regexTasks) {
        .signal validate %f $v1 6
        return
      }
      var %f = $regexUser($findUserFromHost($address($nick,5)),info,reached)
      sendTimer %target 3Task %f of $regexTasks $+ : $+([,$regexTask(%f,title),]) $regexTask(%f,description)
    }
  }
  else if ($regml(1) == try) {
    var %f = $findUserFromHost($address($nick,5))
    if ($regexUser(%f,info,reached) > $regexTasks) {
      .signal validate %f $v1 6
      return
    }
    else {
      if ($2) noop $validateRegex(%f, $regexUser(%f,info,reached), $2-)  
      else sendTimer %target 3You forgot to input a /regular expression/!
    }
  }
  else if ($regml(1) == newtry) {
    if ($2 isnum 1-) {
      if ($2 <= $regexTasks) {
        var %f = $findUserFromHost($address($nick,5))
        ; $2 <= $regexUser(%f,info,reached)
        if ($2 <= $regexUser(%f,info,reached)) {
          noop $validateRegex(%f, $2, $3-)
        }
        else {
          sendTimer %target 4You have not reached task $2 yet!
        }
      }
      else {
        sendTimer %target 2Task $2 does not exist yet! Perhaps you could !submit it?
      }
    }
    else {
      sendTimer %target 3You need to provide a task number! Syntax is !newtry <task> /regex/
    }
  }
  else if ($regml(1) == lasttry) {
    ; if $2 ... (admin shit)
    var %a = $regexUser($findUserFromHost($address($nick,5)),info,reached)
    if ($regexUser($findUserFromHost($address($nick,5)),task $+ %a,last)) {
      sendTimer %target 3Last Try: $v1
    }
    else {
      sendTimer %target 3Last Try: 4Not Found. Did you change log in?
    }
  }
  else if ($regml(1) == mypattern) {
    if ($2 isnum 1-) {
      if ($2 <= $regexTasks) {
        var %f = $findUserFromHost($address($nick,5))
        if ($2 < $regexUser(%f,info,reached)) {
          sendTimer %target 3Task $2 $+  $regexTask($2,title) $+  $regexUser(%f,task $+ $2,shortest) $+(14,$chr(40),$len($regexUser(%f,task $+ $2,shortest)),$chr(32),chars,$chr(41)) $+(12,$chr(40),shortest:,$chr(32),$gettok($regexTask($2,shortest),2,32),$chr(32),chars,$chr(41))
        }
        else {
          sendTimer %target 4You have not completed task $2 yet!
        }
      }
      else {
        sendTimer %target 2Task $2 does not exist yet! Perhaps you could !submit it?
      }
    }
    else {
      sendTimer %target 3You need to input a task number to retreive the regex for!
    }
  }
  else if ($regml(1) == alltasks) {
    ;$regexUser(test123,task2,shortest)
    var %f = $findUserFromHost($address($nick,5))
    if ($regexUser(%f,task1,shortest)) {
      var %i = 1
      while ($regexUser(%f,task $+ %i,shortest)) {
        sendTimer %target 3Task %i $+  $regexTask(%i,title) $+  $regexUser(%f,task $+ %i,shortest) $+(14,$chr(40),$len($regexUser(%f,task $+ %i,shortest)),$chr(32),chars,$chr(41)) $+(12,$chr(40),shortest:,$chr(32),$gettok($regexTask(%i,shortest),2,32),$chr(32),chars,$chr(41))
        inc %i
      }
    } 
    else {
      sendTimer %target You have not completed any tasks yet.
    }
  }
}
alias -l regexQuiz {
  sendTimer $1 Welcome to the 7Freenode regex quiz.
  sendTimer $1 The objective of the game is to provide a valid solution to every regex task given. All tasks are related to PCRE.
  sendTimer $1 In a moment, you will receive your next task. You may take as long as you need to solve it. When you're ready to provide a solution message me with the text !try /pattern/
  sendTimer $1 Some other tasks are intended to replace text, where the quiz will evaluate your pattern using $!!regsub(). In such tasks, use !try s/pattern/substitution/[flags]
  sendTimer $1 I will perform a few tests to the pattern you provide for each task. If you submit an incorrect solution, I'll try to point out the error or the text that makes it fail (sometimes I use colors - please don't strip them).
  sendTimer $1 You won't receive the next task until you successfully provide a solution. It may take you a very long time to finish, take it as a learning experience and please don't ask for help on topics explained in the tutorial: 12http://www.regular-expressions.info/tutorialcnt.html
  sendTimer $1 Other Commands: !task to read your current task again. !lasttry to see your last try in the current level. !mypatterns to see your solutions for each level. !submit <idea> if you have an idea for a new task or a comment. Or !help
  sendTimer $1 If you still need more help with regex syntax, ask in #regex @ Freenode. But, please, keep in mind that channel is for regex help. Quiz questions are considered spam there, and you'll be banned if you post a quiz solution.
  sendTimer $1 Good luck!
  sendTimer $1 3Task 1 of $!regexTasks $+ : $+([,$regexTask(1,title),]) $!regexTask(1,description)
}
alias findUserFromHost {
  var %a = 1
  while ($findfile($+($regexDir,users\),*.ini,%a,1)) {
    var %u = $left($nopath($v1),-4)
    if ($readini($v1,n,info,host) == $1) {
      returnex %u
    }
    inc %a
  }
  return
}
alias sendTimer {
  var %i = 0, %j = 1
  while ($timer(%i)) {
    if ($regex($v1,/^ $+ $1 $+ =\w+/i)) inc %j 2
    ;inc %j $iif(%j > 1,2,1)
    inc %i
  }
  $+(.timer,$1,=,$r(a,z),$r(0,9),$r(a,z),$r(0,9),$r(a,z),$r(0,9),$r(a,z)) 1 %j msg $1 $2-
}
alias username2nick returnex $ial($regexUser($1,info,host)).nick
alias regexFile returnex $mircdir $+ regex/users.ini
alias regexDir returnex C:\Users\Firas\Desktop\Freenode-regex-quiz\
