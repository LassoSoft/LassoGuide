% Modified by Brad Lindsay & Eric Knibbe
%
% sphinxmanual.cls for Sphinx (http://sphinx-doc.org/)
%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sphinxmanual}[2016/10/12 v1.5 Document class (Sphinx manual)]

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
  \let\spx@tempa\relax
  \ifHy@pageanchor\def\spx@tempa{\Hy@pageanchortrue}\fi
  \hypersetup{pageanchor=false}% avoid duplicate destination warnings
%% for screen PDF, replace title page with cover image
  \ifthenelse{\equal{\isbn}{000-0-0000000-0-0}}{\includepdf[pages={1}]{guide_cover_92.pdf}}{%
  \begin{titlepage}%
    \let\footnotesize\small
    \let\footnoterule\relax
    \noindent\rule{\textwidth}{1pt}\ifsphinxpdfoutput\newline\null\fi\par
    \ifsphinxpdfoutput
      \begingroup
      % These \defs are required to deal with multi-line authors; it
      % changes \\ to ', ' (comma-space), making it pass muster for
      % generating document info in the PDF file.
      \def\\{, }%
      \def\and{and }%
      \pdfinfo{
        /Author (\@author)
        /Title (\@title)
      }%
      \endgroup
    \fi
    \begin{flushright}%
      \py@HeaderFamily
%% colourize title
      {\Huge\py@TitleColor \@title \par}
      {\itshape\LARGE\py@TitleColor \py@release\releaseinfo \par}
      \vfill
%% use logo for author instead of text
      \sphinxlogo
%     {\LARGE
%       \begin{tabular}[t]{c}
%         \@author
%       \end{tabular}
%       \par}
      \vfill\vfill
      {\large
%% instead of \@date, which only inserts the year
       \today \par
       \vfill
       \py@authoraddress \par
      }%
    \end{flushright}%\par
    \@thanks
  \end{titlepage}%
  \setcounter{footnote}{0}%

%% copyright page for print PDF
  \clearpage\null\vfill
  \pagestyle{empty}
  \begin{minipage}[b]{0.9\textwidth}
  \footnotesize\raggedright
  \setlength{\parskip}{0.5\baselineskip}
  Copyright \copyright 1996--\the\year\ \@author \\
  All rights reserved.

  This work may be distributed and/or modified under the conditions of the
  license as described at \url{http://lassoguide.com/copyright-license.html}. In
  all cases this notice must remain intact.

  The latest version of the work may be accessed at \url{http://lassoguide.com/}.

  \begin{center}
  \begin{tabular}{ll}
  First edition:  & December 2013 %\\
  \end{tabular}
  \end{center}
  \begin{center}
  18 17 16 15 14 13\hspace{2em}8 7 6 5 4 3 2 1
  \end{center}

  \@author \\
  \hspace*{2em} \@title\space : \py@release\space / \@author\space -- 1st ed. \\
  \hspace*{2em} p. \hspace*{2em} cm. \\
  \hspace*{2em} Includes index. \\
  \hspace*{2em} ISBN: \isbn

  BISAC subject headings: \\
  \hspace*{2em} COM060160	\hspace*{2em} COMPUTERS / Web / Web Programming \\
  \hspace*{2em} COM051000	\hspace*{2em} COMPUTERS / Programming / General \\
  \hspace*{2em} COM052000	\hspace*{2em} COMPUTERS / Reference

  Lasso, LassoGuide, LassoTalk, Lasso Professional, Lasso Studio, Lasso Dynamic
  Markup Language, LDML, Lasso Service, Lasso Connector, Lasso Web Data Engine,
  LassoSoft and the LassoSoft logo are trademarks of \@author

  Many of the designations used by manufacturers and sellers to distinguish
  their products are claimed as trademarks. All terms mentioned in this book
  that are known to be trademarks or service marks have been appropriately
  capitalized.

  Links to third-party distributions and tools are provided for your convenience
  and were accurate when this manual was written. \@author\space cannot
  guarantee the availability or suitability of software downloaded from
  third-party web sites.

  The software described in this book maybe under some license agreement. The
  software may be used or copied only in accordance with the terms of that
  agreement.

  While every precaution has been taken in the preparation of this book, neither
  \@author\space nor the publisher assume responsibility for errors or
  omissions, or for damages resulting from the use of the information
  contained herein.

  Produced with Sphinx and {\fontfamily{lmr}\selectfont\LaTeX}. \\
  Printed and bound by Lulu.
  \end{minipage}
  \vspace*{2\baselineskip}
  \if@openright\cleardoublepage\else\clearpage\fi
  \rfoot{\thepage}

  \let\thanks\relax\let\maketitle\relax
  %\gdef\@thanks{}\gdef\@author{}\gdef\@title{}
  \if@openright\cleardoublepage\else\clearpage\fi
  \spx@tempa
}

\renewcommand{\sphinxtableofcontents}{%
  \pagenumbering{roman}%
  \pagestyle{plain}%
  \begingroup
    \parskip \z@skip
    \tableofcontents
%% add list of tables
    \iftotaltables
      \if@openright\cleardoublepage\else\clearpage\fi
      \phantomsection
      \addcontentsline{toc}{chapter}{\listtablename}
      \listoftables
    \fi
  \endgroup
  % before resetting page counter, let's do the right thing.
  \if@openright\cleardoublepage\else\clearpage\fi
%% end ifthenelse
  }
  \pagenumbering{arabic}%
  \ifdefined\fancyhf\pagestyle{normal}\fi
}

% This is needed to get the width of the section # area wide enough in the
% library reference.  Doing it here keeps it the same for all the manuals.
%
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{2.6em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4.1em}{3.5em}}

% Fix the bibliography environment to add an entry to the Table of
% Contents.
% For a report document class this environment is a chapter.
%
% Note: \phantomsection is required for TeXLive 2009
% http://tex.stackexchange.com/questions/44088/when-do-i-need-to-invoke-phantomsection#comment166081_44091
\newenvironment{sphinxthebibliography}[1]{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \phantomsection
  \begin{thebibliography}{1}%
  \addcontentsline{toc}{chapter}{\bibname}}{\end{thebibliography}}

% Same for the indices.
% The memoir class already does this, so we don't duplicate it in that case.
%
\@ifclassloaded{memoir}
 {\newenvironment{sphinxtheindex}{\begin{theindex}}{\end{theindex}}}
 {\newenvironment{sphinxtheindex}{%
    \if@openright\cleardoublepage\else\clearpage\fi
%% patch below for \theindex obviates these lines
%    \phantomsection
    \begin{theindex}%
%    \addcontentsline{toc}{chapter}{\indexname}
}{\end{theindex}}}

%%
% Make index anchor point at title rather than entries list.
% (idxlayout's totoc option can do this, but only as a chapter, not a part.)
% http://tex.stackexchange.com/questions/172352/correct-hyperlink-to-the-index
\usepackage{etoolbox}
\patchcmd{\theindex}{%
  \twocolumn[%
}{%
  \twocolumn[%
    \phantomsection
    \addcontentsline{toc}{part}{\indexname}%
}{}{\errmessage{Patching \string\begin{theindex} failed}}
