; -----------------------------------------
; zBot script by Lindrian
; Do not modify anything below if you do not know what you are doing!
; -----------------------------------------
on *:start: {
  var %x = $var(%zbot.table.*,0)
  while (%x) {
    var %r = $var(%zbot.table.*,%x).value
    if (!$hget($gettok(%r,1-2,32))) .hmake $gettok(%r,1-2,46) 1000
    if $exists(%r) { hload $gettok(%r,1-2,46) %r }
    dec %x
  }
  unset %zbot.table.*

  var %a = With 2(?=babe) you only see them when they are in front of you, with 2(?=.*babe) you'll even see them when they are far away and with 2(?<=babe) you'll see them when they are directly behind you.
  noop $zbot.add(#regex, babewatch, %a)
  noop $zbot.add(#regexen, babewatch, %a)
  %a = Regular Expressions Zero-Width Assertions (LookArounds: LookAheads & LookBehinds): 2Positive Lookahead (?=re) 2Negative Lookahead (?!re) 2Positive Lookbehind (?<=re) 2Negative Lookbehind (?<!re) 14Lookbehind must be fixed length (you cannot use quantifiers like ? * + or {m,n} for repetition).
  noop $zbot.add(#regex, lookahead, %a)
  noop $zbot.add(#regex, lookaheads, %a)
  noop $zbot.add(#regex, lookarounds, %a)
  noop $zbot.add(#regex, lookaround, %a)
  noop $zbot.add(#regexen, lookahead, %a)
  noop $zbot.add(#regexen, lookaheads, %a)
  noop $zbot.add(#regexen, lookarounds, %a)
  noop $zbot.add(#regexen, lookaround, %a)
  %a = ? babewatch, ? look(?:ahead|behind|around)s?, !explain /regex/, !regex <text> /regex/, !regex <text> s/regex/replacement/, ? bug
  noop $zbot.add(#regex, help, %a)
  noop $zbot.add(#regexen, help, %a)
  %a = If you have a found a bug with one of the components, please save the data to a file so it can be reproduced and tell Lindrian about it as soon as he is around. Thank you. 
  noop $zbot.add(#regex, bug, %a)
  noop $zbot.add(#regexen, bug, %a)
}
on *:unload: unset %zbot.*
on *:exit: {
  var %x = $hget(0)
  while (%x) {
    tokenize 46 $hget(%x)
    if (zbot* iswm $1) && ($2) {
      var %tbl = $+(zbot,.,$2) 
      .hsave -o %tbl %tbl $+ .hsh
      set $+(%,zbot,.,table,.,%tbl,.hsh) %tbl $+ .hsh
    }
    dec %X
  }
}
on *:disconnect: {
  var %x = $hget(0)
  while (%x) {
    tokenize 46 $hget(%x)
    if (zbot* iswm $1) && ($2) {
      var %tbl = $+(zbot,.,$2) 
      .hsave -o %tbl %tbl $+ .hsh
      set $+(%,zbot,.,table,.,%tbl,.hsh) %tbl $+ .hsh
    }
    dec %X
  }
}
alias zbot.add {
  var %tbl = $+(zbot,.,$1)
  if ($3) {
    if (!$hfind(%tbl,$2,1,w)) {
      hadd -m %tbl $2 $3-
      return $b($2) $+ : $3-
    }
    else {
      return $b($2) is already defined
    }
  }
  else {
    return Syntax: $b(!learn <key> <description>)
  }
}
alias zbot.remove {
  var %tbl = $+(zbot,.,$1)
  if ($2) {
    if ($hfind(%tbl,$2,1,w)) {
      hdel -w %tbl $2
      return $b($2) has been deleted
    }
    else {
      return $b($2) is not defined
    }
  }
  else {
    return Syntax: $b(!forget <key>)
  }
}
alias zbot.replace { 
  var %tbl = $+(zbot,.,$1)
  if ($3) {
    if ($hfind(%tbl,$2,1,w)) {
      hdel -w %tbl $2
      hadd -m %tbl $2 $3-
      return $b($2) $+ : $3-
    }
    else {
      return $b($2) is not defined
    }
  }
  else {
    return Syntax: $b(!replace <key> <description>)
  }
}
alias zbot.append {
  var %tbl = $+(zbot,.,$1)
  if ($3) {
    if ($hfind(%tbl,$2,1,w)) {
      var %x = $hfetch($1,$v1)
      var %t = $hget(%tbl,%x).data
      hadd -m %tbl $2 %t $3-
      return $b($2) $+ : %t $3-
    }
  }
}
alias zbot.last {
  var %tbl = $+(zbot,.,$1)
  if ($hget(%tbl,0).item == 0) return There is nothing defined
  var %x = 1, %t = $iif($2,$2,25), %z, %y = $iif(%t > $hget(%tbl,0).item,$v2,$v1)
  if (%t isnum 0-200) && (%x <= %t) {
    while (%x <= %t) {
      if ($hget(%tbl,%x).item) {
        %z = %z $v1
      }
      inc %x
    }
    return Last $b(%y) entries: %z
  }
  else {
    return Invalid number, $b($hget(%tbl,0).item) or below. Syntax: $b(!last <number>)
  }
}
alias zbot.find {
  var %tbl = $+(zbot,.,$1)
  var %nick = $iif($3,$3 $+ $chr(44))
  if ($2) {
    if ($hfind(%tbl,$2,1,w)) {
      var %x = $hfetch($1,$v1)
      return %nick $b($v1) $+ : $hget(%tbl,%x).data
    }
    else {
      return %nick $b($2) is not defined
    }
  }
  else {
    return Syntax: $b(?<key>)
  }
}
alias zbot.search {
  var %tbl = $+(zbot,.,$1), %b = Results for $b($2) $+ : , %c = 0
  if ($2) {
    var %i = $hfind(%tbl,$+(*,$2,*),0,w)
    if (%i > 30) {
      %b = $replace(%b, :, $+($chr(32),$chr(40),too many results,$chr(44),$chr(32),limited to 30,$chr(41),:))
    }
    while (%i > 0) {
      var %x = $hfind(%tbl,$+(*,$2,*),%i,w)
      %b = %b %x
      %c = 1
      dec %i
    }
    if (!%c) {
      %b = No result.
    }
    return %b
  }
  else {
    return Syntax: $b(!find <key>)
  }
}
alias hfetch {
  var %tbl = $+(zbot,.,$1)
  var %x = $hget(%tbl,0).item, %i = $2
  while (%x) {
    if ($hget(%tbl,%x).item == %i) {
      return %x
    }
    dec %x
  }
}
alias -l b return $+(,$1-,)
on *:TEXT:!zbot *:#: {
  if ($nick isop $chan) {
    if ($2 == activate) {
      if (!$istok(%zbot.chan,$chan,32)) {
        msg $chan zBot has been activated for $b($chan) $+ .
        set %zbot.chan %zbot.chan $chan
      }
      else {
        msg $chan zBot is already activated for $b($chan) $+ .
      }
    }
    elseif ($2 == deactivate) {
      if ($istok(%zbot.chan,$chan,32)) {
        msg $chan zBot for $b($chan) has been deactivated.
        set %zbot.chan $deltok(%zbot.chan,$findtok(%zbot.chan,$chan,1,32),32)
      }
      else {
        msg $chan zBot for $b($chan) is not activated.
      }
    }
  }
  else {
    .notice $nick You must be an operator or above to use this command
  }
}
on *:TEXT:!*:#: {
  if ($istok(%zbot.chan,$chan,32)) {
    if ($1 == !learn) msg $chan $zbot.add($chan,$2,$3-)
    elseif ($1 == !forget) msg $chan $zbot.remove($chan,$2)
    elseif ($1 == !append) msg $chan $zbot.append($chan,$2,$3-)
    elseif ($1 == !replace) msg $chan $zbot.replace($chan,$2,$3-)
    elseif ($1 == !last) msg $chan $zbot.last($chan,$2)
    elseif ($1 == !commands) {
      .notice $nick The commands are: !learn <key> <description>, !replace <key> <description>, !forget <key>, !last <number> (optional), !append <key> <description>, ? <key>
    }
    elseif ($1 == !find) msg $chan $zbot.search($chan,$2)
  }
}
on *:TEXT:?*:#: {
  if ($istok(%zbot.chan,$chan,32)) && ($1 == $chr(63)) {
    msg $chan $zbot.find($chan,$2,$3)
  }
}
; -----------------------------------------
; End of file
; -----------------------------------------
