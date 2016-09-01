### reST formatting

For reST markup, we're mostly following the example set by the [Python docs style guide](https://docs.python.org/devguide/documenting.html).

* files end with a blank line (this can be enforced by most text editors)
* paragraphs are wrapped to 80 characters
 	* max width for monospaced blocks is 103 chars at current font size
* sentences end with a single space
	* But if you want to use two spaces, [go](http://xkcd.com/1285/) [ahead](http://www.heracliteanriver.com/?p=324).
* markup for list items:
	* unordered: dash, space, space
	* ordered: hash, dot, space
	* subsequent lines are indented three spaces
	* multi-sentence list items may be separated by a blank line for readability
* use uneducated single and double quotes; Sphinx uses SmartyPants to educate them
	* Currently the first quote of ".abc" becomes a closing quote; see the [issue report](https://github.com/sphinx-doc/sphinx/issues/580) for details and the workaround.
* markup for headings:
	* `%` over/under indented - volume title
	* `#` over/under indented - part title
	* `*` over/under - chapter title
	* `=`, `-`, `^` underline - chapter sections
* section titles without labels have two blank lines before and one after
* section labels have two blank lines above and one below, and occur just before the title, allowing `:ref:` links to that label to auto-inherit the section title
	* Start each file with a unique label for [cross-referencing](http://www.sphinx-doc.org/en/stable/markup/inline.html#cross-referencing-arbitrary-locations); generally this will match the filename. 
* chapter/section labels are in the form `chapter-section-title-words`
	* section labels don't need to include the full chapter label, just enough to be unique
	* ensure that labels don't conflict with any type/trait/method directives, e.g. links to the `xml` method didn't work until the label for the XML chapter was changed to "xml-documents"
	* link to chapters with ``"the :ref:`label` chapter"`` to grab the chapter titles directly
	* link to specific sections with ``"the section on :ref:`topic <label>`"`` so it integrates with the sentence and isn't capitalized
* if a chapter draws from a page of the old website language guide, include the URL in a comment at the top
* for `method::` or `member::` directives, end the method name with an empty set of parens
* use simple tables if possible (i.e. when entries in the first column fit on one line)
	* for methods with many parameters, instead of a table, list them using `:param name:` elements to create a field list
* table labels in the form `chapter-table-title-words`, e.g. `literals-string-escape` for "Supported String Escape Sequences"
	* the table title (following `table::` directive) has "Table: " auto-added by PDF builder
	* if a `tabularcolumns::` directive is used, it must come before the table's label
* prevent sample URLs from linking by enclosing in a `:ref:` with a "!", e.g.: ``:ref:`!http://localhost/lasso9/instancemanager` ``
* Most admonitions will be a Note. However, others can be used for varying levels of seriousness: 
	* Tip: something you may find helpful
	* Important: something you really should be aware of
	* Attention: something that may break if you aren't aware
	* Caution: something that will break if you aren't aware
	* Warning: something that will break catastrophically if you aren't aware
	* Danger: (this is probably too extreme for a programming reference)

### Grammar

* use American word spellings
* Em dashes (`---`) are rarely appropriate for technical writing; use a semicolon or colon instead. For the rare occasion that they are the best choice, they shouldn't have spaces on either side, according to everyone but AP style.
* don't use the ampersand in sentences
* don't have spaces around a slash
* use of the Oxford comma is encouraged

### Terms

* auto-collect (not autocollect)
* curly brace (not curly bracket)
* shortcut, website, email (not short-cut, web-site, e-mail)
* Internet (when talking about *the* Internet)

### Quoting

* "double quotes":
	* output or return values: `if so the method returns "the value", otherwise "null"...`
	* variable names: `stored in the "ciphertext" variable...`
	* hypothetical/example file names: `and uploads it as "file.txt" to...`
	* single characters that aren't operators or names: `prefix with the "#" character`
	* any other generic string that's not literal code: `search entries for "John Doe" and "Jane Doe"...`

* 'single quotes':
	* list of map keys: `which includes the keys 'domain', 'host', 'username',...`

* \`backticks\`:
	* names of Lasso types, traits, or methods. This becomes a reST "role" which links the word to the description of that object elsewhere in the guide, if it exists.
	  	* member methods usually need to be fully qualified, e.g. `` `typename->membername` `` for the link to work
		* since the default role is `:meth:`, names of types and traits should be in single backticks and prefixed with `:type:` or `:trait:`
	  	* there may be some bugs in the Lasso domain relating to which target wins for ambiguous references, e.g. references to the date type and creator method both go to the date type heading
  	* for readability, I've been linking type names when the sentence refers to the type itself or the type constructor, but not for when referring to an object of a particular type whose name is a normal English word (of which "staticarray", "curl", and "pdf_*" are members, for clarity). 
    	* ``the :type:`bytes` type...``
    	* ``using :type:`image` methods...``
    	* ``use `integer` to convert a string value...``
    	* ``this will return a string or an integer object.``

* \`\`doubled backticks\`\`
	* parameter names: ```Requires a ``-message`` parameter...```
	* inline code: ```Even though the ``return true`` occurs within...```
  	* includes references to type and method names in nearby examples: ```a hypothetical ``find_in_string`` method...```
	* example inline URLs that shouldn't be linked
	* a single character or operator within a sentence; preferably, use the name of the operator and follow with the operator in parens: ```followed by the associate operator (``=>``) and an...```
	* an inline reference to an escape sequence: ```The escape sequence ``\u2FB0`` represents a...```

* \`\`'doubled backticks with single quotes'\`\`
	* an inline reference to a Lasso string object: ```finds the string ``'Blue'`` and replaces it with the string ``'Green'``...```
  		* if the wording refers to a string *value* rather than a string *object*, then double quotes are fine: ```Using a ``-type`` of "A" will always return...```

* \`\`"doubled backticks with double quotes"\`\`
	* an inline reference to an escape sequence that should be quoted: ```The escape sequence ``"\r\n"`` represents a Windows line break...```
	* an inline reference to an HTML/XML string: ```applied to the string ``"<b>Bold Text</b>"`` then...```
  		* or an HTML/XML attribute: ```Extract the ``"at"`` attribute...```


### Code samples

* literal blocks (following the double colon `::` ) are indented three spaces
* code which produces a result are followed by `// =>` with the result following on the same line for a single line result, or each on new lines for a multi-line result
	* The result comment should follow a blank line, except for a single line of code producing a single-line result. Aim for consistency and readability.

### reST roles

* `:file:` for real-world directory paths or non-executable files
	* can focus on part of the path by enclosing with {braces}
* `:samp:` for code with an emphasized {variable} part (use doubled backticks otherwise) 
* `:envvar:` for environment variables (`LASSO9_HOME`, `LASSO9_RETAIN_COMMENTS`, etc.)
* `:program:` for executable names (lasso9, lassoc, lassoserver, etc.)
* `:command:` for OS-level programs (ls, mkdir, cd, etc.)
* `:guilabel:` and `:menuselection:` for GUI buttons and menus
* `:dfn:` for when a word is defined, which causes the word to be italicized
	* using `:term:` instead will generate a link to that word in the glossary, if it exists
* `:mimetype:` for mime types (e.g. most terms starting with text/, application/, multipart/)
* `:mailheader:` for email or HTTP headers, e.g. `Content-Type`
* `:regexp:` for regular expressions with more than one element (note that backslashes need doubling)
	* use double backticks for single elements: ```the wildcard ``\d`` matches...```

### Naming conventions

* __Lasso Guide__: this documentation project
* __Lasso 8__: any code not updated to work with Lasso 9 Server
* __Lasso Professional 8/8.5/8.6__: the market names of the older server packages
* __Lasso 9__: the current Lasso syntax
* __Lasso 9 Server__: the generalized market name of what does the actual serving
* __Lasso 9.x.y__: the short name for the server package when the specific version needs mentioning
