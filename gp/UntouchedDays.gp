# 放置日数の分布 gnuplotスクリプト

set terminal png size 800,500
set output outfile
set datafile separator
set fontpath "/usr/share/fonts/"

# set title "放置日数" font 'ipag,14' 
# 作成日時を挿入
set timestamp "%Y-%m-%d %H:%M 作成" top offset 50,-2.5 font 'ipag,10'

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
set ylabel "チケット数" font 'ipag,12'
# X軸のラベルを設定する
set xlabel "日数" font 'ipag,12'

# ゼロは表示しない関数を定義
omit_zero(x) = (x == "0" ? "" : sprintf("%d",x))

set key autotitle columnheader 

# グラフをプロットする。
plot infile using 0:($2+$3)   with boxes lw 1 lc rgb "orange"  title columnheader(3),\
     infile using 0:($2)   with boxes lw 1 lc rgb "light-pink"  title columnheader(2),\
     infile using 0:($2+$3):(omit_zero($2+$3)) with labels font 'ipag,12' offset 0.3,0.3 title "" ,\
     infile using 0:($2+$3/2):(omit_zero($3)) with labels font 'ipag,9' title "" ,\
     infile using 0:($2/2):(omit_zero($2)) with labels font 'ipag,9' title "" 

