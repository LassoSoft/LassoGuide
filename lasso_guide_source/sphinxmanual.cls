%
% sphinxmanual.cls for Sphinx (http://sphinx-doc.org/)
%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sphinxmanual}[2009/06/02 Document class (Sphinx manual)]

% chapters starting at odd pages (overridden by 'openany' document option)
\PassOptionsToClass{openright}{\sphinxdocclass}

% 'oneside' option overriding the 'twoside' default
\newif\if@oneside
\DeclareOption{oneside}{\@onesidetrue}
% Pass remaining document options to the parent class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\sphinxdocclass}}
\ProcessOptions\relax

% Defaults two-side document
\if@oneside
% nothing to do (oneside is the default)
\else
\PassOptionsToClass{twoside}{\sphinxdocclass}
\fi

\LoadClass{\sphinxdocclass}

% Set some sane defaults for section numbering depth and TOC depth.  You can
% reset these counters in your preamble.
%
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{1}

% Change the title page to look a bit better, and fit in with the fncychap
% ``Bjarne'' style a bit better.
%
\renewcommand{\maketitle}{%
  \begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \rule{\textwidth}{1pt}%
    \ifsphinxpdfoutput
      \begingroup
      % These \defs are required to deal with multi-line authors; it
      % changes \\ to ', ' (comma-space), making it pass muster for
      % generating document info in the PDF file.
      \def\\{, }
      \def\and{and }
      \pdfinfo{
        /Author (\@author)
        /Title (\@title)
      }
      \endgroup
    \fi
    \begin{flushright}%
      \sphinxlogo%
      {\rm\Huge\py@HeaderFamily \textbf{Lasso}Guide \par}%
      {\em\LARGE\py@HeaderFamily \py@release\releaseinfo \par}
      \vfill
      {\LARGE\py@HeaderFamily
        \begin{tabular}[t]{c}
          \@author
        \end{tabular}
        \par}
      \vfill\vfill
      {\large
       \@date \par
       \vfill
       \py@authoraddress \par
      }%
    \end{flushright}%\par
    \@thanks
  \end{titlepage}%
  %\cleardoublepage%
  \setcounter{footnote}{0}%

  % Make Copyright Page
  \clearpage\null\vfill
  \pagestyle{empty}
  \begin{minipage}[b]{0.9\textwidth}
  \footnotesize\raggedright
  \setlength{\parskip}{0.5\baselineskip}
  Copyright \copyright \the\year\ \@author \\
  All rights reserved.\par
  This work may be distributed and/or modified under the conditions of the
  license as described at \url{http://lassoguide.com/license.html}. In all cases
  this notice must remain intact.\par
  The latest version of the work may be accessed at \url{http://lassoguide.com/}.

  \begin{center}
  \begin{tabular}{ll}
  First edition:  & December 2013 %\\
  \end{tabular}
  \end{center}
  \begin{center}
  18 17 16 15 14 13\hspace{2em}8 7 6 5 4 3 2 1
  \end{center}

  Lassosoft Inc. \\
  \hspace*{2em} LassoGuide : Release 9.2 / LassoSoft Inc. -- 1st ed. \\
  \hspace*{2em} p. \hspace*{2em} cm. \\
  \hspace*{2em} Includes index. \\
  \hspace*{2em} ISBN: 978-0-9936363-0-1 \par

  BISAC subject headings: \\
  \hspace*{2em} COM060160	\hspace*{2em} COMPUTERS / Web / Web Programming \\
  \hspace*{2em} COM051000	\hspace*{2em} COMPUTERS / Programming / General \\
  \hspace*{2em} COM052000	\hspace*{2em} COMPUTERS / Reference \par

  Lasso, LassoGuide, LassoTalk, LassoSoft and the LassoSoft logo are trademarks
  of LassoSoft Inc.

  Many of the designations used by manufacturers and sellers to distinguish
  their products are claimed as trademarks. All terms mentioned in this book
  that are known to be trademarks or service marks have been appropriately
  capitalized.

  The software described in this book maybe under some license agreement. The
  software may be used or copied only in accordance with the terms of that
  agreement.

  While every precaution has been taken in the preparation of this book, neither
  LassoSoft nor the publisher assume responsibility for errors or omissions, or
  for damages resulting from the use of the information contained herein.

  Produced with Sphinx and {\fontfamily{lmr}\selectfont\LaTeX}. \\
  Printed and bound by Lulu.
  \end{minipage}
  \vspace*{2\baselineskip}
  \cleardoublepage
  \rfoot{\thepage}

  \let\thanks\relax\let\maketitle\relax
  %\gdef\@thanks{}\gdef\@author{}\gdef\@title{}
}


% Catch the end of the {abstract} environment, but here make sure the abstract
% is followed by a blank page if the 'openright' option is used.
%
\let\py@OldEndAbstract=\endabstract
\renewcommand{\endabstract}{
  \if@openright
    \ifodd\value{page}
      \typeout{Adding blank page after the abstract.}
      \vfil\pagebreak
    \fi
  \fi
  \py@OldEndAbstract
}

% This wraps the \tableofcontents macro with all the magic to get the spacing
% right and have the right number of pages if the 'openright' option has been
% used.  This eliminates a fair amount of crud in the individual document files.
%
\let\py@OldTableofcontents=\tableofcontents
\renewcommand{\tableofcontents}{%
  \ChTitleVar{\raggedright\color{InnerLinkColor}\bfseries\fontsize{36}{40}\selectfont}
  \setcounter{page}{1}%
  \pagebreak%
  \pagestyle{plain}%
  {%
    \parskip = 0mm%
    \phantomsection
    \addcontentsline{toc}{part}{\contentsname}
    \py@OldTableofcontents%
    \if@openright%
      \ifodd\value{page}%
        \typeout{Adding blank page after the table of contents.}%
        \pagebreak\hspace{0pt}%
      \fi%
    \fi%
    \cleardoublepage%
  }%
  %\pagenumbering{arabic}% delay until after foreword
  \@ifundefined{fancyhf}{}{\pagestyle{normal}}%
}
\pagenumbering{roman}

% This is needed to get the width of the section # area wide enough in the
% library reference.  Doing it here keeps it the same for all the manuals.
%
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{2.6em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4.1em}{3.5em}}

% Fix the bibliography environment to add an entry to the Table of
% Contents.
% For a report document class this environment is a chapter.
\let\py@OldThebibliography=\thebibliography
\renewcommand{\thebibliography}[1]{
  \cleardoublepage
  \phantomsection
  \py@OldThebibliography{1}
  \addcontentsline{toc}{part}{\bibname}
}

% Same for the indices.
% The memoir class already does this, so we don't duplicate it in that case.
%
\@ifclassloaded{memoir}{}{
  \let\py@OldTheindex=\theindex
  \renewcommand{\theindex}{
    \cleardoublepage
    \phantomsection
    \py@OldTheindex
    \addcontentsline{toc}{part}{\indexname}
  }
}
