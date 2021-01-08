find . -type f -name \*.html -mtime -5 -exec grep "Blocking Sid (Inst)" {} \; -exec echo {} \; | grep html |sort | xargs grep -H Linux {} > 1.txt
perl -ne '@F = split("[\<\>\:]", $_); print "$F[0] $F[48]\n";' 1.txt |sort
