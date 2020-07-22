\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vita}[2020/02/20 Curriculum Vitae Class]

\LoadClass[a4paper, parskip=half, fontsize=9]{scrartcl}
\setlength\parindent{0pt}

% ----------------------------------- Colors -----------------------------------

\RequirePackage{xcolor}

\definecolor{vitared}{HTML}{D9534F} % #d9534f
\definecolor{vitagreen}{HTML}{5CB85C} % #5cb85c
\definecolor{vitablue}{HTML}{0275D8} % #0275d8
\definecolor{vitayellow}{HTML}{F0AD4E} % #f0ad4e
\definecolor{vitateal}{HTML}{5BC0DE} % #5bc0de
\definecolor{vitagray}{HTML}{CCCCCC} % #CCCCCC

\definecolor{@vitasidebar}{HTML}{E7E7E7} % #E7E7E7

% ---------------------------------- Packages ----------------------------------

\RequirePackage{xkeyval}
\RequirePackage{xparse}
\RequirePackage{xifthen}
\RequirePackage{etoolbox}
\RequirePackage{environ}
\RequirePackage{multido}
\RequirePackage{xsavebox}
\RequirePackage{atbegshi}

\RequirePackage{geometry}
\RequirePackage[absolute, overlay]{textpos}
\RequirePackage{afterpage}
\RequirePackage{verbatimbox}
\RequirePackage{makecell}
\RequirePackage{ragged2e}

\RequirePackage{fontspec}
\RequirePackage{fontawesome}
\RequirePackage[hidelinks]{hyperref}

% ---------------------------------- Options -----------------------------------

