use warnings;
use strict;
use utf8;

our @default_files = ("CV.tex");
our $pdf_mode = 1;
our $bibtex_use = 2;

our $out_dir = "build";
our $pdflatex = "lualatex -file-line-error -interaction=nonstopmode -synctex=1 -shell-escape %O %S";
our $biber = "biber --validate-datamodel %O %S";

ensure_path("TEXINPUTS", "./Texmf//");
