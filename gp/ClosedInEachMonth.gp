set terminal png size 800,500
set output outfile
set fontpath "/usr/share/fonts/"

#set title "発生インシデント数・平均完了日数" font 'ipag,14' 
set style fill solid border lc rgb "black" 
set boxwidth 0.3 relative				# 棒グラフの幅を指定する
set key inside font 'ipag,8' spacing 2 width 3 

# 下マージンを設定する（X軸ラベルの場所確保用）
set bmargin 4 
set lmargin 9 
set rmargin 9

# X軸,Y1軸,Y2軸目盛を表示する
set xtics rotate by 45 offset -4,-3  font 'ipag,12'
set ytics  font 'ipag,12'
set y2tics font 'ipag,12'
# X軸,Y軸の範囲を指定する
set xrange [-0.4:8.6<*]
set yrange [0:100]
set y2range [0:100]
# Y軸の目盛数字の表示形式を指定する
set format y "%2.0f"
set format y2 "%2.0f"
# Y軸（左右）のラベルを設定する
set ylabel "インシデント発生数（件）" font 'ipag,12' offset -1,0
set y2label "平均完了日数（日）" font 'ipag,12' offset 1.5,0
# グラフをプロットする。
plot infile using 0:($2+$3) axes x1y1 with boxes linewidth 1 linecolor "light-cyan" title "発生インシデント数（件）",\
     infile using 0:($2) axes x1y1 with boxes linecolor "dark-pink" title "未完了インシデント数（件）",\
     infile using 0:($4/$3):xtic(1) axes x1y2 with linespoints linecolor "red" linewidth 3 title "平均完了日数（日）" ,\
     infile using 0:($2+$3):(sprintf("%d",($2+$3))) with labels font 'ipag,12' offset 0,0.5 title ""

