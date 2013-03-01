.. _regular-expressions:

.. direct from book

*******************
Regular Expressions
*******************

The regular expression data type in Lasso allows for powerful search and
replace operations on strings and byte streams. This chapter details how
the regular expression data type works and other Lasso tags which can
use regular expressions.

-  `Overview`_ provides an introduction to regular expressions.
-  `Regular Expression Type`_ documents the ``[RegExp]`` type and how
   it can be used to create reusable regular expressions.
-  `String Tags`_ documents a number of string tags which also allow
   the use of regular expressions

Overview
========

A regular expression is a pattern that describes a sequence of
characters which you would like to find in a target (or input) string.
Regular expressions consist of letters or numbers which simply match
themselves, wild cards which match any character in a class such as
whitespace, and combining symbols which expand wild cards to match
several characters rather than just one.

The remainder of the overview discusses regular expressions in five
parts.

-  `Wild Cards`_ explains how individual characters and wild cards can
   be used to create simple regular expressions.
-  `Combining Symbols`_ explains how combining symbols can be used to
   expand wild cards.
-  `Groupings`_ explains how more complex sub-patterns can be created
   and how parts of a pattern can be designated for replacement.
-  `Replacements`_ explains how placeholders can be used in
   replacement expressions.
-  `Advanced Expressions`_ lists a number of advanced concepts
   including word boundaries, assertions, comments, and more.

.. Note:: Full documentation of regular expression methodology is
    outside the scope of this manual. Consult a standard reference on
    regular expressions for more information about how to use this
    flexible technology.

Wild Cards
----------

The simplest regular expression is just a word containing letters or
numbers. The regular expression ``bird`` is said to match the string
"bird". The regular expression ``123`` matches the string "123". The
regular expression is matched against an input string by comparing each
character in the regular expression to each character in the input
string one after another. Regular expressions are normally case
sensitive so the regular expression ``John`` would not match the string
"john".

Unicode characters within a regular expression work the same as any
other character. The escape sequence ``\u2FB0`` with the four-digit hex
value for a Unicode character can also be used in place of any actual
character (within regular expressions or any Lasso strings). The escape
sequence ``\u2FB0`` represents a Chinese character. Regular expressions
can also match part of a string. The regular expression bird is found
starting at position 3 in the string "A bird in the hand."

A regular expression can contain wild cards which match one of a set of
characters. ``[Jj]`` is a wild card which matches either an upper case
``J`` or a lower case ``j``. The regular expression ``[Jj]ohn`` will
match either the string "John" or the string "john". The wild card
``[aeiou]`` matches any vowel. The wild card ``[a-z]`` matches any lower
case roman letter. The wild card ``[0-9]`` matches any numeral. The wild
card ``[a-zA-Z]`` matches any upper or lower case roman letter. If a
Unicode character is used in a character range then any characters
between the hex value for the two characters are matched. The wild card
``[\u2FB0-\u2FBF]`` will match 16 different Chinese characters.

The period ``.`` is a special wild card that matches any single
character. The regular expression ``..`` would match any two character
string including "be", "12", or even "  " (two spaces). The period will
match any ASCII or Unicode character including punctuation or most white
space characters. It will not match return or new-line characters.

A number of predefined wild cards are available. The predefined wild
cards are all preceded by a double backslash ``\\``. This differs from
some regular expression implementation where the wild cards are preceded
by only a single backslash. The predefined wild cards all come in pairs.
The wild card ``\\s`` matches any white space character including tabs,
spaces, returns, or new lines. The wild card ``\\S`` matches any
non-white space character. The wild card ``\\w`` matches any
alphanumeric character or underscore. The "w" is said to stand for
"word" since these are all characters that may appear within a word. The
wild card ``\\W`` matches non-word characters. The wild card ``\\d``
matches any number and the wild card ``\\D`` matches any non-number. For
example, the regular expression ``\\w\\w\\w`` would match any three
character word such as "cat" or "dog". The regular expression
``\\d\\d\\d-\\d\\d\\d\\d-\\d\\d\\d\\d`` would match a standard United
States phone number "360-555-1212".

The predefined wild cards only work on standard ASCII strings. There is
a special pair of wildcards ``\\p`` and ``\\P`` which allow different
characters in a Unicode string to be matched. The wild card is specified
as ``\\p{Property}``. The full list of properties can be found in the
table below. For example the wild card ``\\p{L}`` matches any Unicode
letter character, the wild card ``\\p{N}`` matches any Unicode number,
and the wild card ``\\p{P}`` matches any Unicode punctuation characters.
The ``\\P{Property}`` wild card is the opposite. ``\\P{L}`` matches any
Unicode character which is not a letter.