\define@cmdkey{vita}{color}[vitablue]{\colorlet{vitamain}{#1}}

\define@cmdkeys{vita}{
  name,
  family,
  pic,
  profession,
  date,
  street,
  number,
  city,
  zip,
  country,
  phone,
  mobile,
  mail,
  skype,
  github,
  web,
}[]

% NOTE: Workaround for issue with spaces in profile bar
\define@boolkey{vita}{unskip}[true]{}

\setkeys{vita}{
  color,
  name,
  family,
  pic,
  profession,
  date,
  street,
  number,
  city,
  zip,
  country,
  phone,
  mobile,
  mail,
  skype,
  github,
  web,
  unskip=false,
}

\DeclareOptionX*{\PackageWarning{vita}{Unknown option `\CurrentOption'}}
\ProcessOptionsX<vita>

\DeclareExpandableDocumentCommand\getvitakey{ m }
  {\csname cmdKV@vita@#1\endcsname}

\DeclareDocumentCommand\ifvitakey{ m m G{} }
  {\ifthenelse{\equal{\getvitakey{#1}}{}}{#3}{#2}}

% ------------------------------------ Page ------------------------------------

\geometry{
  left = 7.3cm,
  right = 0.5cm,
  top = 0.3cm,
  bottom = 0.3cm,
  nohead,
  nofoot,
}

\pagestyle{empty}

% ----------------------------------- Fonts ------------------------------------

\setmainfont{DejaVu Serif}
\setsansfont{DejaVu Sans}
\setmonofont{DejaVu Sans Mono}

\renewcommand\familydefault{\sfdefault}

\addtokomafont{subsection}{\LARGE}
\addtokomafont{section}{\huge}

% ------------------------------------ Tikz ------------------------------------

\RequirePackage{tikz}

\usetikzlibrary{calc}

\tikzset{progress/.style args={#1, #2 and #3}{
  path picture={
    \tikzset{rounded corners=0}
    \coordinate (begin) at (path picture bounding box.north west);
    \coordinate (end) at (path picture bounding box.north east);
    \path (path picture bounding box.south west)
      -- (path picture bounding box.south east) node[pos=#1] (progress) {};
    \fill[#2] (begin) rectangle (progress);
    \fill[#3] (progress) rectangle (end);
}}}

% ---------------------------------- Commands ----------------------------------

\newlength\@lineheight
\newlength\@vitalineheight

\NewDocumentCommand\vitaline{ O{0.5pt} }
{\settoheight\@lineheight{X}%
  \setlength\@vitalineheight{#1}%
  \leaders\hrule height \dimexpr\@vitalineheight+.6ex\relax%
    depth \dimexpr\@vitalineheight-.6ex\relax%
  \hfill\kern0pt\relax}

\NewExpandableDocumentCommand\icon{ m }{%
  \tikz[baseline=(char.base)]{\node[
    draw, circle, vitamain,
    minimum size=0.45cm,
    inner sep=0pt,
    fill=vitamain,
    text=white,
  ] (char) {#1};
}}

\NewDocumentCommand\vitabadge{ m }{%
  \tikz[baseline=(char.base)]{\node[
    draw, rectangle, rounded corners, vitamain,
    anchor=north west,
    inner sep=2pt,
    outer sep=0pt,
    fill=vitamain,
    text=white,
  ] (char) {#1};}%
}

% ---------------------------------- Sidebar -----------------------------------

\RequirePackage[british]{isodate} % TODO: Option for isodate language

% Set textpos grid
\setlength\TPHorizModule{1cm}
\setlength\TPVertModule{1cm}

\newlength\@vitasidebar
\setlength\@vitasidebar{6\TPHorizModule}

\newlength\@imagewidth
\newlength\@imagescale
\pgfmathsetlength{\@imagewidth}{5cm}%
\pgfmathsetlength{\@imagescale}{\@imagewidth/600}%

\NewDocumentCommand\@profilebox{ O{0pt} m }
  {\par\addvbuffer[#1 0pt]{%
    \parbox{6\TPHorizModule}{#2}}}

\NewDocumentCommand\@profilesection{ m o }
{\@profilebox[3.4pt]{%
  \textcolor{vitagray}{%
    \usekomafont{subsection}{%
      \makebox[1em]{\vitaline[0.4pt]}%
      \hspace{-1.5pt}[\textcolor{black}{#1}]\hspace{-1.5pt}%
      \vitaline[0.4pt]%
  }}}
}

\pgfmathsetmacro\skillbarheight{0.3}
\NewDocumentCommand\@drawskilllevels{ m }
{\addvbuffer[6.8pt 0pt]{%
  \begin{tikzpicture}[xscale=0.6, yscale=0.9, inner sep=2pt]
    \foreach[count=\i] \x/\y in {#1} {
      \path [progress={\y/10, vitamain and vitagray}, rounded corners]
        (0,-0.9*\i+\skillbarheight) node[above right] {\profilesize \x}
        rectangle (10,-0.9*\i);
    }
  \end{tikzpicture}}}

% Skills
\newcounter{skillcounter}
\setcounter{skillcounter}{0}

\NewDocumentCommand\vitaskills{ O{Skills} m D<>{} o }
{\stepcounter{skillcounter}
  \expandafter\@namedef{@skills\the\value{skillcounter}}{%
    \@profilebox{%
      \@profilesection{#1\IfValueT{#4}{\textsuperscript{#3}}}
      \@drawskilllevels{#2}%
    }%
  \IfValueT{#4}{\scriptsize\textsuperscript{#3}#4}}%
}

% ---------------------------------- Profile -----------------------------------

\let\profilesize\small

\xsavebox{vitasidebar}{%
  \begin{tikzpicture}
    \node [rectangle, fill=@vitasidebar, anchor=north, minimum width=7cm, minimum height=\paperheight] (box) {};
  \end{tikzpicture}%
}

\AtBeginShipout{
  \AtBeginShipoutUpperLeft{\raisebox{-\height}{\xusebox{vitasidebar}}}
}

\AtBeginDocument{
  \begin{textblock}{6}(0.5, 0.2)
    \hspace{0.2\TPVertModule}
    \begin{flushleft}
      \ifvitakey{pic}{
        \begin{center}
          \begin{tikzpicture}[x=\@imagescale,y=-\@imagescale]
            \clip (600/2, 567/2) circle (567/2);
            \node[anchor=north west, inner sep=0pt, outer sep=0pt] at (0,0) {\includegraphics[width=\@imagewidth]{\getvitakey{pic}}};
          \end{tikzpicture}%
        \end{center}%
        \vspace{\parskip}%
      }

      {\Huge\color{vitamain}%
        \ifvitakey{name}{\getvitakey{name}}%
        \ifvitakey{family}{\ \getvitakey{family}}%
      }

      {\ifvitakey{profession}{\huge\color{black!80}\getvitakey{profession}}}

      \@profilebox{\begingroup
        \setlength{\tabcolsep}{0pt}%
        \renewcommand\arraystretch{1.8}%
        \profilesize%
        \begin{tabular}{@{\hspace{0.2cm}}p{0.6cm}p{5.2cm}}
          \ifvitakey{date}{\icon{\footnotesize\faBirthdayCake} & \printdate{\getvitakey{date}} \\}%
          \ifvitakey{country}{%
            \icon{\normalsize\faMapMarker} & \makecell[tl]{%
              \ifvitakey{street}{\getvitakey{street}\ifvitakey{number}{\ \getvitakey{number}} \\}%
              \ifvitakey{city}{\ifvitakey{zip}{\getvitakey{zip}\ }\getvitakey{city} \\}%
              \getvitakey{country}%
            } \\
          }{%
            \ifvitakey{city}{%
              \icon{\normalsize\faMapMarker} & \makecell[tl]{%
                \ifvitakey{street}{\getvitakey{street}\ifvitakey{number}{\ \getvitakey{number}} \\}%
                \ifvitakey{zip}{\getvitakey{zip}\ }\getvitakey{city}%
              } \\
            }{%
              \ifvitakey{street}{%
                \icon{\normalsize\faMapMarker} & \makecell[tl]{%
                  \getvitakey{street}\ifvitakey{number}{\ \getvitakey{number}}%
                } \\
              }%
            }%
          }%
          \ifvitakey{phone}{\icon{\normalsize\faPhone} & \getvitakey{phone} \\}{}%
          \ifvitakey{mobile}{\icon{\large\faMobilePhone} & \getvitakey{mobile} \\}{}%
          \ifvitakey{mail}{\icon{\normalsize{@}} & \href{mailto:\getvitakey{mail}}{\getvitakey{mail}} \\}{}%
          \ifvitakey{skype}{\icon{\normalsize\faSkype} & \getvitakey{skype} \\}{}%
          \ifvitakey{github}{\icon{\normalsize\faGithub} & \href{\getvitakey{github}}{\getvitakey{github}} \\}{}%
          \ifvitakey{web}{\icon{\normalsize\faGlobe} & \href{\getvitakey{web}}{\getvitakey{web}} \\}{}%
        \end{tabular}
      \endgroup}

      % NOTE: There is an `unskip' option, because unwanted spaces can occur
      \ifKV@vita@unskip%
        \vspace{-1.8\baselineskip}
      \fi%

      % Print skills
      \multido{\i=1+1}{\the\value{skillcounter}}{\csname @skills\i \endcsname}

    \end{flushleft}
  \end{textblock}
  \vspace{-10pt}
 }

% ---------------------------------- Document ----------------------------------

\NewDocumentCommand\@vitabox{ O{0pt} m }
  {\par\filbreak\addvbuffer[#1 0pt]{%
    \parbox{\columnwidth}{#2}}}

\NewDocumentCommand\vitasection{ m o }
{\@vitabox[1pt]{%
  \textcolor{@vitasidebar}{%
    \usekomafont{section}{%
      \makebox[1em]{\vitaline[0.8pt]}%
      \hspace{-1.5pt}[\textcolor{black}{#1}]\hspace{-1.5pt}%
      \vitaline[0.8pt]%
  }}}\vspace{3pt}%
}

\newlength\@vitaitemwidth

\NewDocumentEnvironment{vitalist}{ O{2.1cm} O{1.4} }
{\begingroup%
  \setlength\@vitaitemwidth{\dimexpr\columnwidth-#1\relax}%
  \setlength\parskip{0pt}%
  \setlength\tabcolsep{0pt}%
  \renewcommand\arraystretch{#2}%
  \begin{tabular}{p{#1}p{\@vitaitemwidth}}}
{\end{tabular}\endgroup}

\NewDocumentCommand{\vitaitem}{ m m o g}{%
  \vitabadge{#1} & \parbox[t]{\@vitaitemwidth}{#2%
    \IfValueT{#3}{\hfill\textcolor{black!80}{\mbox{#3}}}%
    \IfValueT{#4}{\\\textcolor{black!80}{#4}}}%
  \\}

\endinput
