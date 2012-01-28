on $*:text:/(*UTF8)^[@.!] *(explain|regex) */Si:#: {
  if ($regml(1) == explain) {
    if ($2- != $null) {
      explain $chan $remove($2-,$chr(1),$chr(4))
    } 
    else {
      msg $chan Syntax: !explain /regex/
    }
  }
  elseif ($regml(1) == regex) {
    if ($2- != $null) {
      if ($re($chan, $2-)) { msg $chan $v1 }
    } 
    else {
      msg $chan Syntax is: !regex <text> /regex/, !regex <text> s/regex/replacement/
    }
  }
}
on $*:text:/(*UTF8)^[@.?!] *(\S+)/S:#: {
  if ($regml(1) == babewatch) {
    msg $chan babewatch: With 2(?=babe) you only see them when they are in front of you, with 2(?=.*babe) you'll even see them when they are far away and with 2(?<=babe) you'll see them when they are directly behind you.
  }
  if ($regex(loltard,$regml(1),/(*UTF8)(?:look(?:(?:ahead|behind|around)s?))/i)) {
    msg $chan Regular Expressions Zero-Width Assertions (LookArounds: LookAheads & LookBehinds): 2Positive Lookahead (?=re) 2Negative Lookahead (?!re) 2Positive Lookbehind (?<=re) 2Negative Lookbehind (?<!re) 14Lookbehind must be fixed length (you cannot use quantifiers like ? * + or {m,n} for repetition).
  }
  if ($regml(1) == help) {
    msg $chan commands: ? babewatch, ? look(?:ahead|behind|around)s?, !explain /regex/, !regex <text> /regex/, !regex <text> s/regex/replacement/, ? bug
  }
  if ($regml(1) == bug) {
    msg $chan If you have a found a bug with one of the components, please save the data to a file so it can be reproduced and tell Lindrian about it as soon as he is around. Thank you. 
  }
}
on $*:text:/(*UTF8)^[@.!] *(explain|regex(?!quiz)) */Si:?: {
  if ($regml(1) == explain) {
    if ($2) {
      explain $nick $2-
    } 
    else {
      msg $nick Syntax: !explain /regex/
    }
  }
  elseif ($regml(1) == regex) {
    if ($2) {
      if ($re($nick, $2-)) { msg $nick $v1 }
    } 
    else {
      msg $nick Syntax is: !regex <text> /regex/, !regex <text> s/regex/replacement/
    }
  }
}
on $*:text:/(*UTF8)^[@.?!] *(\S+)/S:?: {
  if ($regml(1) == babewatch) {
    msg $nick babewatch: With 2(?=babe) you only see them when they are in front of you, with 2(?=.*babe) you'll even see them when they are far away and with 2(?<=babe) you'll see them when they are directly behind you.
  }
  if ($regex(loltard,$regml(1),/(*UTF8)(?:look(?:(?:ahead|behind|around)s?))/i)) {
    msg $nick Regular Expressions Zero-Width Assertions (LookArounds: LookAheads & LookBehinds): 2Positive Lookahead (?=re) 2Negative Lookahead (?!re) 2Positive Lookbehind (?<=re) 2Negative Lookbehind (?<!re) 14Lookbehind must be fixed length (you cannot use quantifiers like ? * + or {m,n} for repetition).
  }
  if ($regml(1) == help) {
    msg $nick commands: ? babewatch, ? look(?:ahead|behind|around)s?, !explain /regex/, !regex <text> /regex/, !regex <text> s/regex/replacement/, ? bug
  }
  if ($regml(1) == bug) {
    msg $nick If you have a found a bug with one of the components, please save the data to a file so it can be reproduced and tell Lindrian about it as soon as he is around. Thank you. 
  }
}
alias explain {
  regex.maketree $iif($1 ischan || $query($1),$1 $attemptFix($2-),LOCAL_ECHO $attemptFix($1-))
}
alias -l attemptFix {
  var %pattern = $1-
  ;%pattern = $regsubex(a,%pattern,/(*UTF8){(\d++(?:,?\d*+)?)}/g,$+($chr(65501),$regml(a,1),$chr(65500)))
  %pattern = $regsubex(a,%pattern,/(*UTF8){(?=(\d++(?:,?\d*+)?)\})/g,$chr(65501))
  %pattern = $regsubex(e,%pattern,/(*UTF8) $+ $chr(65501) $+ (\d++(?:,?\d*+)?)\K\}/g,$chr(65500))
  %pattern = $regsubex(b,%pattern,/(*UTF8)(?:(\\k)\{([^\}]++)\}|(\\g)(?:\{(\-?[1-9]|[^\}]+)\}))/g,$+($regml(b,1),$chr(50000),$regml(b,2),$chr(50001)))
  %pattern = $regsubex(c,%pattern,/(*UTF8)(?<!\{\d,|\{\d|{\d,\d|\\N){[^}]*\K\}/g,$chr(1000))
  %pattern = $regsubex(d,%pattern,/(*UTF8)(?<!N)\{(?!\d+(?:,\d*)?\})/g,$chr(4000))
  %pattern = $replace(%pattern,$chr(65501),$chr(123),$chr(65500),$chr(125))
  %pattern = $replace(%pattern,$chr(50000),$chr(123),$chr(50001),$chr(125))
  returnex %pattern
}
alias -l regex.msg { 
  .timerregex. $+ $+($r(a,z),$r(a,z),$r(0,9),$r(0,9)) 1 $calc($iif($regex.timer(regex.*),$v1,-2) +1) regex.msg2 $safe($1-) 
}
alias safe {
  var %chr1, %chr2, %chr3, %chrs

  if ($chr(32) isin $1) {
    while ($chr($rand(256, 65535)) isin $1) /
    %chr1 = $v1
  }

  if ($chr(40) isin $1) {
    while ($chr($rand(256, 65535)) isin $1) /
    %chr2 = $v1
  }

  if ($chr(41) isin $1) {
    while ($chr($rand(256, 65535)) isin $1) /
    %chr3 = $v1
  }

  %chrs = , %chr1 , %chr2 , %chr3

  returnex $!desafe(( $+ $replace($1, $chr(32), %chr1, $chr(40), %chr2, $chr(41), %chr3) ) %chrs ) 

}
alias desafe {
  returnex $replace($mid($1, 2, -1), $2, $chr(32), $3, $chr(40), $4, $chr(41))
}

alias -l regex.msg2 {
  msg $1-
  return
  :error
  reseterror
}
alias -l regex.timer {
  var %a = 1,%x,%r
  while ($timer(%a)) {
    var %r = $regsubex($v1,/(*UTF8)((?<!^\Q $+ $left($1,-1) $+ \E).)+/i,$null)
    if (%r) inc %x
    inc %a
  }
  returnex $iif(%x,%x,0)
}
alias -l regex.echo if ($2) !echo $fixBrackets($1-)
alias -l regex.MakeTree {
  var %target = $1, %pattern = $2-
  ;var %r = $regex(%pattern,/(*UTF8)^\s*+(?:(m)(.)|()(\/)|()())/)
  ; var %r = $regex(%pattern,/(*UTF8)^\s*+(?:(m)(.)|()([^a-z0-9A-Z])|()())/)
  var %r = $regex(%pattern,/(*UTF8)^\s*+(?:(m)(.)|()([^\\a-z0-9A-Z|#^()[{}.+*?$ $+ $chr(4000) $+ $chr(1000) $+ ])|()())/)
  var %sep = $replace($regml(2),\,\\,',\',$chr(35),\ $+ $chr(35))

  if (%sep isin |^()[{.+*?$#) {
    msg %target Please don't use meta characters as delimiters, it's no good.
    return
  }

  var %m = $regml(1), %notsep = $iif(%sep != $null,$+($chr(40),?!,%sep,$chr(41)))
  if (%sep != $null && $regex(%pattern,m'(*UTF8)\s*+ %m %sep .* %sep [gisSmoXAU]*+ x [gisSmoxXAU]*+$'x)) {
    %r = $regsub(%pattern,/(*UTF8)^\s++/,,%pattern)
    %r = m'(*UTF8)((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |[^\s\[\]\\] )*+) \s++ 'xg
    %r = $regsub(%pattern,%r,\1,%pattern)
    %r = m'(*UTF8)((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |[^\#\[\]\\] )*+) \# .*( $iif(%sep != $null,%sep [gisSmoxXAU]*+$) )'xg
    %r = $regsub(%pattern,%r,\1\2,%pattern)
  }
  ;set -nl %r m'(*UTF8)^\s*+ %m %sep ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))? ( (?: \| |( \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEkgNUuLl]|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]+)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\)]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^&\)]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|R&\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?:,\d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? ) %sep ([gisSmoxXAU]*+)$'x
  set -nl %r m'(*UTF8)^\s*+ %m %sep ( ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* (?: \| |\(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\) |( \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEkgNUuLl]|N(?!{\w++})|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]+)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\)]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^&\)]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|R&\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?:,\d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? ) %sep ([gisSmoxXAU]*+)$'x 
  if (!$regex(%pattern,%r)) { $iif($me ison %target,regex.msg2 $v2,regex.echo -a) $regex.ShowErrorIn(%target,%pattern,%sep,%m,%notsep) }
  elseif (%target != $null && $left(%target,1) != @) {
    var %pattern = $regml(1), %options = $regml(4)
    set -u0 %regex.BRs 0
    if ($hget(%target)) hdel -w %target Tree.*
    %r = $regex.Explain(%target,%pattern,1,$iif(i isincs %options,$true,$false),$iif(s isincs %options,$true,$false),$iif(m isincs %options,$true,$false),$iif(x isincs %options,$true,$false),$iif(X isincs %options,$true,$false),$iif(U isincs %options,$true,$false))
    %r = $regex.ExplainModifiers(%target,%options,1)
    regex.Hash2Tree %target
  }
}
alias -l regex.ShowErrorIn {
  var %target = $1, %pattern = $2, %sep = $3, %m = $4, %notsep = $5, %ingroup = $6, %gstart, %gend, %r
  var %longdesc = $true, %cmd = regex.msg %target 
  if (%target == LOCAL_ECHO) { %cmd = regex.echo -a }
  else if (%target == SHORT_DATA) {
    %longdesc = $false
    %cmd = returnex
  }
  if (!%ingroup) { %r = $regex(%pattern,m'(*UTF8)^(\s*+ %m %sep ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* (?: \| |( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?: (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEgk]|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]++)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|<?[=!]|P<[^>]++>)(?2)|[-ismxXUJ]*+|R|&[^& $+ $chr(41) $+ ]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*+)? )'x) }
  if (!%ingroup && $len($regml(1)) == $len(%pattern) && %sep != $null) { %cmd 5Expected `6 $+ %sep $+ 5` to end pattern $+(%pattern,4-» here) }
  else {
    if (!%ingroup) %r = $regex(patttrig,%pattern,m'(*UTF8)^(\s*+ %m %sep ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* (?: \||\(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\)| ( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?: (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEgk]|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]++)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\x29]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^& $+ $chr(41) $+ ]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? %sep [gisSmoxXAU]*+ )'x)
    if ( !%ingroup && %r > 0 && %sep != $null && $len($regml(patttrig,1)) != $len(%pattern) && $regex(%pattern,m'(*UTF8)^(\s*+ %m %sep ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* (?:(?: \(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\)| (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |(?:\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[|$^] )(?![?*+{]) |\\c. |\\[^QcbBAZzGE] |\((?:\?(?!\#))?+(?2)\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?+)?+ )*+ (?:\\Q(?:(?!\\E).)*)? ) %sep [^ $+ %sep $+ ]++ $ )'x) ) { 
      ; changed [a-zA-Z] to [^ $+ %sep $+ ]++ to catch all modifiers except the separator itself as that would instead be an invalid character.
      %cmd 5Invalid modifier in $+($regml(patttrig,1),4here -»,$mid(%pattern,$calc($len($regml(patttrig,1)) + 1))) 
    }
    else {
      if ( %ingroup ) {
        %gstart = (
        %gend = )
      }
      else {
        %r = $regsub(%pattern,/(*UTF8)^(\s*+ %m %sep )(.*)( %sep .*)$/x,\2,%pattern)
        %gstart = $regml(1)
        %gend = $regml(3)
      }
      ; backup       var %reg = m'(*UTF8)^( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* ( (?: \||\(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\)| ( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?: (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEkgNUuLl]|N(?!{\w++})|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]++)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\x29]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^&\x29]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*+)?+ ) (.)'x
      var %reg = m'(*UTF8)^( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* ( (?: \||\(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\)| ( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?: (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEkgNUuLl]|N(?!{\w++})|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]++)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\x29]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^&\x29]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*+)?+ ) (.)'x
      if ( $regex(%pattern,%reg) ) {
        var %lastbr = $regml(0), %b4 = $regml(1), %after = $mid(%pattern,$regml(%lastbr).pos), %verbReg = /^\Q(*\E[^\)]++\)/
        if ($regex(dontSaveThisShit, %after, /^\(\*(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\)/)) {
          %char = Verb placed at an invalid location
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here -»,%after,%gend)
        }
        elseif ($regex(fuckthis, %after, %verbReg)) {
          %char = Unrecognized verb
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here -»,%after,%gend)
          ;invalid verbs
        }
        elseif ($regex(fuckthis, %after, /^\\(?:[uUlL]|N{[^}]++})/)) {
          ; all unsupported escape sequences here
          %char = Unsupported escape sequence
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here -»,%after,%gend)
        }
        elseif ($regex(iReallyShouldGiveTheseADecentName, %after, /^\[[^:]*:[^:]++:\]/)) {
          ;invalid posix group
          %char = Invalid POSIX named set
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here -»,%after,%gend)
        }
        elseif ( $regml(%lastbr) == $null ) { %cmd 4Unknown syntax error (I can't find the position) }
        elseif ( $v1 != $chr(40) ) {
          var %char = Invalid character
          if ( $v1 isin +*?{} ) { %char = Quantifier with no preceding token }
          elseif ( $v1 == [[ ) {
            ;changed from regml(4) to regml(lastbr)
            if ( $mid(%pattern,$calc($regml(%lastbr).pos + 1),1) == ]] ) { %char = Empty charater class }
            else { %char = Unbalanced character class }
          }
          elseif ( $v1 == ]] ) { %char = Unbalanced character class }
          elseif ( $v1 == $chr(41) ) {
            %char = Unbalanced bracket
            %r = /(*UTF8)([^\(]*+) \( ( \?\#[^ $+ $chr(41) $+ ]*+ |(?!\?\#)(?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\])|\\Q(?:(?!\\E).)*+\\E|\\(?:c.|[^Qc])|[^()\\]|\((?2)\) )*+ ) \) /xg
            %r = $regsub(%b4,%r,\1(\2),%b4)
            %after = 6) $+ $mid(%after,2)
          }
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here -»,%after,%gend)
        }
        else {
          %r = /(*UTF8)^\((?:(?!\?)|\?(?:\#|>|[-ismxXUJ]*+:|<?[=!]|P<[^>]++>|[-ismxXUJ]*+|R|&[^&\)]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!])))/
          if ( !$regex(%after,%r) ) { %cmd 5Invalid construct in $+ $iif(%ingroup,$chr(32) $+ nested group) $+ : $+(%gstart,%b4,4here -»,%after,%gend) }
          else {
            %r = /(*UTF8)^\( ( (?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:c.|[^Qc])|[^()]|\((?!\?\#)(?1)\))*+ ) \)/x
            if ( $regsub(%after,%r,4 -»(\1)4«-,%after) ) {
              var %temp = $regml(1)
              ; %temp seems to do the trick for consecutive, simltaneous runs..?
              if ( %longdesc ) {
                %cmd 5Syntax error in $iif(%ingroup,nested) group $+(%gstart,%b4,%after,%gend)
                %r = $regex.ShowErrorInGroup(%target,%temp,%sep,%m,%notsep)
              }
              else { %cmd $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep) }
            }
            else {
              %r = /(*UTF8)^\( ( (?:\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:c.|[^Qc])|[^()]|\((?!\?\#)(?1)\))*+ ) \)/x
              if ( $regsub(%after,%r,4 -»(\1)4«-,%after) ) {
                if ( %longdesc ) {
                  %cmd 5Syntax error in $iif(%ingroup,nested) group $+(%gstart,%b4,%after,%gend)
                  %r = $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep)
                }
                else { %cmd $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep) }
              }
              else {
                %r = /(*UTF8)([^\(]*+) \( ( \?\#[^ $+ $chr(41) $+ ]*+ |(?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\Q(?:(?!\\E).)*+\\E|\\c.|\\[^Qc]|[^()\\]|\((?2)\) )*+ ) \) /xg
                %r = $regsub($mid(%after,2),%r,\1(\2),%after)
                %cmd 5Unbalanced group starts in $+(%gstart,%b4,4here -»,6,$chr(40),,%after,%gend)
              }
            }
          }
        }
      }
      else { %cmd 4Unknown syntax error (I can't find the position) }
    }
  }
  return
  :error
  regex.echo -a Your pattern caused an error in the script: $error
  reseterror
}
alias -l regex.ShowErrorInGroup { returnex $regex.ShowErrorIn($1,$2,$3,$4,$5,$true) }
alias -l regex.Explain {
  var %target = $removecs($1,_SPECIAL,_ESCAPE), %pattern = $2, %lvl = $3
  var %imode = $4, %smode = $5, %mmode = $6, %xmode = $7, %XXmode = $8, %Umode = $9
  var %N, %i, %r, %null = (null, matches any position)
  if ( %pattern == $null ) { $regex.RefOut(%target,%lvl) %null %quant }
  elseif ( $regex(%pattern,m'(*UTF8)( \G ( (?: \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?!\#))?+(?:\||(?2))*+\)| %notsep [^^$|*+?{()\[\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ )*+ ) (?:\\Q(?:(?!\\E).)*+$)?+ ) (\|)'gx) ) {
    %N = $v1
    %i = $regml(0)
    set -nl %patt.alt. $+ %lvl $+ . $+ $calc(%N + 1) $mid(%pattern,$calc($regml(%i).pos + $len($regml(%i))))
    %i = 0
    While (%i < %N) {
      inc %i
      set -nl %patt.alt. $+ %lvl $+ . $+ %i $regml($calc((%i - 1) * 3 + 1))
    }
    inc %N
    %i = 0
    While (%i < %N) {
      inc %i
      %r = $regex.Explain.Show(%target,%patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%lvl,$ord(%i) alternation: %patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
    }
  }
  elseif ( $regex(%pattern,m'(*UTF8)\G(( (?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|[^\]\r\n])++\]) |\(\*(?:[\w:]++)\)|\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|00?[1-7]|0)|\\(?:c.|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^\}]++)\}|[1-9])|[^Qcx^$|.*+?{()\[\]\\]) |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\((?:\?[-+]?(?!\#))?+(?:\+|\||(?1))*+\)| [$^.] |(?:\\(?:[|.$^*+?{()\[\]\\]|x[\da-fA-F]{1,2})|[^^$|.*+?{()\[\\]|\[\\?[\\"^$|*+?{}()\[\]\/]\]) (?:(?:\\(?:[|.$^*+?{()\[\]\\]|x[\da-fA-F]{1,2}+)|[^^$|.*+?{()\[\\]|\[\\?[\\"^$|.*+?{}()\[\]\/]\])+(?![?*+{]))? |\\Q(?:(?!\\E).)*+(?:\\E|$) ) (?:([*+?]|\{\d++(?: $chr(44) \d*+)?+\})([?+]?+)|()()) )'gx) ) {
    %N = $v1
    %i = 0
    var %j = 0, %refout, %quant
    While (%i < %N) {
      inc %i
      inc %j 2
      set -nl %patt.alt. $+ %lvl $+ . $+ %i $regml(%j)
      inc %j
      set -nl %patt.quant. $+ %lvl $+ . $+ %i $regml(%j)
      inc %j
      set -nl %patt.lazy. $+ %lvl $+ . $+ %i $regml(%j)
    }
    %i = 0
    While (%i < %N) {
      inc %i
      var %token = %patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ]
      %refout = $regex.RefOut(%target,%lvl)
      %quant = $regex.Explain.Quantifiers(%patt.quant. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%patt.lazy. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%Umode)
      if ( $regex(%token,/(*UTF8)^\(\?([-ismxXUJ]*+):(.*)\)$/) ) {
        if ( $regml(1) == $null ) { %r = $regex.Explain.Show(%target,$regml(2),%lvl,Group %token %quant,%imode,%smode,%mmode,%xmode,%XXmode,%Umode) }
        else {
          var %groupmodes = $regml(1), %grouppattern = $regml(2)
          %refout Group %token %quant
          %r = $regex.ExplainModifiers(%target,%groupmodes,$calc(%lvl + 1))
          var %gimode = %imode,%gsmode = %smode,%gmmode = %mmode,%gxmode = %xmode,%gXXmode = %XXmode,%gUmode = %Umode
          if ( (%gimode) && ($regex(%groupmodes,/(*UTF8)-.*i/) == 1) ) { %gimode = $false }
          elseif ( (!%gimode) && ($regex(%groupmodes,/(*UTF8)^[^-]*i/) == 1) ) { %gimode = $true }
          if ( (%gsmode) && ($regex(%groupmodes,/(*UTF8)-.*s/) == 1) ) { %gsmode = $false }
          elseif ( (!%gsmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*s/) == 1) ) { %gsmode = $true }
          if ( (%gmmode) && ($regex(%groupmodes,/(*UTF8)-.*m/) == 1) ) { %gmmode = $false }
          elseif ( (!%gmmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*m/) == 1) ) { %gmmode = $true }
          if ( (%gxmode) && ($regex(%groupmodes,/(*UTF8)-.*x/) == 1) ) { %gxmode = $false }
          elseif ( (!%gimode) && ($regex(%groupmodes,/(*UTF8)^[^-]*x/) == 1) ) { %gimode = $true }
          if ( (%gXXmode) && ($regex(%groupmodes,/(*UTF8)-.*X/) == 1) ) { %gXXmode = $false }
          elseif ( (!%gXXmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*X/) == 1) ) { %gXXmode = $true }
          if ( (%gUmode) && ($regex(%groupmodes,/(*UTF8)-.*U/) == 1) ) { %gUmode = $false }
          elseif ( (!%gUmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*U/) == 1) ) { %gUmode = $true }
          %r = $regex.Explain.Recurse(%target,%grouppattern,%lvl,%gimode,%gsmode,%gmmode,%gxmode,%gXXmode,%gUmode)
        }
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?([-ismxXUJ]++)\)$/) ) {
        var %groupmodes = $regml(1)
        %refout %token Modifiers
        %r = $regex.ExplainModifiers(%target,%groupmodes,$calc(%lvl + 1))
        if ( (%imode) && ($regex(%groupmodes,/(*UTF8)-.*i/) == 1) ) { %imode = $false }
        elseif ( (!%imode) && ($regex(%groupmodes,/(*UTF8)^[^-]*i/) == 1) ) { %imode = $true }
        if ( (%smode) && ($regex(%groupmodes,/(*UTF8)-.*s/) == 1) ) { %smode = $false }
        elseif ( (!%smode) && ($regex(%groupmodes,/(*UTF8)^[^-]*s/) == 1) ) { %smode = $true }
        if ( (%mmode) && ($regex(%groupmodes,/(*UTF8)-.*m/) == 1) ) { %mmode = $false }
        elseif ( (!%mmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*m/) == 1) ) { %mmode = $true }
        if ( (%xmode) && ($regex(%groupmodes,/(*UTF8)-.*x/) == 1) ) { %xmode = $false }
        elseif ( (!%imode) && ($regex(%groupmodes,/(*UTF8)^[^-]*x/) == 1) ) { %imode = $true }
        if ( (%XXmode) && ($regex(%groupmodes,/(*UTF8)-.*X/) == 1) ) { %XXmode = $false }
        elseif ( (!%XXmode) && ($regex(%groupmodes,/(*UTF8)^[^-]*X/) == 1) ) { %XXmode = $true }
        if ( (%Umode) && ($regex(%groupmodes,/(*UTF8)-.*U/) == 1) ) { %Umode = $false }
        elseif ( (!%Umode) && ($regex(%groupmodes,/(*UTF8)^[^-]*U/) == 1) ) { %Umode = $true }
      }
      elseif ( $regex(%token,/(*UTF8)^\(\*[\w:+]+\)$/) ) {
        %text = 4Undescribed specific verb 5No description for it yet (nothing's perfect)
        if (%token === (*UTF8)) { %text = Sets the property mode to UTF-8 }
        elseif (%token === (*UCP)) { %text = Sets the property mode to Unicode }
        elseif (%token === (*NO_START_OPT)) { %text = Suppresses the start-of-match optimizations that are otherwise run by PERL }
        elseif (%token === (*CR)) { %text = Specifies a newline convention: carriage return }
        elseif (%token === (*LF)) { %text = Specifies a newline convention: linefeed }
        elseif (%token === (*CRLF)) { %text = Specifies a newline convention: (*CR), followed by (*LF) }
        elseif (%token === (*ANYCRLF)) { %text = Specifies a newline convention: (*CR), (*LF) or (*CRLF) }
        elseif (%token === (*ANY)) { %text = Specifies a newline convention: all Unicode newline sequences }
        elseif (%token === (*BSR_ANYCRLF)) { %text = Specifies a newline convention: (*CR), (*LF) or (*CRLF) only }
        elseif (%token === (*BSR_UNICODE)) { %text = Specifies a newline convention: any Unicode newline sequence }
        elseif ($regex(%token, /\(\*(?:MARK)?:[^:]+\)/)) { %text = Marker verb whose main purpose is to track how a match was arrived at. }
        elseif (%token === (*FAIL)) { %text = Verb synonymous with (?!). Forces a matching failure at the given position in the pattern. }
        elseif (%token === (*F)) { %text = Shorthand for (*FAIL) }
        elseif ($regex(%token, /\(\*PRUNE(?::[^:]+)?\)/)) { %text = This verb causes the match to fail at the current starting position in the subject if the rest of the pattern does not match. }
        elseif (%token === (*COMMIT)) { %text = Causes the whole match to fail outright if the rest of the pattern does not match. }   
        elseif ($regex(%token, /\(\*THEN(?::[^:]+)?\)/)) { %text = Causes a skip to the next innermost alternative if the rest of the pattern does not match. }
        elseif ($regex(%token, /\(\*SKIP(?::[^:]+)?\)/)) { %text = Acts like (*PRUNE), except that  if the  pattern  is unanchored, the "bumpalong" advance is not to the next character, but to the position in the subject where (*SKIP) was encountered. }
        %refout %token %text
      }
      elseif ( $regex(%token,/(*UTF8)^\((?![?#])(.*)\)$/) ) {
        inc -u0 %regex.BRs
        %r = $regex.Explain.Show(%target,$regml(1),%lvl,$ord(%regex.BRs) Backreference %token %quant,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?=(.*)\)$/) ) {
        %refout %token Positive LookAhead
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?!(.*)\)$/) ) {
        %refout %token Negative LookAhead
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?<=(.*)\)$/) ) {
        %refout %token Positive LookBehind
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?<!(.*)\)$/) ) {
        %refout %token Negative LookBehind
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?>(.*)\)$/) ) {
        %refout %token Atomic Group %quant
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?\|(.*)\)$/) ) {
        %refout %token Duplicate Subpattern Number Group %quant (every capturing group inside an alternation starts from the same numerical value)
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?P?<([^>]++)>(.*)\)$/) ) {
        %refout %token Named group ' $+ $regml(1) $+ '
        %r = $regex.Explain.Recurse(%target,$regml(2),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?(\'[^\']++\')(.*)\)$/) ) {
        %refout %token Named group $regml(1)
        %r = $regex.Explain.Recurse(%target,$regml(2),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/(*UTF8)^\(\? (?#br1=cond)( \( ( (?: \[(?:\\c.|\\[^c]|\[:[^\]]*:\]|[^\]])++\] |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\c. |\\[^Qc] |\(\??(?2)\)| [^()\[] )*+ ) \) ) (?#br3=true)(( (?: \[(?:\\c.|\\[^c]|\[:[^\]]*:\]|[^\]])++\] |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\c. |\\[^Qc] |\(\??(?:\||(?4))*+\)| [^|()\[] )*+ )) (?#br5=[|false]?) (?:\|(.*))?\) $ /x) ) {
        var %pifcond = $regml(1), %piftrue = $regml(3), %piffalseexists = $iif($regml(0) >= 5,$true,$false), %piffalse = $regml(5), %newlvl = $calc(%lvl + 1), %newrefout = $regex.RefOut(%target,%newlvl)
        %refout %token IF clause %quant
        if ( $regex(%pifcond,/(*UTF8)^\(([+-])(\d++)\)$/) ) { %newrefout Condition: %pifcond True if the backreference $regml(2) is set $iif($regml(1) isin +-,2[relative] $getBackref($regml(2))) }
        elseif ( $regex(%pifcond,/(*UTF8)^\((<[^>]++>|\'[^\']++\'|(?:R&)\w+)\)$/) ) { 
          if ($regml(1) === R) {
            %newrefout Condition: %pifcond True if overall pattern recursion matches
          }
          elseif ($regex(abc,$regml(1),/(*UTF8)^R([1-9])$/)) {
            %newrefout Condition: %pifcond True if $regml(abc,1) $+ $ord($regml(abc,1)) recursive subpattern matches
          }
          elseif ($regex(ab,$regml(1),/(*UTF8)^R&(.+)$/)) {
            %newrefout Condition: %pifcond True if ' $+ $regml(ab,1) $+ ' recursive subpattern matches
          }
          elseif ($regex(def,$regml(1),/(*UTF8)^(<[^>]++>|\'[^\']++\')$/)) {
            %newrefout Condition: %pifcond True if the backreference ' $+ $right($left($regml(def,1),-1),-1) $+ ' is set
          }
          else {
            %newrefout Condition: %pifcond True if the backreference ' $+ $regml(1) $+ ' is set
          }
        }
        elseif ( $regex(%pifcond,/(*UTF8)^\(\?(<?)([=!])(.*)\)$/) ) {
          %newrefout Condition: %pifcond Evaluates the $iif($regml(1) == !,negative,positive) look $+ $iif($regml(1) == $null,ahead,behind)
          %r = $regex.Explain.Recurse(%target,$regml(3),%newlvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        }
        else { %newrefout Condition: %pifcond 4Error: It should be a zero width assertion }
        %r = $regsub(%piftrue,/(*UTF8)^\(\?:(.*)\)$/,\1,%piftrue))
        %r = $regex.Explain.Show(%target,%piftrue,%newlvl,True: %piftrue,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        if ( %piffalseexists ) {
          %r = $regsub(%piffalse,/(*UTF8)^\(\?:(.*)\)$/,\1,%piffalse))
          %r = $regex.Explain.Show(%target,%piffalse,%newlvl,False: %piffalse,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        }
      }
      elseif ( $regex(%token,/(*UTF8)^\(\?#([^ $+ $chr(41) $+ ]*+)\)$/) ) { %refout Comment: $regml(1) }
      elseif ( $regex(%token,/(*UTF8)^\\(\d++)$/) && $regml(1) isnum 1 - %regex.BRs ) { %refout %token Matches text saved in BackRef $regml(1) %quant }
      elseif ( $regex(%token,/(*UTF8)^\\g\{?(-?)([1-9])\}?$/) ) { %refout %token Matches text saved in BackRef $regml(2) %quant $iif($regml(1),2[relative] $getBackref($regml(2))) }
      elseif ( $regex(%token,/(*UTF8)^\\g\{?([^\}]+)\}$/) ) { %refout %token Matches text saved in BackRef ' $+ $regml(1) $+ ' %quant }
      elseif ( $regex(%token,/(*UTF8)^\\k(?|<([^>]++)>|\'([^\']++)\'|\{([^\}]++)\})$/) ) { %refout %token Matches text saved in BackRef ' $+ $regml(1) $+ ' %quant }
      elseif ( $regex(%token,/(*UTF8)^\(\?P=(.+)\)$/) ) {
        %refout %token Matches text saved in BackRef ' $+ $regml(1) $+ ' %quant
      }
      elseif ( $regex(%token,/(*UTF8)^\((\d++)\)$/) && $regml(1) isnum 1 - %regex.BRs ) { %refout %token Recurse BackRef $regml(1) %quant }
      elseif ( %token == (?R) || %token == (?0) ) { %refout %token Recurse the whole pattern %quant }
      elseif ( $regex(%token,/(*UTF8)^\Q(?\E([+-]?)([1-9]+)\)$/) ) { %refout %token Recurse the $ord($regml(2)) subpattern %quant $iif($regml(1) isin +-,2[relative] $getRecursion($regml(2),$regml(1))) }  
      elseif ( $regex(%token,/(*UTF8)^\Q(?\E&([^&]+)\)$/) ) { %refout %token Recurse the subpattern after group ' $+ $regml(1) $+ ' %quant }  
      elseif ( $regex(%token,/(*UTF8)^(\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\])$/) && %lvl == 2) {
        %refout $regml(1) $getCharClass($regml(1)) $replace($regml(1),:^,^:,:alnum:,A-Za-z0-9,:alpha:,A-Za-z,:blank:, \t,:cntrl:,\x00-\x1F\x7F,:graph:,\x21-\x7E,:lower:,a-z,:print:,\x20-\x7E,:punct:,$+($chr(93),$chr(91),!"#,$chr(36),%&',$chr(40),$chr(41),*+,$chr(44),./:;<=>?@\^_`,$chr(123),$chr(124),$chr(125),~-),:space:, \t\r\n\v\f,:upper:,A-Z,:xdigit:,A-Fa-f0-9) 14[POSIX]
      }
      elseif ( $regex(ncharclass,%token,/(*UTF8)^\[\^(.*)\]$/) ) {
        var %z = $regsubex($regml(ncharclass,1),/(*UTF8)\\([^pPXxCbBDsSwWhHvVRcgGAzZKQEd0-9aefnrt-\\])/gi,\1)
        var %newToken = $highlightClasses(%z)
        %refout Negated char class %token %quant matches any char except: $replace(%newToken, $chr(1234), $chr(160))
        noop $regex(posix,$regml(ncharclass,1),/(*UTF8)(\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\])/g)
        var %a = 1
        while (%a <= $regml(posix,0)) {
          %r = $regex.Explain.Recurse(%target,$regml(posix,%a),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
          inc %a
        }

        ; match \s and such
        noop $regex(explainshit,$regml(ncharclass,1),/(*UTF8)(?:\[:[^\]]*:\]|\\Q.*?\\E|(?|((?<!\\)(?:\\\\))|(?<!\\)(?:\\\\)*((?:\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|\\.))))/g)
        var %a = 1
        while (%a <= $regml(explainshit,0)) {
          var %e = $regml(explainshit,%a)
          if (%e != \\) {
            if (%e isincs \A\B\C\G\H\K\N\R\X\Z) {
              %r = $regex.Explain.Special.Literal(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
            elseif (%e isincs \b) {
              %r = $regex.Explain.Special.Escape(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
            else {
              %r = $regex.Explain.Recurse(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
          }
          inc %a
        }

      }
      elseif ( $regex(charclass,%token,/(*UTF8)^\[(.*)\]$/) ) { 
        var %z = $regsubex($regml(charclass,1),/(*UTF8)\\([^pPXxCbBDsSwWhHvVRcgGAzZKQEd0-9aefnrt-\\])/gi,\1)
        var %newToken = $highlightClasses(%z)
        %refout Char class %token %quant matches one of the following chars: $replace(%newToken, $chr(1234), $chr(160))
        noop $regex(posix,$regml(charclass,1),/(\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\])/g)
        var %a = 1
        while (%a <= $regml(posix,0)) {
          %r = $regex.Explain.Recurse(%target,$regml(posix,%a),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
          inc %a
        }

        ; match \s and such
        noop $regex(explainshit,$regml(charclass,1),/(*UTF8)(?:\[:[^\]]*:\]|(?|(\\Q.*?\\E)|((?<!\\)(?:\\\\))|(?<!\\)(?:\\\\)*((?:\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|\\.))))/g)
        var %a = 1
        while (%a <= $regml(explainshit,0)) {
          var %e = $regml(explainshit,%a)
          if (%e != \\) {
            if (%e isincs \A\B\C\G\H\K\N\R\X\Z) {
              %r = $regex.Explain.Special.Literal(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
            elseif (%e isincs \b) {
              %r = $regex.Explain.Special.Escape(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
            else {
              %r = $regex.Explain.Recurse(%target,%e,%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
            }
          }
          inc %a
        }
      }
      elseif (%token === \b && _SPECIAL_ESCAPE isin $1) {
        %refout %token %quant Backspace character
      }
      elseif ( $regex.Explain.Literal(%token,%imode,%smode,%mmode,%xmode,%XXmode,%Umode) != $null ) { 
        var %v1 = $v1
        %refout $iif(_SPECIAL isin $1, \) $+  %token %quant %v1 
      }
      elseif ( $regex(badbackref,%token,/(*UTF8)^\\(\d)$) ) { %refout %token %quant Possible error - Backreference to undefined numbered capturing group $regml(badbackref,1) }
      else { 
        %refout %token %quant 5(*) not described yet
      }
    }
  }
  else { $regex.RefOut(%target,%lvl) %token 4Unrecognized structure in %pattern 5No description for it yet (nothing's perfect) }
}

alias regex.Explain.Special.Escape {
  noop $regex.Explain.Recurse($1 $+ _SPECIAL_ESCAPE,$2,$3,$4,$5,$6,$7,$8,$9)
}

alias regex.Explain.Special.Literal {
  noop $regex.Explain.Recurse($1 $+ _SPECIAL,$remove($2,\),$3,$4,$5,$6,$7,$8,$9)
}

alias getCharClass {
  var %input = $remove($1, ^)
  if (^ isin $1) { returnex Negation of %input }
  if (%input == [:alnum:]) { returnex Alphanumeric characters }
  if (%input == [:word:]) { returnex Alphanumeric characters plus "_" }
  if (%input == [:alpha:]) { returnex Alphabetic characters }
  if (%input == [:blank:]) { returnex Space and tab }
  if (%input == [:cntrl:]) { returnex Control characters }
  if (%input == [:digit:]) { returnex Digits }
  if (%input == [:graph:]) { returnex Visible characters }
  if (%input == [:lower:]) { returnex Lowercase letters }
  if (%input == [:print:]) { returnex Visible characters and the space character }
  if (%input == [:punct:]) { returnex Punctuation characters }
  if (%input == [:space:]) { returnex Whitespace characters }
  if (%input == [:upper:]) { returnex Uppercase letters }
  if (%input == [:xdigit:]) { returnex Hexadecimal digits }
  if (%input == [:space:]) { returnex Whitespace characters }
}

alias highlightClasses {
  var %newToken = $1-, %msg
  ;var %re2 = /(*UTF8)(?|((?<!\\)(?:\\\\))|(?<!\\)(?:\\\\)*((?:\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|(?!\\[dpPXxCbBDsSwWhHvVRcgGAzZKQE\-])(?:[^\\]|\\.))))-(?|((?<!\\)(?:\\\\))|(?<!\\)(?:\\\\)*((?:\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|(?!\\[dpPXxCbBDsSwWhHvVRcgGAzZKQE\-])(?:[^\\]|\\.))))/g
  var %re2 = /(*UTF8)(?:\[:[^\]]*:\]|\\Q.*?\\E|(?|((?<!\\)(?:\\\\))|(?<!\\)(?:\\\\)*((?:\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|(?!\\[dpPXxCbBDsSwWhHvVRcgGAzZKQENR\-])(?:[^\\]|\\.))))-((?<!\\)(?:\\\\)|\\(?:[1-3][0-7]{2}|0?[1-7][0-7]|(?:00?)?[1-7]|0)|\\c[A-_]|\\x[\dA-F]{2}|(?!\\[dpPXxCbBDsSwWhHvVRcgGAzZKQENR\-])(?:[^\\]|\\.)))/g
  if ($regex(er, %newToken, %re2) && - isin %newToken) {
    var %i = 1, %a = $regml(er, 0)
    %msg = 7[3valid7 character ranges in green, 4invalid7 in red7]
    while (%i <= %a) {
      var %t1 = $regml(er,%i), %t2 = $regml(er,$calc(%i + 1))
      var %c1 = $asc(%t1), %c2 = $asc(%t2)
      var %r = $+(%t1,-,%t2), %r1 = %t1, %r2 = %t2
      if (%t1 == $chr(1234)) {
        %c1 = 32
        %r1 = $chr(160)
      }
      if (%t2 == $chr(1234)) {
        %c2 = 32
        %r2 = $chr(160)
      }

      if ($istokcs(\a \e \f \n \r \t \a \b,%t1,32)) {
        %c1 = $replacecs(%t1,\a,7,\e,27,\f,12,\n,10,\r,13,\t,9,\a,7,\b,8)
      }
      elseif ($regex(f1,%t1,/(*UTF8)^\\([^c])$/)) {
        %c1 = $asc($regml(f1,1))
      }
      if ($istokcs(\a \e \f \n \r \t \a \b,%t2,32)) {
        %c2 = $replacecs(%t1,\a,7,\e,27,\f,12,\n,10,\r,13,\t,9,\a,7,\b,8)
      }
      elseif ($regex(f2,%t2,/(*UTF8)^\\([^c])$/)) {
        %c2 = $asc($regml(f2,1))
      }

      if ($regex(o1, %t1, /(*UTF8)^\\([1-3][0-7]{2}|0?[1-7][0-7]|00?[1-7]|0)$/)) { 
        %c1 = $base($regml(o1, 1),8,10,0) 
        %r1 = $iif(%c1 == 50,$chr(160),$chr(%c1))
      }
      if ($regex(o2, %t2, /(*UTF8)^\\([1-3][0-7]{2}|0?[1-7][0-7]|00?[1-7]|0)$/)) { 
        %c2 = $base($regml(o2, 1),8,10,0)
        %r2 = $iif(%c2 == 50,$chr(160),$chr(%c2))
      }

      if ($regex(t1, %t1, /(*UTF8)^\\x([\dA-F]{2})$/)) { 
        %c1 = $base($regml(t1, 1),16,10,0)
        %r1 = $iif(%c1 == 50,$chr(160),$chr(%c1))
      }
      if ($regex(t2, %t2, /(*UTF8)^\\x([\dA-F]{2})$/)) {
        %c2 = $base($regml(t2, 1),16,10,0)
        %r2 = $iif(%c2 == 50,$chr(160),$chr(%c2))
      }

      if ($regex(t3, %t1, /(*UTF8)^\\c(.)$/)) { 
        %c1 = $calc($asc($regml(t3,1)) - 64) 
      }
      if ($regex(t4, %t2, /(*UTF8)^\\c(.)$/)) { 
        %c2 = $calc($asc($regml(t4,1)) - 64) 
      }
      if (%c1 > %c2) {
        %newToken = $replacecs(%newToken,%r,$+(01,$chr(44),04,%r1,-,%r2,))
      } 
      else {
        %newToken = $replacecs(%newToken,%r,$+(01,$chr(44),03,%r1,-,%r2,))
      }
      inc %i 2
    }
  }
  returnex %newToken %msg
}
alias -l regex.Explain.Recurse { var %r = $regex.Explain($1,$2,$calc($3 + 1),$4,$5,$6,$7,$8,$9) }
alias -l regex.RefOut Return { regex.Hash.AddTree $1 $2 }
alias -l regex.Hash.AddTree {
  var %regex.pat2 = $1, %text = $2-, %i = $hget(%regex.pat2,Tree.0)
  if (%i == $null) { %i = 1 }
  else { inc %i }
  hadd -m %regex.pat2 Tree.0 %i
  hadd %regex.pat2 Tree. $+ %i %text
}
alias -l regex.Hash2Tree {
  var %regex.pat2 = $1, %i = $hget(%regex.pat2,Tree.0), %lvl, %txt, %y = 1
  while (%y <= %i) {
    tokenize 32 $hget(%regex.pat2,Tree. $+ %y)
    if ( %lvl == $null ) { %lvl = $1 }
    elseif ( $1 < %lvl ) { %lvl = $1 }
    $iif($me ison %regex.pat2 || $query(%regex.pat2),regex.msg %regex.pat2,regex.echo -a) $regex.lvl($1,%lvl) $2-
    inc %y
  }
}
alias -l regex.lvl {
  var %blank = $calc($2 - 1), %branch = $calc($1 - %blank - 1)
  returnex $+(5,$chr(160),$str($str($chr(160),2),%blank),$str($+($chr(124),$chr(160)),%branch),+--»)
}
alias -l regex.Explain.Show {
  var %target = $1, %pattern = $2, %lvl = $3, %expl = $4, %expl.lit, %r
  var %imode = $5, %smode = $6, %mmode = $7, %xmode = $8, %XXmode = $9, %Umode = $10
  %expl.lit = $regex.Explain.Literal(%pattern)
  if (%expl.lit == $null) {
    $regex.RefOut(%target,%lvl) %expl
    %r = $regex.Explain(%target,%pattern,$calc(%lvl + 1),%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
  }
  else { $regex.RefOut(%target,%lvl) %expl %expl.lit }
}
alias -l regex.Explain.Literal {
  var %pattern = $1, %token = %pattern, %null = (null, matches any position), %r
  var %imode = $2, %smode = $3, %mmode = $4, %xmode = $5, %XXmode = $6, %Umode = $7
  %r = $regsub(patttriglit,%token,/(*UTF8)^\(\?\:(.*)\)$/,\1,%pattern)
  if ( %token == $null ) { returnex %null }
  elseif ( $v1 == ^ ) { returnex Start of $iif(%mmode,line,string) }
  elseif ( $v1 == $ ) { returnex End of $iif(%mmode,line,string) }
  elseif ( $v1 === \b ) { returnex Word boundary: match in between (^\w|\w$|\W\w|\w\W) }
  elseif ( $v1 === \B ) { returnex Negated word boundary: match any position where \b doesn't match }
  elseif ( $v1 === \A ) { returnex Start of string }
  elseif ( $v1 === \Z ) { returnex End of string }
  elseif ( $v1 === \z ) { returnex Absolute end of string }
  elseif ( $v1 === \G ) { returnex End of previous match or start of string (useful with the global modifier) }
  elseif ( $v1 === \K ) { returnex Resets the starting point of the reported match. Any previously matched characters are not included in the final matched sequence }
  elseif ( $v1 == . ) { returnex Any character $iif(!%smode,(except newline)) %quant }
  elseif ( $v1 === \d ) { returnex Digit [0-9] %quant }
  elseif ( $v1 === \D ) { returnex Any character that's not a digit %quant }
  elseif ( $v1 === \w ) { returnex Word character [a-zA-Z_\d] %quant }
  elseif ( $v1 === \W ) { returnex Negated word character [^a-zA-Z_\d] %quant }
  elseif ( $v1 === \s ) { returnex Whitespace [\t \r\n\f] %quant }
  elseif ( $v1 === \S ) { returnex Any char except whitespaces [^\t \r\n\f] %quant }
  elseif ( $v1 === \H ) { returnex Negated horizontal whitespace character %quant }
  elseif ( $v1 === \h ) { returnex Any horizontal whitespace character (equal to [:blank:]) %quant }
  elseif ( $v1 === \V ) { returnex Any vertical whitespace character %quant }
  elseif ( $v1 === \v ) { returnex Any character that's not a vertical whitespace character %quant }
  elseif ( $v1 === \N ) { returnex Any non-newline character %quant }
  elseif ( $v1 === \R ) { returnex Outside a character class, by default, the escape sequence \R matches any Unicode newline sequence. This can be modified using verbs. }
  elseif ( $v1 === \C ) { returnex Matches one byte, even in UTF-8 mode 5(best avoided) }
  elseif ( $regex(patttriglit,%token,/(*UTF8)^\\Q((?:(?!\\E).)*+)(?:\\E)?$/) ) { returnex Literal ` $+ $regml(patttriglit,1) $+ ` }
  elseif ( $istokcs(\t [\t] \x09 $chr(9),%token,32) ) { returnex Tab (ASCII 9) }
  elseif ( $istokcs(\r [\r] \xd \xD \x0d \x0D $cr,%token,32) ) { returnex Carriage return (ASCII 13) }
  elseif ( $istokcs(\n [\n] \xa \xA \x0a \x0A $lf,%token,32) ) { returnex Line-feed (newline) (ASCII 10) }
  elseif ( $istokcs(\f [\f] \xc \xC \x0c \x0C $chr(12),%token,32) ) { returnex Form feed (ASCII 12) }
  elseif ( $istokcs(\a [\a] \x7 \x07 $chr(7),%token,32) ) { returnex Bell (ASCII 7) }
  elseif ( $istokcs(\e [\e] \x1b \x1B $chr(27),%token,32) ) { returnex Esc (ASCII 27) }
  elseif ( $istokcs(\x20. .[ ],%token,46) ) { returnex Space (ASCII 32) }
  elseif ( $istokcs(\xa0 \xA0 $chr(160) \c?,%token,32) ) { returnex Hard Space (ASCII 160) }
  elseif ( $istokcs(\x08 \x8 $chr(8) [\b],%token,32) ) { returnex BackSpace (ASCII 8) }
  elseif ( $istokcs(\cb \x02 \x2 ,%token,32) ) { returnex Bold character (ASCII 2) }
  elseif ( $istokcs(\c_ \x1F ,%token,32) ) { returnex Underline char (ASCII 31) }
  elseif ( $istokcs(\cV \x16 ,%token,32) ) { returnex Reverse char (ASCII 22) }
  elseif ( $istokcs(\cc \x03 \x3 ,%token,32) ) { returnex Color code (ASCII 3) }
  elseif ( $istokcs(\co \x0F \xF \xf ,%token,32) ) { returnex Normal code (ASCII 15) }
  elseif ( $regex(patttriglit,%token,/(*UTF8)^\\c(.)$/) ) { returnex %token %quant Matches Ctrl+ $+ $regml(patttriglit,1) }
  elseif ( $regex(octal, %token,/(*UTF8)^\\([1-3][0-7]{2}|0?[1-7][0-7]|00?[1-7]|0)$/) ) {
    returnex %quant Octal Literal ` $+ $chr($base($regml(octal, 1),8,10,0)) $+ `
  }
  ;elseif ( $regex(patttriglit,%token,/(*UTF8)^(?:\\(?:x[0-9a-zA-Z]{1,2}|[\\"^$|.*+?{}()\[\]\/])|[^^$|.*+?{}()\[\]\\]|\[\\?[\\"^$|.*+?{}()\[\]\/]\])++$/) ) {
  elseif ( $regex(patttriglit,%token,/(*UTF8)^(?:\\(?:[^pPXxCbBdDsSwWhHvVRnrcgGAzZKQEtf1-9uUlLN]|x[0-9a-zA-Z]{1,2}|[-\'#&%½§´`¨~;,:_¤£@<>\\"^$|.*+?{!}()\[\]\/])|[^^$|.*+?{}()\[\\]|\[\\?[\\"^$|.*+?{}()\[\]\/]\])++$/) ) { 
    if ( $regex(patttriglit,%token,/(*UTF8)(\\([^x])|\[\\?([\\"^$|.*+?{}()\[\]\/])\]|\\x([0-9a-zA-Z]{1,2}))/g) ) {
      %r = $calc($regml(patttriglit,0) - 1)
      var %newchar
      While (%r > 0) {
        if ( $left($regml(patttriglit,%r),2) === \x ) { %newchar = $chr($base($regml(patttriglit,$calc(%r + 1)),16,10)) }
        else { %newchar = $regml(patttriglit,$calc(%r + 1)) }
        %token = $+($left(%token,$calc($regml(patttriglit,%r).pos - 1)),%newchar,$mid(%token,$calc($regml(patttriglit,%r).pos + $len($regml(patttriglit,%r)))))
        dec %r 2
      }
    }
    returnex Literal ` $+ %token $+ `
  }
}

alias -l regex.Explain.Quantifiers {
  if (!$1) { return }
  var %quant = $1, %possesive = $2, %Umode = $3, %lazy, $false, %from, %to, %inf = infinite, %extra, %extraK = 2
  %lazy = %Umode
  if ( %quant == * ) {
    %from = %inf
    %to = 0
  }
  elseif ( %quant == + ) {
    %from = %inf
    %to = 1
  }
  elseif ( %quant == ? ) {
    %from = 1
    %to = 0
  }
  elseif ( $regex(explainquantif,%quant,/(*UTF8)^\{(\d++)(?:(,)(\d*+))?\}$/) ) {
    %to = $regml(explainquantif,1)
    ;%from = $iif($regml(explainquantif,3) == $null && $regml(explainquantif,2) != $null,%inf,$iif($regml(explainquantif,3) == $null,%inf,$v1))
    if ($regml(explainquantif,2) != $null && $regml(explainquantif,3) == $null) {
      %from = %inf
    }
    elseif ($regml(explainquantif,2) != $null && $regml(explainquantif,3) != $null) {
      %from = $regml(explainquantif,3)
    }
    else {
      %from = %to
    }
  }
  if ( %possesive == + ) { %extra = %extraK $+ [possessive] }
  elseif ( %possesive == ? ) {
    if ( %lazy ) {
      %lazy = $false
      %extra = %extraK $+ [greedy]
    }
    else {
      %lazy = $true
      %extra = %extraK $+ [lazy]
    }
  }
  if ( %lazy ) {
    %lazy = %to
    %to = %from
    %from = %lazy
  }
  returnex 14 $+ %from $iif(%to != %from,to %to) times %extra
  ;returnex 14 $+ %to $iif(%to != %from,to %from) times %extra
}
alias -l regex.ExplainModifiers {
  var %target = $1, %modif = $2, %letter, %lvl = $3, %i = 0, %N = $len(%modif), %desc, %on = $true
  While ( %i < %N ) {
    inc %i
    %letter = $mid(%modif,%i,1)
    if ( %letter == - ) {
      %on = $false
      Continue
    }
    elseif ( %letter === g ) { %desc = global. All matches (don't return on first match) }
    elseif ( %letter === J ) {
      if ( %on ) { %desc = Allow duplicate subpattern names }
      else { %desc = Disallow duplicate subpattern names }
    }
    elseif ( %letter === i ) {
      if ( %on ) { %desc = insensitive. Case insensitive match (ignores case of [a-zA-Z]) }
      else { %desc = 7-insensitive. Case sensitive match }
    }
    elseif ( %letter === s ) {
      if ( %on ) { %desc = single line. Dot (or negated charclass) matches newline characters }
      else { %desc = 7-single line. A dot (or negated charclass) won't match \n }
    }
    elseif ( %letter === S ) { %desc = Strip. Ignores control codes in text (mIRC only) }
    elseif ( %letter === m ) {
      if ( %on ) { %desc = multi-line. Causes ^ and $ to match the begin/end of each line (not only begin/end of string) }
      else { %desc = 7-multi-line. ^ and $ match not only begin/end of string }
    }
    elseif ( %letter === o ) { %desc = option. This modifier was introduced as a mnemonic rule }
    elseif ( %letter === x ) {
      if ( %on ) { %desc = extended. Spaces and text after a `#` in the pattern are ignored }
      else { %desc = 7-extended. Spaces in pattern are literal spaces }
    }
    elseif ( %letter === X ) {
      if ( %on ) { %desc = eXtra. a \ followed by a letter with no special meaning is faulted }
      else { %desc = 7-eXtra. a \ followed by a letter with no special meaning matches that letter literally }
    }
    elseif ( %letter === A ) { %desc = Anchored. Pattern is forced to ^ }
    elseif ( %letter === U ) {
      if ( %on ) { %desc = Ungreedy. The match becomes lazy by default. Now a ? following a quantifier makes it greedy. }
      else { %desc = 7-Ungreedy. The match becomes greedy by default. }
    }
    else { %desc = no description for it yet. }
    $regex.RefOut(%target,%lvl) %letter $iif(%on,modifier,off) $+ : %desc
  }
}
alias re {
  var %input = $2-, %sre = /(*UTF8)^(?:(.*)\s)s([^\w\s\\])((?:\\.|(?!\\|\2).)*)\2((?:\\.|(?!\\|\2).)*)\2([^\|\^\(\)\[\{\.\+\*\?\\\$\#]*)\s*$/, $&
    %mre1 = /(*UTF8)^(.*)\sm?([^\w\s\\])((?:\\.|(?!\\|\2).)*)\2([^\|\^\(\)\[\{\.\+\*\?\\\$\#]*)\s*$/, %ret = $iif($isid,returnex,echo -ti12a), %retData
  ; [gisSmoxXAU] replaced with [^\|\^\(\)\[\{\.\+\*\?\\\$\#]* in order to allow explain engine to find the error
  if ($regex(sre,%input,%sre) isnum 1-) {
    var %delim = $regml(sre,2), %pat = $regml(sre,3), %repl = $regml(sre,4), %flags = $regml(sre,5)
    if (%delim != /) {
      if (%delim isin |^()[{.+*?\$#) var %escape = \ $+ %delim
      else var %escape = %delim
      var %pat = $regsubex(%pat,/(*UTF8)(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %escape $+ )/g,\1\2), %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\//g,\1\/)
    }
    var %repl = $regsubex(%repl,/(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %delim $+ )/g,\1\2), %result
    if ($regsub(repat,$regml(mre,1),$+(/(*UTF8),%pat,/,%flags),%repl,%result) isnum 1-) {
      %retData = $+([Result:,$chr(32),$v1,]) %result
    }
    else {
      %retData = Result: %result
    }
  }
  elseif (($regex(mre,%input,%mre1) isnum 1-)) {
    var %delim = $regml(mre,2), %pat = $regml(mre,3), %flags = $regml(mre,4)
    if (%delim != /) {
      if (%delim isin |^()[{.+*?\$#) var %escape = \ $+ %delim
      else var %escape = %delim
      var %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\\( $+ %escape $+ )/g,\1\2), %pat = $regsubex(%pat,/(*UTF8)(?<!\\)((?:\\\\)*)\//g,\1\/)
    }
    var %result
    if ($regex(repat,$regml(mre,1),$+(/(*UTF8),%pat,/,%flags)) isnum 1-) {
      %result = [Result: $v1 $+ ] $chr(9999)
      var %n = $regml(repat,0), %i = 1
      set -n %m $re_consumed(re,$regml(mre,1),$+(/(*UTF8),%pat,/,%flags),1)
      var %pos = $re_consumed(re,1).pos
      var %fullmatch = $+([0:,%pos,-,$iif(%m == $null,?,$calc(%pos + $len(%m) -1)),:,$chr(32),%m,])

      while (%i <= %n) {
        ;%result = %result $+ $iif(%i != 1,$chr(44)) $regml(repat,%i)
        var %result $addtok(%result,$+([,%i,:,$regml(repat,%i).pos,-,$iif($regml(repat,%i) == $null,?,$calc(($regml(repat,%i).pos) + $len($regml(repat,%i)) -1)),:,$chr(32),$regml(repat,%i),]),32)
        inc %i
      }
      %retData = $replace(%result,$chr(9999),%fullmatch)
    }
    else {
      %retData = [Result: 0]
    }
  }
  else {
    %retData = Syntax is: !regex <text> /regex/, !regex <text> s/regex/replacement/
  }
  if ($malformedRegex($1, $+(%delim,%pat,%delim,%flags))) {
    return
  }
  %ret %retData
}
alias msg {
  !msg $1 $fixBrackets($2-)
}
alias fixBrackets {
  return $replace($1-,$chr(4000),$chr(123),$chr(1000),$chr(125),$chr(1234),$chr(32))
}

alias getRecursion {
  returnex (refers to the $ord($1) most recently opened parentheses $iif($2 == -,preceding,subsequent to) the recursion)
}

alias getBackref {
  returnex (refers to the $ord($1) most recently started capturing subpattern before \g)
}

/*
{

  $re_parse(<expression>)[.prop]

  Takes in an mIRC regular expression and returns information
  about it. Note the distinction between an mIRC regex and a
  PCRE one: mIRC, being the application, interprets pattern
  enclosing characters and modifiers. Thus the expressions that
  this alias deals with are ones that are used, for example, in
  $regex(), $regsub(), /filter -g, $hfind(), etc.

  Properties:

  .compiles  - Returns $true if the pattern can be successfully
  compiled by PCRE, $false otherwise.
  .delimiter - Returns the pattern delimiter if one is used.
  .pattern   - Returns the expression fed to the PCRE library.
  .modifiers - Returns the modifiers in the expression, if any.
  .all       - Returns the name of a hash table containing results.

  .all saves you having to re-call $re_parse() if you need a full
  set of data. The hash table is filled with item names that match
  the properties above, and the scripter should ensure to /hfree
  the table when they are finished using it.

  Without a property, it defaults to .compiles.

}
*/

alias re_parse {

  var %re = /(*UTF8) ^ (?| m(.?)|(/?) ) ( (?: \(\* (?:                      $&
    NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP    $&
    ) \) )* ) (?| (.*)\1|(.*) ) (.*) /xs

  if (!$isutf($utfencode($1))) %re = 

  noop $regex(re_parse, $1, %re)

  if ($prop $+ * iswm delimiter) returnex $regml(re_parse, 1)
  if ($v1 iswm verbs) returnex $regml(re_parse, 2)
  if ($v1 iswm pattern) returnex $regml(re_parse, 3)

  var %modifiers = $regsubex(re_parse2, $regml(re_parse, 4), /[^AEgimsSUxX].*/s, )

  if ($v1 iswm modifiers) returnex %modifiers

  var %compiles = $istok($regex(,                                                  $&
    $+(/, $regml(re_parse, 2), |, $regml(re_parse, 3), /, $remove(%modifiers, g))  $&
    ), 1, 1)

  if ($v1 iswm all) {
    var %name

    :do {
      %name = re_parse $+ $rand(1, $not(0))
    }
    while ($hget(%name)) goto do

    ; "do/while in mIRC??" ;)

    hmake %name 10
    hadd %name compiles %compiles
    hadd %name delimiter $regml(re_parse, 1)
    hadd %name verbs $regml(re_parse, 2)
    hadd %name pattern $regml(re_parse, 3)
    hadd %name modifiers %modifiers

    returnex %name
  }

  if (!%re) returnex $false

  returnex %compiles
}

/*
{

  $re_consumed([name,] text, re [, N])[.pos]
  $re_consumed([name,] N)[.pos]

  Returns information about the parts of 'text' that are
  matched by 're'. 

  Syntax is sort of a combination of $regex() and $regml().

  If 'name' is supplied then you can refer to it later with
  $re_consumed(name, N)[.pos].

  If 'name' isn't supplied then you can refer to it later
  with $re_consumed(N)[.pos]

  N is optional, to return the Nth consumed substring, not
  relevant unless you use the 'g' modifier.

  If N is not supplied then it defaults to 0 if the 'g'
  modifier is used in the expression, '1' otherwise.

}
*/

alias re_consumed {
  var %marker1 = $cr, %marker2 = $lf, %prop = $iif($prop == pos, .pos)

  if ($1- isnum) {
    returnex $regml(re_consumed_, $1) [ $+ [ %prop ] ]
  }

  if ($2- isnum) {
    returnex $regml(re_consumed_ $+ $1, $2) [ $+ [ %prop ] ]
  }

  if ($0 isnum 2-4) {

    if ($0 == 2) || ($3- isnum) {
      var %name re_consumed_, %str = $1 ., %re = $2 ., %N $3
    }
    else {
      var %name = re_consumed_ $+ $1, %str = $2 ., %re = $3 ., %N $4
    }

    var %hsh = $re_parse($left(%re, -2)).all

    if (g isin $hget(%hsh, modifiers)) && (%N == $null) {
      %N = 0
    }

    if ($hget(%hsh, compiles)) {
      var %num = $regex(%name,                                                        $&
        $regsubex(str, $left(%str, -2), / $+ $hget(%hsh, verbs) $+                    $&
        $hget(%hsh, pattern) $+ \E\K/ $+ $hget(%hsh, modifiers), %marker1),           $&
        $+(/^\Q, $replacecs($regsubex(re, $left(%str, -2), $left(%re, -2), %marker2), $&
        \E, \E\\E\Q, %marker2, \E(.*)\Q $+ %marker1), \E$/UsA))

      hfree %hsh
      returnex $regml(%name, $int(%N 1)) [ $+ [ %prop ] ]
    }

    hfree %hsh
  }
}

alias malformedRegex {
  var %pattern = $2-
  var %r = $regex(%pattern,/(*UTF8)^\s*+(?:(m)(.)|()([^a-z0-9A-Z#|\\^()[{}.+*?$ $+ $chr(4000) $+ $chr(1000) $+ ])|()())/)
  var %sep = $replace($regml(2),\,\\,',\',$chr(35),\ $+ $chr(35))
  if (%sep isin |^()[{.+*?$) {
    return Please don't use meta characters as delimiters, it's no good.
  }
  var %m = $regml(1)
  var %notsep = $iif(%sep != $null,$+($chr(40),?!,%sep,$chr(41)))
  if (%sep != $null && $regex(%pattern,m'(*UTF8)\s*+ %m %sep .* %sep [gisSmoXAU]*+ x [gisSmoxXAU]*+$'x)) {
    %r = $regsub(%pattern,/(*UTF8)^\s++/,,%pattern)
    %r = m'(*UTF8)((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |[^\s\[\]\\] )*+) \s++ 'xg
    %r = $regsub(%pattern,%r,\1,%pattern)
    %r = m'(*UTF8)((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |[^\#\[\]\\] )*+) \# .*( $iif(%sep != $null,%sep [gisSmoxXAU]*+$) )'xg
    %r = $regsub(%pattern,%r,\1\2,%pattern)
  }
  set -nl %r m'(*UTF8)^\s*+ %m %sep ( (?:\Q(*\E(?:NO_START_OPT|CR|LF|CRLF|ANYCRLF|ANY|BSR_ANYCRLF|BSR_UNICODE|UTF8|UCP)\))* ( (?: \| |\(\*(?:ACCEPT|COMMIT|F|FAIL|(?:MARK)?:[^:]+|(?:PRUNE|SKIP|THEN)(?::[^:]+)?)\)| ( \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?:(?:\Q[^]]\E|\Q[]]\E|\[(?(?=\^)\^)\]?(?:\\(?:c.|[^c\r\n])|\[:\^?(?:alnum|alpha|word|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit):\]|(?!(?<![^\[\r\n]):[^:\r\n]+:(?![^\]\r\n]))[^\]\r\n])++\]) |\\(?:c.|[^QcbBAZzGEkgNUuLl]|N(?!{\w++})|k(?:<[^>]++>|\'[^\']++\'|\{[^\}]++\})|g(?:\{(?:\-?[1-9]|[^+\-\}]+)\}|[1-9])) |\((?:\?(?:(?:>|[-ismxXUJ]*+:|\||<?[=!]|(?:P=[^\)]++|P?<[^>]++>|\'[^\']++\'))(?2)|[-ismxXUJ]*+|R|&[^&\)]++|[-+]?\d++|\((?:<[^>]++>|\'[^\']++\'|(?:R&)\w+|[+-]\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\\] ) (?:(?:[*+?]|\{\d++(?:,\d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? ) %sep ([gisSmoxXAU]*+)$'x
  if (!$regex(%pattern,%r)) { return $regex.ShowErrorIn($1,%pattern,%sep,%m,%notsep) $true }

}
