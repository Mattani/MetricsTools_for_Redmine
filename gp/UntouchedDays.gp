# 放置日数の分布 gnuplotスクリプト

set terminal png size 800,500
set output outfile
set datafile separator
set fontpath "/usr/share/fonts/"

set style fill solid border lc rgb "black"
set boxwidth 0.8 relative				# 棒グラフの幅を指定する
set key inside right width -1 nobox font 'ipag,10'

# 下マージンを設定する（X軸ラベルの場所確保用）
set bmargin 3
set lmargin 9 

# X軸,Y1軸,Y2軸目盛を表示する
set xtics  font 'ipag,12'
set ytics  nomirror font 'ipag,12'
# X軸,Y軸の範囲を指定する
set xrange[-0.5:13.5<*]
set yrange[0:20<*]
# Y軸の目盛数字の表示形式を指定する
set format y "%2.0f"
# Y軸（左右）のラベルを設定する
set ylabel "Number of tickets" font 'ipag,12'

# ゼロは表示しない関数を定義
omit_zero(x) = (x == "0" ? "" : sprintf("%d",x))

# グラフをプロットする。

plot infile using 0:($2+$3)   with boxes lw 1 lc rgb "orange"  title "問合せ",\
     infile using 0:($2)   with boxes lw 1 lc rgb "light-pink"  title "バグ",\
     infile using 0:($2+$3):(omit_zero($2+$3)) with labels font 'ipag,12' offset 0.3,0.3 title "" ,\
     infile using 0:($2+$3/2):(omit_zero($3)) with labels font 'ipag,9' title "" ,\
     infile using 0:($2/2):(omit_zero($2)) with labels font 'ipag,9' title "" 

