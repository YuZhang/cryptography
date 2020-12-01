echo '\input{frame.tex}'
echo '\begin{document}'
for a in `ls -1 tikz/*.tex`
do a=`echo $a | sed 's/^.*\/\(.*\).tex/\1/'`
echo "\\begin{frame}\\frametitle{${a}}"
echo '\begin{figure}'
echo '\begin{center}'
echo "\\input{tikz/${a}.tex}"
echo '\end{center}'
echo '\end{figure}'
echo '\end{frame}'
done
echo '\end{document}'