The standard string entities for returns ``\r``, new-lines ``\n``, tabs
``\t``, and quotes ``\'`` or ``\"`` all match themselves when used in a
regular expression. These string entities only require a single
backslash. Many characters have special meanings in regular expressions
including ``[ ] ( ) { } . * + ? ^ $ | / \``. In order to match one of
these character literally it is necessary to use two backslashes in
front of it. For example ``\\[`` matches a literal opening square
bracket rather than starting a character range.

``a-z A-Z 0-9``
      Alphanumeric characters (and any other characters 
      not defined as symbols) match the specified       
      character. Case sensitive.                        

``.``
    Period matches any single character               
   
``[ ]``
    Character class. Matches any character contained  
      within the square brackets.                       
   
``[^ ]``
    Character exception class. Matches any character  
      which is not contained within the square brackets.
   
``[a-z]``
   Lower case character range. Matches any character 
      between the two specified.                        
   
``[A-Z]``
   Upper case character range.                       
   
``[a-zA-Z]``
   Combination character range.                      
   
``[0-9]``
   Numeric character range.                          
   
``[a-zA-Z0-9_]``
   Complex character range matches any letter,       
      number, or underscore.                            
   
``\t``
   Matches a tab character.                          
   
``\r``
   Matches a return character.                       
   
``\n``
   Matches a new-line character.                     
   
``\"``
   Matches a double quote.                           
   
``\'``
   Matches a single quote.                           
   
``\u####``
   Matches a single Unicode character. The number    
      signs should be replaced with the 4-digit hex     
      value for the Unicode character.                  
   
``\p{ }``       
      Matches a single Unicode character with the stated
      property. The available properties are listed in  
      the next table.                                   
   
``\\P{ }``      
      Matches a single Unicode character which does not 
      have the stated property. The available properties
      are listed in the next table.                     
   
``\\w``
   Matches an alphanumeric "word" character          
      (underscore included). Does not match Unicode characters.
   
``\\W``
   Matches a non-alphanumeric character (whitespace  
      or punctuation).                                  
   
``\\s``
   Matches a blank, whitespace character (space, tab,
      carriage return, etc.).                           
   
``\\S``
   Matches a non-blank, non-whitespace character.    
   
``\\d``
   Matches a digit character (0-9).                  
   
``\\D``
   Matches a non-digit character.                    
   
``\\ ``
    Escapes the next character. This allows any symbol
      to be specified as a matching character including 
      the reserved characters ``[ ] ( ) { } . * + ? ^ $ | / \``.                                          

.. Note:: Other than the built-in escaped characters ``\n``, ``\r``,
    ``\t``, ``\"``, and ``\'`` all other escaped characters in regular
    expressions should be preceded by two backslashes.

The following table contains all of the properties which can be used
with the ``\\p`` and ``\\P`` wild cards. The main symbol, e.g.
``\\p{L}`` will match all of the characters that are matched by each of
the variations.

``L``
    Matches a single letter. Variations include:      
      ``Lu`` - Uppercase Letter, ``Ll`` - Lowercase     
      Letter, ``Lt`` - Titlecase Letter, ``Lm`` -       
      Modifier Letter, and ``Lo`` - Other Letter.       
   
``N``
    Matches a single number. Variations include:      
      ``Nd`` - Decimal Digit Number, ``Nl`` - Letter    
      Number, and ``No`` - Other Number.                
   
``P``
    Matches a single punctuation character. Variations
      include: ``Pc`` - Connector Punctuation, ``Pd`` - 
      Dash Punctuation, ``Ps`` - Open Punctuation,      
      ``Pe`` - Close Punctuation, ``Pi`` - Initial      
      Punctuation, ``Pf`` - Final Punctuation, and      
      ``Po`` - Other Punctuation.                       
   
``S``
    Matches a single symbol. Variations include:      
      ``Sm`` - Math Symbol, ``Sc`` - Currency Symbol,   
      ``Sk`` - Modifier Symbol, and ``So`` - Other Symbol.
   
``Z``
    Matches a single separator (usually a white space 
      character). Variations include: ``Zs`` - Space    
      Separator, ``Zl`` - Line Separator, and ``Zp`` -  
      Paragraph Separator.                              
   
``M``
    Matches a single mark. Variations include: ``Mn`` 
      - Non-Spacing Mark, ``Mc`` - Spacing Combining    
      Mark, and ``Me`` - Enclosing Mark.                
   
``C``
    Matches a single "other" character. Variations    
      include: ``Cc`` - Control, ``Cf`` - Format, ``Cs``
      - Surrogate, ``Co`` - Private Use, and ``Cn`` -   
      Not Assigned.                                     
   

Combining Symbols
-----------------

Combining symbols allow wild cards to be expanded to match entire sub
strings rather than individual characters. For example, the wild card
``[a-z]`` matches one lower case letter and needs to be repeated three
times to match a three letter word ``[a-z][a-z][a-z]``. Instead, the
combining symbol ``{3}`` can be used to specify that the preceding wild
card should be repeated three times ``[a-z]{3}``.

The combining symbol ``+`` matches one or more repetitions of the
preceding wild card. The expression ``[a-z]+`` matches any string of
lower case letters. This expression matches the strings "a", "green", or
"international". It does not match "my dog spot" because that string
contains characters other than lower case letters (namely spaces).

The combining symbol ``+`` can be used with the ``.`` wild card to match
any string of one or more characters ``.+``, with the wild card ``\\w``
to match any word ``\\w+``, or with the wild card ``\\s`` to match one
or more whitespace characters ``\\s+``. The ``+`` symbol can also be
used with a simple letter to match one or more repetitions of the
letter. The regular expression ``Me+t`` matches both the string "Met"
and the string "Meet", not to mention "Meeeeeet".

The combining symbol ``*`` matches zero or more repetitions of the
preceding wild card. The ``*`` symbol can be used with the generic wild
card ``.`` to match any string of characters ``.*``. The ``*`` symbol
can be used with the whitespace wildcard ``\\w`` to match a string of
whitespace characters. For example, the expression ``\\w*cat\\w*`` will
match the string "cat", but also the string " cat ".

Braces are used to designate a specific number of repetitions of the
preceding wild card. When the braces contain a single number they
designate that the preceding wild card should be matched exactly that
number of times. ``[a-z]{3}`` matches any three lower case letters. When
the braces contain two numbers they allow for any number of repetitions
from the lower number to the upper number. ``[a-z]{3,5}`` matches any
three to five lower case letters. If the second number is omitted then
the braces function similarly to a ``+``. ``[a-z]{3,}`` matches any
string of lower case letters longer than three.

The symbol ``?`` on its own makes the preceding wild card optional. For
example, the expression ``mee?t`` will match either the string "met" or
"meet" since the second "e" is optional.

When used after a ``+``, ``*``, or braces the ``?`` makes the match
non-greedy. Normally, a sub-expression will match as much of the input
string as possible. The expression ``<.*>`` will match a string which
begins and ends with angle brackets. It will match the entire string
"<b>Bold Text</b>". With the greedy option the expression ``<.*?>`` will
match the shortest string possible. It will now match just the first
part of the string "<b>" and a second application of the expression will
match the last part of the string "</b>".

``+``
   Plus. Matches 1 or more repetitions of the        
      preceding symbol.                                 
   
``*``
   Asterisk. Matches 0 or more repetitions of the    
      preceding symbol.                                 
   
``?``
   Question Mark. Makes the preceding symbol optional.
   
``{n}``
   Braces. Matches ``n`` repetitions of the preceding symbol.
   
``{n,}``
   Matches at least ``n`` repetitions of the         
      preceding symbol.                                 
   
``{n,m}``
   Matches at least ``n``, but no more than ``m``    
      repetitions of the preceding symbol.              
   
``+?``
   Non-greedy variant of the plus sign, matches the  
      shortest string possible.                         
   
``*?``
   Non-greedy variant of the asterisk, matches the   
      shortest string possible.                         
   
``{ }?`` 
      Non-greedy variant of braces, matches the shortest
      string possible.                                  
   

Groupings
---------

Groupings are used for two purposes in regular expression. They allow
portions of a regular expression to be designated as groups which can be
used in a replacement pattern. And, they allow more complex regular
expressions to be built up from simple regular expressions.

Parentheses are used to designate a portion of a regular expression as a
replacement group. Most regular expressions are used to perform
find/replace operations so this is an essential part of designing a
pattern. Note that if parentheses are meant to be a literal part of the
pattern then they need to be escaped as ``\\(`` and ``\\)``. The regular
expression ``<b>(.*?)</b>`` matches an HTML bold tag. The contents of
the tag are designated as a group. If this regular expression is applied
to the string "<b>Bold Text</b>" then the pattern matches the entire
string and "Bold Text" is designated as the first group.

Similarly, a phone number could be matched by the regular expression
``\\((\\d{3})\\) (\\d{3})-(\\d{4})`` with three groups. The first group
represents the area code (note that the parentheses appear in both
escaped form ``\\( \\)`` to match a literal opening parenthesis and
normal form ``( )`` to designated a grouping). The second group
represents the prefix and the third group the subscriber number. When
the regular expression is applied to the string "(360) 555-1212" then
the pattern matches the entire string and generates the groups "360",
"555", and "1212".

Parentheses can also be used to create a sub-expression which does not
generate a replacement group using ``(?:)``. This form can be used to
create sub-expressions which function much like very complex wild cards.
For example, the expression ``(?:blue)+`` will match one or more
repetitions of the sub-expression blue. It will match the strings
"blue", "blueblue" or "blueblueblueblue".

The ``|`` symbol can be used to specify alternation. It is most useful
when used with sub-expressions. The expression ``(?:blue)|(?:red)`` will
match either the word "blue" or the word "red".

``( )``  
      Grouping for output. Defines a named group for    
      output. Nine groups can be defined.               
   
``(?: )``
      Grouping without output. Can be used to create a  
      logical grouping that should not be assigned to an
      output.

``|``
    Alternation. Matches either the character before  
    or the character after the symbol.                
   
Replacement Expressions
-----------------------

When regular expressions are used for find/replace operations the
replacement expression can contain place holders into which the defined
groups from the search expression are placed. The place holder ``\\0``
represents the entire matched string. The place holders ``\\1`` through
``\\9`` represent the first nine groupings as defined by parentheses in
the regular expression.

The regular expression ``<b>(.*?)</b>`` from above matches an HTML bold
tag with the contents of the tag designated as a group. The replacement
expression ``<em>\\1</em>`` will essentially replace the bold tags with
emphasis tags, without disrupting the contents of the tags. For example
the string "<b>Bold Text</b>" would result in "<em>Bold Text</em>" after
a find/replace operation.

The phone number expression ``\\((\\d{3})\\) (\\d{3})-(\\d{4})`` from
above matches a phone number and creates three groups for the parts of
the phone number. The replacement expression ``\\1-\\2-\\3`` would
rewrite the phone number to be in a more standard format. For example,
the string "(360) 555-1212" would result in "360-555-1212" after a
find/replace operation.

``\\0   \\9``
      Names a group in the replace string. ``\\0``      
      represents the entire matched string. Up to nine  
      groups can be specified using the numerals 1      
      through 9.                                        
   

.. Note:: Other than the built-in escaped characters ``\n``, ``\r``,
    ``\t``, ``\"``, and ``\'`` all other escaped characters in regular
    expressions should be preceded by two backslashes.

.. Note:: The ``[RegExp]`` type also supports ``$0`` and ``$1`` through
    ``$9`` as replacement symbols. In order to place a literal ``$`` in
    a replacement string it is necessary to escape it as ``\\$``.

Advanced Expressions
--------------------

Lasso supports a number of more advanced symbols for special purposes.
Some of these symbols are listed in the following table, but a reference
on regular expressions should be consulted for full documentation of
these symbols and other advanced concepts.

``(#)``
   Regular expression comment. The contents are not  
      interpreted as part of the regular expression.    
   
``(?i)``
   Sets the remainder of the regular expression to be
      case insensitive. Similar to specifying ``-IgnoreCase``.
   
``(?-i)``
   Sets the remainder of the regular expression to be
      case sensitive (the default).                     
   
``(?i:)``
   The contents of this group will be matched case   
      insensitive and the group will not be added to the output.
   
``(?-i:)``
   The contents of this group will be matched case   
      sensitive and the group will not be added to the output.
   
``(?=)``
   Positive look ahead assertion. The contents are   
      matched following the current position, but not   
      added to the output pattern.                      
   
``(?!)``
   Negative look ahead assertion. The same as above, 
      but the content must not match following the      
      current position.                                 
   
``(?<=)``
   Positive look behind assertion. The contents are  
      matched preceding the current position, but not   
      added to the output pattern.                      
   
``(?<!)``
   Negative look behind assertion. The same as above,
      but the contents must not match preceding the     
      current position.                                 
   
``\\b``
   Matches the boundary between a word and a         
      space. Does not properly interpret Unicode        
      characters. The transition between any regular    
      ASCII character (matched by ``\\w``) and a Unicode
      character is seen as a word boundary.             
   
``\\B``
   Matches a boundary not between a word and a space.
   
``^``
   Circumflex matches the beginning of a line.       
   
``$``
   Dollar sign matches the end of a line.            
   

Regular Expression Type
=======================

The regular expression type allows a regular expression to be defined
once and then re-used many times. It facilitates simple search
operations, splitting strings, and interactive find/replace operations.

The ``[RegExp]`` type has some advantages over the string tags which
perform regular expression operations. Performance can be increased by
compiling a regular expression once and then reusing it multiple times.
The regular expression type also allows for much more complex
find/replace operations.

The regular expression type has a number of member tags which allow
access to the stored regular expressions and input and output strings,
perform find/replace operations, or act as components in an interactive
find/replace operation. These are described in the following table and
additional tables in the sections about :ref:`Simple Find/Replace and
Split Operations <simple-find-replace-and-split-operations>` and
:ref:`Interactive Find/Replace Operations
<interactive-find-replace-operations>`.

Creating a Regular Expression
-----------------------------

The ``[RegExp]`` tag creates a reusable regular expression. The regular
expression type must be initialized with a ``-Find`` pattern. The type
will also store a ``-Replace`` pattern, and ``-Input`` string. These can
be overridden when particular member tags of the type are used. The type
also has an ``-IgnoreCase`` option which controls whether regular
expressions are applied with case sensitivity or not.

``[RegExp]``
   Creates a regular expression. Accepts the         
      following parameters.                             
   
``-Find``
   The find regular expression. Required.            
   
``-Replace``
   Replacement expression. Optional.                 
   
``-Input``
   Input string. Optional.                           
   
``-IgnoreCase``
   If specified then regular expressions will be     
      applied without case sensitivity. Optional        
   

A regular expression can be created which explicitly specifies the
``-Find`` pattern, ``-Replace`` pattern, ``-Input``, and ``-IgnoreCase``
option. Using a fully qualified regular expression which is output on
the page (rather than being stored in a variable) is an easy way to
perform a quick find/replace operation.

::

    [RegExp: -Find='[aeiou]', -Replace='x', -Input='The quick brown fox jumped over the lazy dog.', -IgnoreCase]
    ->
    Thx qxxck brxwn fxx jxmpxd xvxr thx lxzy dxg

However, usually a regular expression will be stored in a variable and
then run later against an input string. The following code stores a
regular expression with a find and replace pattern into the variable
``$MyRegExp``. The following section on :ref:`Simple Find/Replace and
Split Operations <simple-find-replace-and-split-operations>` will show
how this regular expression can be applied to strings.

::

    [Var: 'MyRegExp' = (RegExp: -Find='[aeiou]', -Replace='x', -IgnoreCase)]``

The tags in the following table allow the stored patterns and
input/output strings of a regular expression to be inspected and
modified.

``[RegExp->FindPattern]``
   Returns the find pattern. With a parameter sets a 
      new find pattern and resets the type.             
   
``[RegExp->ReplacePattern]``
   Returns the replacement pattern. With a parameter 
      sets a new replacement parameter.                 
   
``[RegExp->Input]``
   Returns the input string. With a parameter sets a 
      new input string.                                 
   
``[RegExp->IgnoreCase]``
   Returns True or False. With a boolean parameters  
      sets or clears the ignore case option.            
   
``[RegExp->GroupCount]``
   Returns an integer specifying how many groups were
      found in the find pattern.                        
   
``[RegExp->Output]``
   Returns the output string.                        
   

For example, the regular expression above can be inspected by the
following code. The group count is ``0`` since the find expression does
not contain any parentheses.

::

    FindPattern: [$MyRegExp->FindPattern]
    ReplacePattern: [$MyRegExp->ReplacePattern]
    IgnoreCase: [$MyRegExp->IgnoreCase]
    GroupCount: [$MyRegExp->GroupCount]

    ->
    FindPattern: [aeiou]
    ReplacePattern: x
    IgnoreCase: True
    GroupCount: 0

Simple Find/Replace and Split Operations
----------------------------------------

The regular expression type provides two member tags which perform a
find/replace on an input string and one tag which splits an input string
into an array. These tags are documented in the following table and
examples of their use follows. These tags are short cuts for longer
operations which can be performed using the interactive tags described
in the following section.

``[RegExp->ReplaceAll]``
   Replaces all occurrences of the current find      
      pattern with the current replacement pattern. The 
      ``-Input`` parameter specifies what string should 
      be operated on. If no input is provided then the  
      input stored in the regular expression object is  
      used. If desired, new ``-Find`` and ``-Replace``  
      patterns can also be specified within this tag.   
   
``[RegExp->ReplaceFirst]``
   Replaces the first occurrence of the current find 
      pattern with the current replacement pattern. Uses
      the same parameters as ``[RegExp->ReplaceAll]``.  
   
``[RegExp->Split]``
   Splits the string using the regular expression as 
      a delimiter and returns an array of               
      substrings. The ``-Input`` parameter specifies    
      what string should be operated on. If no input is 
      provided then the input stored in the regular     
      expression object is used. If desired, a new      
      ``-Find`` pattern can also be specified within    
      this tag.                                         
   

*To use the same regular expression on multiple inputs:*

The same regular expression can be used on multiple inputs by first
compiling the regular expression using the ``[RegExp]`` tag and then
calling ``[RegExp->ReplaceAll]`` with a new ``-Input`` as many times as
necessary. Since the regular expression is only compiled once this
technique can be considerably faster than using the
``[String_ReplaceRegExp]`` tag repeatedly.

::

    [Var: 'MyRegExp' = (RegExp: -Find='[aeiou]', -Replace='x', -IgnoreCase)]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='The quick brown fox jumped over the lazy dog.')]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='Lasso Professional 8.5')]

    ->
    Thx qxxck brxwn fxx jxmpxd xvxr thx lxzy dxg.
    Lxssx Prxfxssxxnxl 8.5

