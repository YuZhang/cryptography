% AMS Dept HW class file
% v0.05 by Eric Harley, 07 Sept 2005
% forked from HMC Math dept HW class file v0.04, 07 Sept 2005 developed by Eric J. Malm.
%%% IDENTIFICATION --------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[1995/01/01]
\ProvidesClass{amspset}
    [2005/09/07 v0.05 AMS Dept problem set class]

%%% INITIAL CODE ----------------------------------------------------------
%% Flag for compilation to PDF
\newif\ifpdfh
\ifx\pdfoutput\undefined
    \pdffalse
\else
    \pdfoutput = 1
    \pdftrue
\fi

%%% DECLARATION OF OPTIONS ------------------------------------------------
%% Header Options: header*, no header
\newif\ifamspset@header

% no header block in upper right hand corner
\DeclareOption{noheader}{%
    \amspset@headerfalse%
}

% do print header block
\DeclareOption{header}{%
    \amspset@headertrue%
}

%% Font Options: palatino*, cm
\newif\ifamspset@palatino

% use palatino fonts
\DeclareOption{palatino}{%
    \amspset@palatinotrue%
}

% use compuer modern fonts
\DeclareOption{cm}{%
    \amspset@palatinofalse%
}

%% Problem Boxing: boxed*, unboxed
\newif\ifamspset@boxed

% box problem statements
\DeclareOption{boxed}{%
    \amspset@boxedtrue%
}
   
% don't box problem statements
\DeclareOption{unboxed}{%
    \amspset@boxedfalse%
}
   
% pass remaining options to article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

%%% EXECUTION OF OPTIONS --------------------------------------------------
%% default to:
% including header, 
% loading mathpazo package for palatino fonts,
% boxing problem statements
\ExecuteOptions{header,palatino,boxed}

\ProcessOptions

%%% PACKAGE LOADING -------------------------------------------------------
%% based on std article class
\LoadClass{article}

%% Font loading: Palatino text/math fonts
\ifamspset@palatino
    \RequirePackage{mathpazo}
\fi

%% AMSLaTeX math environments and symbols
\RequirePackage{amsmath}
\RequirePackage{amssymb}

%% boxed minipage for boxed problem environment
\RequirePackage{boxedminipage}

%%% MAIN CODE -------------------------------------------------------------
%% Tell dvips/pdflatex correct page size
\ifpdfh
  \AtBeginDocument{%
    \setlength{\pdfpageheight}{\paperheight}%
    \setlength{\pdfpagewidth}{\paperwidth}%
  }
\else
  \AtBeginDvi{\special{papersize=\the\paperwidth,\the\paperheight}}%
\fi


%% Problem set environments
% boxed problem environment
\newenvironment{problem}[1][]{%
  \ifamspset@boxed\def\amspset@probenv{boxed}\else\def\amspset@probenv{}\fi%
  \bigskip% put space before problem statement box %
  \noindent\begin{\amspset@probenv minipage}{\columnwidth}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty\else%
    \amspset@probformat{#1}\hspace{0.5em}%
  \fi%
}{%
  \end{\amspset@probenv minipage}%
}
% display optional argument to problem in bold
\let\amspset@probformat\textbf

% solution environment with endmark and optional argument
\newenvironment{solution}[1][]{%
  \begin{trivlist}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty%
    \item[]%
  \else%
    \item[\hskip\labelsep\relax #1]%
  \fi%
}{%
  \mbox{}\penalty10000\hfill\amspset@endmark%
  \end{trivlist}%
}

% default endmark is small black square
\def\amspset@endmark{\ensuremath{\scriptscriptstyle\blacksquare}}

%% Problem set list, for top of document
\newcommand{\problemlist}[1]{\begin{center}\large\sffamily{#1}\end{center}}

%% commands for upper-right id header block
\newcommand{\headerblock}{%
\begin{flushright}
\mbox{\amspset@name}\protect\\
\mbox{\amspset@class}\protect\\
\mbox{\amspset@assignment}\protect\\
\amspset@duedate%
\ifx\amspset@extraline\empty\else\protect\\\amspset@extraline\fi%
\end{flushright}%
}

% put id header block at start of document
\ifamspset@header\AtBeginDocument{\headerblock}\fi

% internal state for headerblock
\def\amspset@name{}
\def\amspset@class{}
\def\amspset@assignment{}
\def\amspset@duedate{}
\def\amspset@extraline{}

% commands to set header block info
\newcommand{\name}[1]{\def\amspset@name{#1}}
\newcommand{\class}[1]{\def\amspset@class{#1}}
\newcommand{\assignment}[1]{\def\amspset@assignment{#1}}
\newcommand{\duedate}[1]{\def\amspset@duedate{#1}}
\newcommand{\extraline}[1]{\def\amspset@extraline{#1}}

%Yu's custermization

\providecommand{\abs}[1]{\lvert#1\rvert}
