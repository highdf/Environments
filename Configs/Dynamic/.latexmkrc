# ~/.latexmkrc
$pdf_mode = 1;
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$dvi_mode = 0;
$postscript_mode = 0;
$biber = 'biber %O %S';
$clean_ext = "aux bbl blg log";
$out_dir = "build";
$pdf_previewer = 'zathura';