The replace pattern can also be changed if necessary. The following code
changes both the input and replace patterns each time the regular
expression is used.

::

    [Var: 'MyRegExp' = (RegExp: -Find='[aeiou]', -Replace='x', -IgnoreCase)]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='The quick brown fox jumped over the lazy dog.', -Replace='y')]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='Lasso Professional 8.5', -Replace='z')]

    ->
    Thy qyyck brywn fyy jympyd yvyr thy lyzy dyg.
    Lzssz Przfzsszznzl 8.5

The replacement pattern can reference groups from the input using
``\\1`` through ``\\9``. The following example uses a regular expression
to clean up telephone numbers. The regular expression is run on several
different phone numbers.

::

    [Var: 'MyRegExp' = (RegExp: -Find='\\((\\d{3})\\) (\\d{3})-(\\d{4})', -Replace='\\1-\\2-\\3 , -IgnoreCase)]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='(360) 555-1212')]
    [Encode_HTML: $MyRegExp->(ReplaceAll: -Input='(800) 555-1212')]

    ->
    360-555-1212
    800-555-1212

**To split a string using a regular expression:**

The ``[RegExp->Split]`` tag can be used to split a string using a
regular expression as the delimiter. This allows strings to be split
into parts using sophisticated criteria. For example, rather than
splitting a string on a comma, the  and  before the last item can be
taken into account. Or, rather than splitting a string on space, the
string can be split into words taking punctuation and other whitespace
into account.

The same regular expression from the example above can be used to split
a string into sub-strings. In this case the string will be split on
vowels generating an array with elements which contain only consonants
or spaces.

::

    [Var: 'MyRegExp' = (RegExp: -Find='[aeiou]', -Replace='x', -IgnoreCase)]
    [Encode_HTML: $MyRegExp->(Split: -Input='The quick brown fox jumped over the lazy dog.')]

    ->
    array: (Th), ( q), (), (ck br), (wn f), (x j), (mp), (d ), (v), (r th), ( l), (zy d), (g.)

The ``-Find`` can be modified within the ``[RegExp->Split]`` tag to
split the string on a different regular expression. In this example the
string is split on any run of one or more non-word characters. This
splits the string into words not including any whitespace or
punctuation.

::

    [Encode_HTML: $MyRegExp->(Split: -Find='\\W+', -Input='The quick brown fox jumped over the lazy dog.')]

    ->
    array: (The), (quick), (brown), (fox), (jumped), (over), (the), (lazy), (dog)

If the ``-Find`` expression contains groups then they will be returned
in the array in between the split elements. For example, surrounding the
``-Find`` pattern above with parentheses will result in an array of
alternating word elements and whitespace/punctuation elements.

::

    [Encode_HTML: $MyRegExp->(Split: -Find='(\\W+)', -Input='The quick brown fox jumped over the lazy dog.')]

    ->
    array:(The), ( ), (quick), ( ), (brown), ( ), (fox), ( ), (jumped), ( ), (over), ( ), (the), ( ), (lazy), ( ), (dog), (.)

Interactive Find/Replace Operations
-----------------------------------

The regular expression type provides a collection of member tags which
make interactive find/replace operations possible. Interactive in this
case means that Lasso code can intervene in each replacement as it
happens.

Rather than performing a simple one shot find/replace like those shown
in the last section, it is possible to programmatically determine the
replacement strings using database searches or any LassoScript logic.

The order of operations of an interactive find/replace operation is as
follows:

#. The regular expression type is initialized with a ``-Find`` pattern
   and ``-Input`` string. In this example the find pattern will match
   each word in the input string in turn.

   ::

        [Var: 'MyRegExp' = (RegExp: -Find='\\w+', -Input='The quick brown fox jumped over the lazy dog.', -IgnoreCase)]

#. A ``[While]   [/While]`` loop is used to advance the regular
   expression match with ``[RegExp->Find]``. Each time through the loop
   the pattern is advanced one match forward. If there are no further
   matches then the loop is exited automatically.

   ::

        [While: $MyRegExp->Find]

        [/While]

#. Within the ``[While]   [/While]`` loop the ``[RegExp->MatchString]``
   tag is used to inspect the current match. If the find pattern had
   groups then they could be inspected here by passing an integer
   parameter to ``[RegExp->MatchString]``.

   ::

        [Var: 'MyMatch' = $MyRegExp->MatchString]

#. The match is manipulated. For this example the match string will be
   reversed using the ``[String->Reverse]`` tag. This will reverse the
   word  lazy  to be  yzal .

   ::

        [$MyMatch->Reverse]

#. The modified match string is now appended to the output string using
   the ``[RegExp->AppendReplacement]`` tag. This tag will automatically
   append any parts of the input string which weren't matched (the
   spaces between the words).

   ::

        [$MyRegExp->(AppendReplacement: $MyMatch)]

#. After the ``[While]   [/While]`` loop the ``[RegExp->AppendTail]``
   tag is used to append the unmatched end of the input string to the
   output (the period at the end of the input).

   ::

        [$MyRegExp->AppendTail]

#. Finally, the output string from the regular expression object is
   displayed.

   ::

        [Encode_HTML: $MyRegExp->Output]

        ->
        ehT kciuq nworb xof depmuj revo eht yzal god.

This same basic order of operation is used for any interactive
find/replace operation. The power of this methodology comes in the
fourth step where the replacement string can be generated using any code
necessary, rather than needing to be a simple replacement pattern.

``[RegExp->Find]``
   Advances the regular expression one match in the  
      input string. Returns ``True`` if the regular     
      expression was able to find another               
      match. Defaults to checking from the start of the 
      input string (or from the end of the most recent  
      match). Optional ``-StartPos`` parameter sets the 
      position in the input string at which to start the search.

``[RegExp->MatchString]``
   Returns a string containing the last pattern      
      match. Optional ``-GroupNumber`` parameter        
      specifies a group from the find pattern to return 
      (defaults to returning the entire pattern match). 
   
``[RegExp->MatchPosition]``
   Returns a pair containing the start position and  
      length of the last pattern match. Optional        
      ``-GroupNumber`` parameter specifies a group from 
      the find pattern to return (defaults to returning 
      information about the entire pattern match).      
   
``[RegExp->AppendReplacement]``
   Performs a replace operation on the previous      
      pattern match and appends the result onto the     
      output string. Requires a single parameter which  
      specifies the replacement pattern including group 
      placeholders ``\\0   \\9``. Automatically appends 
      any unmatched runs from the input string.         
   
``[RegExp->AppendTail]``
   The final step in an interactive find/replace     
      operation. This tag appends the final unmatched   
      run from the input string onto the output string. 
   
``[RegExp->Reset]``
   Resets the type. If called with no parameters, the
      input string is set to the output string. Accepts 
      optional ``-Find``, ``-Replace``, ``-Input``, and 
      ``-IgnoreCase`` parameters.                       
   
``[RegExp->Matches]``
   Returns ``True`` if the pattern matches the entire
      input string. Optional ``-StartPos`` parameter    
      sets the position in the input string at which to 
      start the search.                                 
   
``[RegExp->MatchesStart]``
   Returns ``True`` if the pattern matches a         
      substring of the input string. Defaults to        
      checking the start of the input string. Optional  
      ``-StartPos`` parameter sets the position in the  
      input string at which to start the search.        
   

**To perform an interactive find/replace operation:**

This example searches for variable names with a dollar sign in an input
string and replaces them with variable values. An interactive
find/replace operation is used so that the existence of each variable
can be checked dynamically as the string is processed.

The string has several words replaced by variable references and each
variable is defined with a replacement word.

::

    Var: 'MyString' = 'The quick $brown fox $verb over the lazy $animal.';
    Var: 'color' = 'red';
    Var: 'verb' = 'soared';
    Var: 'animal' = 'ocelot';

A regular expression is initialized with the input string and a pattern
that looks for words which begin with a dollar sign. The word itself is
defined as a group within the find pattern. A ``[While]   [/While]``
loop uses ``[RegExp->Find]`` to advance through all the matches in the
input string. The tag ``[RegExp->MatchString]`` with a parameter of
``1`` returns the variable name for each match. If this variable exists
then its value is substituted back into output string using
``[RegExp->AppendReplacement]``, otherwise, the full match is
substituted back into the output string with the replacement pattern
``\\0``. Finally, any remaining unmatched input string is appended to
the end of the output string using ``[RegExp->AppendTail]``.

::

    Var: 'MyRegExp' = (RegExp: -Find='\\$(\\w+)', -Input=$MyString, -IgnoreCase);
    While: $MyRegExp->Find;
        Var: 'temp' = $MyRegExp->(MatchString: 1);
        If: (Var_Defined: $Temp);
            $MyRegExp->(AppendReplacement: (Var: $Temp));
        Else;
            $MyRegExp->(AppendReplacement: '\\0');
        /If;
    /While;
    $myregexp->AppendTail;

After the operation has completed the output string is displayed.

::

    Encode_HTML: $MyRegExp->Output;

    ->
    The quick red fox soared over the lazy ocelot.

String Tags
===========

The ``[String_FindRegExp]`` and ``[String_ReplaceRegExp]`` tags can be
used to perform regular expressions find and replace routines on text
strings.


``[String_FindRegExp]``
   Takes two parameters: a string value and a        
      ``-Find`` keyword/value parameter. Returns an     
      array with each instance of the ``-Find`` regular 
      expression in the string parameter. Optional      
      ``-IgnoreCase`` parameter uses case insensitive   
      patterns. Optional ``-MatchLimit`` sets the       
      recursive match limit for the tag (defaults to 100,000).

``[String_ReplaceRegExp]``
   Takes three parameters: a string value, a         
      ``-Find`` keyword/value parameter, and a          
      ``-Replace`` keyword/value parameter. Returns an  
      array with each instance of the ``-Find`` regular 
      expression replaced by the value of the           
      ``-Replace`` regular expression the string        
      parameter. Optional ``-IgnoreCase`` parameter uses
      case insensitive parameters. Optional             
      ``-ReplaceOnlyOne`` parameter replaces only the   
      first pattern match. Optional ``-MatchLimit`` sets
      the recursive match limit for the tag (defaults to 100,000).


.. Note:: By default Lasso uses a recursive match limit depth of
    100,000. The ``-MatchLimit`` parameter can be used in either the
    ``[String_FindRegexp]`` or ``[String_ReplaceRegExp]`` tag to modify
    the match limit if Lasso reports an error when using these tags.

**Examples of using [String_ReplaceRegExp]:**

The ``[String_ReplaceRegExp]`` tag works much like ``[String_Replace]``
except that both the ``-Find`` parameter and the ``-Replace`` can be
regular expressions.

-  In the following example, every occurrence of the world ``Blue`` in
   the string is replaced by the HTML code ``<font
   color="blue">Blue</font>`` so that the word ``Blue`` appears in blue
   on the Web page. The ``-Find`` parameter is specified so either a
   lowercase or uppercase ``b`` will be matched. The ``-Replace``
   parameter references ``\\1`` to insert the actual value matched into
   the output.

::

        [String_ReplaceRegExp: 'Blue Lake sure is blue today.',
            -Find='([Bb]lue)',
            -Replace='<font color="blue">\\1</font>', -EncodeNone]

            ->
            <font color="blue">Blue</font> lake sure is <font color="blue">Blue</font> today.

-  In the following example, every email address is replaced by an HTML
   anchor tag that links to the same email address. The ``\\w`` symbol
   is used to match any alphanumeric characters or underscores. The at
   sign ``@`` matches itself. The period must be escaped ``\\.`` in
   order to match an actual period and not just any character. This
   pattern matches any email address of the type ``name@example.com``.

::

        [String_ReplaceRegExp: 'Send email to documentation@lassosoft.com.',
            -Find='(\\w+@\\w+\\.\\w+)',
            -Replace='<a href="mailto:\\1">\\1</a>', -EncodeNone]

           ->
           Send email to <a href="documentation@lassosoft.com">documentation@lassosoft.com</a>

**Examples of using [String_FindRegExp]:**

The ``[String_FindRegExp]`` tag returns an array of items which match
the specified regular expression within the string. The array contains
the full matched string in the first element, followed by each of the
matched subexpressions in subsequent elements.

-  In the following example, every email address in a string is returned
   in an array.

::

       [String_FindRegExp: 'Send email to documentation@lassosoft.com.',
            -Find='\\w+@\\w+\\.\\w+']

           ->
           (Array: (documentation@lassosoft.com))

-  In the following example, every email address in a string is returned
   in an array and sub-expressions are used to divide the username and
   domain name portions of the email address. The result is an array
   with the entire match string, then each of the sub-expressions.

::

       [String_FindRegExp: 'Send email to documentation@lassosoft.com.',
            -Find='(\\w+)@(\\w+\\.\\w+)']

            ->
            (Array: (documentation@lassosoft.com), (documentation), (lassosoft.com))

-  In the following example, every word in the source is returned in an
   array. The first character of each word is separated as a
   sub-expression. The returned array contains 16 elements, one for each
   word in the source string and one for the first character
   sub-expression of each word in the source string.

::

       [String_FindRegExp: 'The quick brown fox jumped over a lazy dog.',
            -Find='(\\w)\\w*']

            ->
            (Array: (The), (T), (quick), (q), (brown), (b), (fox), (f), (jumped), (j),
            (over), (o), (a), (a), (lazy), (l), (dog), (d))

The resulting array can be divided into two arrays using the
following code. This code loops through the array (stored in
``Result_Array``) and places the odd elements in the array
``Word_Array`` and the even elements in the array ``Char_Array``
using the ``[Repetition]`` tag.

::

      [Variable: 'Word_Array' = (Array), 'Char_Array'=(Array)]
      [Variable: 'Result_Array' = (String_FindRegExp:
         'The quick brown fox jumped over a lazy dog.', -Find='(\\w)\\w*')]
      [Loop: $Result_Array->Size]
         [If: (Repetition) == 2]
            [$Char_Array->(Insert: $Result_Array->(Get: (Loop_Count)))]
         [Else]
            [$Word_Array->(Insert: $Result_Array->(Get: (Loop_Count)))]
         [/If]
      [Loop] <br>
      [Output:$Word_Array] <br>
      [$Char_Array]

      ->
      <br>(Array: (The), (quick), (brown), (fox), (jumped), (over), (a), (lazy), (dog))
      <br>(Array: (T), (q), (b), (f), (j), (o), (a), (l), (d))

-  In the following example, every phone number in a string is returned
   in an array. The ``\\d`` symbol is used to match individual digits
   and the ``{3}`` symbol is used to specify that three repetitions must
   be present. The parentheses are escaped ``\\(`` and ``\\)`` so they
   aren't treated as grouping characters.

::

       [String_FindRegExp: 'Phone (800) 555-1212 for information.'
          -Find='\\(\\d{3}\\) \\d{3}-\\d{4}']

       ->
       (Array: ((800) 555-1212))

-  In the following example, only words contained within HTML bold tags
   ``<b>   </b>`` are returned. Positive look ahead and look bind
   assertions are used to find the contents of the tags without the tags
   themselves. Note that the pattern inside the assertions uses a
   non-greedy modifier.

::

       [String_FindRegExp: 'This is some <b>sample text</b>!'
            -Find='(?<=<b>).+?(?=</b>)']

       ->
       (Array: (sample text))
