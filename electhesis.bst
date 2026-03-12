% mjc_a.bst
%
% Michael Cree's bibliographic style file with authors name as
% indexes.
%
% Modified by MJC from the style file pg_ref.bst
% which included the following copyright message (enclosed in
% square brackets).
%
% [
% Look in the file PG_REFERENCES.DOC for documentation
%
% version 0.98c for BibTeX versions 0.98i or later, LaTeX version 2.08
% Copyright (C) 1985, all rights reserved
% Copying of this file is authorized only if either
% (1) you make absolutely no changes to your copy, including name, or
% (2) if you do make changes, you name it something other than
% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst
% This restriction helps ensure that all standard styles are identical
% ]
%
% The changes I have made are:-
%
% 6/7/93 format.title - now uses field.or.null to really check for title!
%        output.check - Inserts "{\bf <field>? }" into output for empty
%                       required fields.
%        book
%        inbook
%        incollection - Now require address field always.
% 8/7/93 format.names - Puts names in small caps.
% 5/10/93 format.vol.num, format.chapter.pages, format.pages
%                     - Use a smaller space after abbreviation.
%

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence mid.sentenceb
           after.sentence after.block }

FUNCTION {init.state.consts}
{ 'before.all #0 swap$ :=
  'mid.sentence #1 swap$ :=
  'mid.sentenceb #2 swap$ :=
  'after.sentence #3 swap$ :=
  'after.block #4 swap$ :=
}

STRINGS { s t }


FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state mid.sentenceb =
        { " " * write$ }
        { output.state after.block =
	    { add.period$ write$
	      newline$
	      "\newblock " write$
	    }
	    { output.state before.all =
	        'write$
	        { add.period$ " " * write$ }
	      if$
	    }
          if$
        }
      if$
    }
  if$
  'output.state mid.sentence swap$ :=
  s
}

FUNCTION {output}
{ 's :=
  s "" =
    'skip$
    { s output.nonnull }
  if$
}

FUNCTION {output.check}
{ 's :=
  't :=
  s "" =
    { "Warning: the " t * " shouldn't be empty in " * cite$ * top$ }
    { s output.nonnull }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  'output.state before.all swap$ :=
}

FUNCTION {blank.sep}
{ 'output.state mid.sentenceb swap$ :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { 'output.state after.block swap$ := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ 'output.state after.sentence swap$ := }
      if$
    }
  if$
}


FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {field.or.null}
{ duplicate$
  missing$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {italicize}
{ 's :=
  s "" =
    { "" }
    { "{\it " s * "}" * }
  if$
}


INTEGERS { nameptr namesleft numnames }

STRINGS {nameresult}






FUNCTION {format.names}
{ 's :=
  'nameptr #1 swap$ :=
  'nameresult "{\sc " swap$ :=
  'numnames s num.names$ swap$ :=
  'namesleft numnames swap$ :=
    { namesleft #0 > }
    {
      't s nameptr "{vv~}{ll}{, jj}{, f{.}.}" format.name$ swap$ :=
      nameptr #1 >
	{ namesleft #1 >
	    { 'nameresult nameresult ", " * t * swap$ := }
	    { t "others" =
		{ 'nameresult nameresult " {\citeetal}" * swap$ := }
		{ 'nameresult nameresult " and " * t * swap$ := }
	      if$
	    }
	  if$
	}
	{ 'nameresult nameresult t * swap$ := }
      if$
      'nameptr nameptr #1 + swap$ :=
      'namesleft namesleft #1 - swap$ :=
    }
  while$
  nameresult "}" *
}


FUNCTION {format.authors}
{ author missing$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor missing$
    { "" }
    { editor num.names$ #1 >
    	{ editor format.names "\ (Eds.)" * }
	{ editor format.names "\ (Ed.)" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title field.or.null
  duplicate$ "" = 
    'skip$
    { "`" swap$ "t" change.case$ * "'" * }
  if$
}

FUNCTION {entry.string.max} { #100 }

FUNCTION {global.string.max} { #300 }

STRINGS {pageresult}

FUNCTION {n.dashify}
{ 't :=
  'pageresult "" swap$ :=
    { t "" = not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { 'pageresult pageresult "--" * swap$ :=
	      't t #2 global.string.max substring$ swap$ :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ 'pageresult pageresult "-" * swap$ :=
		  't t #2 global.string.max substring$ swap$ :=
		}
	      while$
	    }
	  if$
	}
	{ 'pageresult pageresult t #1 #1 substring$ * swap$ :=
	  't t #2 global.string.max substring$ swap$ :=
	}
      if$
    }
  while$
  pageresult
}


FUNCTION {format.year}
{ year missing$
    { "" }
    { "(" year * extra.label * ")" * }
  if$
}

FUNCTION {format.book.title}
{ title field.or.null
  italicize
}

FUNCTION {format.book.vol.series }
{ volume missing$
    { series missing$
	{ "" }
	{ series }
      if$
    }
    { "Vol.~" volume *
      series missing$
	'skip$
	{ " of " * series * }
      if$
    }
  if$
}

FUNCTION {format.edition}
{ edition missing$
    { "" }
    { edition "l" change.case$ " ed." * }
  if$
}

INTEGERS {multiresult}

FUNCTION {multi.page.check}
{ 't :=
  'multiresult #0 swap$ :=
    { multiresult not
      t "" = not
      and
    }
    { t #1 #1 substring$ "-" =
      t #1 #1 substring$ "," =
      or
	{ 'multiresult #1 swap$ := }
	{ 't t #2 global.string.max substring$ swap$ := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages missing$
    { "" }
    { pages multi.page.check
	{ "pp.\," pages n.dashify * }
	{ "p.\," pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.vol.num}
{ volume missing$
    { number missing$
        { "" }
        { "No.\," number * }
      if$
    }
    { "Vol.\," volume *
      number missing$
	'skip$
     	{ ", No.\," * number * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter missing$
    'format.pages
    { "Chap.\," chapter *
      pages missing$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle missing$
    { "" }
    { 's format.editors swap$ :=
      s "" =
	{ "In " booktitle italicize * }
	{ "In " s * ", " * booktitle italicize * }
      if$
    }
  if$
}

FUNCTION {format.tr.number}
{ type missing$
    { "Technical Report" }
    { type }
  if$
  number missing$
    'skip$
    { "~" * number * }
  if$
}


FUNCTION {article}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.title output.check
  "journal" journal field.or.null italicize output.check
  format.vol.num output
  month field.or.null output
  format.pages output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author missing$
    { "author and editor" format.editors output.check }
    { "author" format.authors output.check }
  if$
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  format.book.vol.series  output
  "publisher" publisher field.or.null output.check
  "address" address field.or.null output.check
  format.edition output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  blank.sep
  format.year output
  "title" format.book.title output.check
  howpublished field.or.null output
  address field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author missing$
    { "author and editor" format.editors output.check }
    { "author" format.authors output.check }
  if$
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  format.book.vol.series  output
  "publisher" publisher field.or.null output.check
  "address" address field.or.null output.check
  format.edition output
  month field.or.null output
  "chapter and pages" format.chapter.pages output.check
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  "authors" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.title output.check
  "booktitle" format.in.ed.booktitle output.check
  "publisher" publisher field.or.null output.check
  "address" address field.or.null output.check
  month field.or.null output
  format.chapter.pages output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.title output.check
  "booktitle" format.in.ed.booktitle output.check
  organization field.or.null output
  publisher field.or.null output
  address field.or.null output
  month field.or.null output
  format.pages output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.authors output
  blank.sep
  format.year output
  "title" format.book.title output.check
  organization field.or.null output
  address field.or.null output
  format.edition output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  "Master's thesis" output
  "school" school field.or.null output.check
  address field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  blank.sep
  format.year output
  format.title output
  howpublished field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  "PhD thesis" output
  "school" school field.or.null output.check
  address field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor missing$
    { organization missing$
	'skip$
	{ organization field.or.null output }
      if$
    }
    { format.editors output }
  if$
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  editor missing$
    'skip$
    { organization field.or.null output }
  if$
  publisher field.or.null output
  address field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  "year" format.year output.check
  "title" format.book.title output.check
  format.tr.number output
  "institution" institution field.or.null output.check
  address field.or.null output
  month field.or.null output
  new.block
  note field.or.null output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  "author" format.authors output.check
  blank.sep
  format.year output
  "title" format.title output.check
  month field.or.null output
  new.block
  "note" note field.or.null output.check
  fin.entry
}

FUNCTION {default.type} { book }


MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}


READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}


FUNCTION {format.label.names}
{ 's :=
  'numnames s num.names$ swap$ :=
  'nameresult s #1 "{vv{~}~}{ll{~}}" format.name$ swap$ :=
  numnames #1 >
    { numnames #2 =
	{ s nameptr "{ff}{vv}{ll}{jj}" format.name$ "others" =
	    { 'nameresult nameresult "\ {\citeetal}" * swap$ := }
	    { 'nameresult nameresult "\ and " *
              s #2 "{vv{~}~}{ll{~}}" format.name$ * swap$ :=
	    }
	  if$
	}
	{ 'nameresult nameresult "\ {\citeetal}" * swap$ := }
      if$
    }
    'skip$
  if$
  nameresult
}

FUNCTION {format.slab.names}
{ 's :=
  'numnames s num.names$ swap$ :=
  'nameresult s #1 "{vv{ } }{ll{ }}{, jj{ }} " format.name$ swap$ :=
  numnames #1 >
    { numnames #2 =
	{ s nameptr "{ff}{vv}{ll}{jj}" format.name$ "others" =
	    { 'nameresult nameresult " " * "etal" * swap$ := }
	    { 'nameresult nameresult " and " *
              s #2 "{vv{ } }{ll{ }}{, jj{ }}" format.name$ * swap$ :=
	    }
	  if$
	}
	{ 'nameresult nameresult " " * "etal" * swap$ := }
      if$
    }
    'skip$
  if$
  nameresult
}

FUNCTION {calc.label}
{ 'label
  author missing$
    { editor missing$
	{ key missing$
	    { "Warning: need a key to make a label in " cite$ * top$
	      title field.or.null #1 #100 substring$
	    }
	    { key }
	  if$
	}
	{ editor format.label.names }
      if$
    }
    { author format.label.names }
  if$
  swap$ :=
  'label "{" label * "}~{" * year field.or.null * "}" * swap$ :=
}

FUNCTION {calc.sort.label}
{ 'sort.label
  author missing$
    { editor missing$
	{ key missing$
	    { title field.or.null #1 #100 substring$ }
	    { key }
	  if$
	}
	{ editor format.slab.names }
      if$
    }
    { author format.slab.names }
  if$
  swap$ :=
  'sort.label sort.label " " * year field.or.null * swap$ :=
  'sort.label sort.label sortify swap$ :=
}

INTEGERS {len}


FUNCTION {sort.month.number}
{ month missing$
    { number missing$
        { 't "    " swap$ := }
        { 't "  " number * swap$ := }
      if$
    }
    { 's month #1 #3 substring$ "l" change.case$ swap$ :=
      s "jan" =
        { 't "  01" swap$ := }
        { s "feb" =
            { 't "  02" swap$ := }
	    { s "mar" =
		{ 't "  03" swap$ := }
		{ s "apr" =
		    { 't "  04" swap$ := }
		    'skip$
		  if$
		}
	      if$
            }
          if$
        }
      if$
      s "may" =
	{ 't "  05" swap$ := }
	{ s "jun" =
	    { 't "  06" swap$ := }
	    { s "jul" =
		{ 't "  07" swap$ := }
		{ s "aug" =
		    { 't "  08" swap$ := }
		    'skip$
		  if$
		}
	      if$
            }
      	  if$
	}
      if$
      s "sep" =
	{ 't "  09" swap$ := }
	{ s "oct" =
	    { 't "  10" swap$ := }
	    { s "nov" =
		{ 't "  11" swap$ := }
		{ s "dec" =
		    { 't "  12" swap$ := }
		    'skip$
		  if$
		}
	      if$
            }
      	  if$
	}
      if$
    }
  if$
  t
}

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.string.max substring$ }
    { s }
  if$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  #1 global.string.max substring$
  sortify
}

FUNCTION {presort}
{
  calc.label
  calc.sort.label
  sort.label
  "    "
  *
  sort.month.number
  *
  title field.or.null
  sort.format.title
  *
  sortify
  #1 entry.string.max substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.sort.label next.extra }

INTEGERS { longest.label.width last.extra.num }

FUNCTION {initialize.longest.label}
{ 'longest.label "" swap$ :=
  'last.sort.label "" swap$ :=
  'next.extra "" swap$ :=
  'longest.label.width #0 swap$ :=
  'last.extra.num #0 swap$ :=
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { 'last.extra.num last.extra.num #1 + swap$ :=
      'extra.label last.extra.num int.to.chr$ swap$ :=
    }
    { 'last.extra.num "a" chr.to.int$ swap$ :=
      'extra.label "" swap$ :=
      'last.sort.label sort.label swap$ :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { 'extra.label "a" swap$ := }
    'skip$
  if$
  'label label extra.label * swap$ :=
  label width$ longest.label.width >
    { 'longest.label label swap$ :=
      'longest.label.width label width$ swap$ :=
    }
    'skip$
  if$
  'next.extra extra.label swap$ :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {preamble}
{ "\begin{thebibliography}{"  longest.label  * "}" * write$
  newline$
}

EXECUTE {preamble}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {finish.up} { newline$ "\end{thebibliography}" write$ newline$ }

EXECUTE {finish.up}
