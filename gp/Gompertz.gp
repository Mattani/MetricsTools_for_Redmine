# ゴンペルツ曲線GNUPLOTスクリプト

set terminal png size 800,500
set output outfile
set fontpath "/usr/share/fonts/"

# set title "信頼度成長曲線" font 'ipag,14'

# 作成日時を挿入
set timestamp "%Y-%m-%d %H:%M 作成" top offset 50,-2.5 font 'ipag,10'

set style fill solid border lc rgb "black"
set boxwidth 0.3 relative                               # 棒グラフの幅を指定する
set key inside left width -1 nobox font 'ipag,10'

# 下マージンを設定する（X軸ラベルの場所確保用）
set bmargin 7
set lmargin 9
set rmargin 9

# X軸,Y1軸,Y2軸目盛を表示する
set xtics nomirror rotate by 45 offset -5,-4  font 'ipag,12'
set ytics nomirror font 'ipag,12'
set y2tics nomirror font 'ipag,12'

# Y軸の目盛数字の表示形式を指定する
set format y "%2.0f"
# Y軸（左右）のラベルを設定する
set ylabel "累積バグ件数（件）" font 'ipag,12' offset 1,0
set y2label "バグ件数（件）" font 'ipag,12' offset 0,0

#
lastrow=system(sprintf("gawk 'END{print NR;}' %s",infile))
lastvalue=system(sprintf("gawk 'END{print $4;}' %s",infile))

# ゼロは表示しない関数を定義
omit_zero(x) = (x == "0" ? "" : sprintf("%d",x))
# ゴンペルツ曲線の式を定義
f(x)=K*b**exp(-c*x)

# 係数の初期値を設定
K=150
b=0.1
c=0.1

# X軸,Y軸の範囲を指定する
#set xrange[-0.5:lastrow*1]
set xrange[-0.5:17.5<*]
set yrange[0:K*1.1<*]
set y2range[0:K*0.55<*]

fit f(x) infile using 0:4 via K,b,c
set label sprintf("バグ数（収束値） %2.0f件", K ) at graph 0.7, 0.8 font 'ipag,12'
set label sprintf("バグ数（実績）   %2s件", lastvalue ) at graph 0.7, 0.8 font 'ipag,12' offset 0,-1
if (lastvalue <= K) CRate = lastvalue/K; else CRate = K/lastvalue
set label sprintf("バグ収束率       %2.1f％", CRate*100 ) at graph 0.7, 0.8 font 'ipag,12' offset 0,-2
plot infile using 0:3 axes x1y2 with boxes lw 1 lc rgb "light-green" title "当週バグ件数",\
     infile using 0:2 axes x1y2 with boxes lw 1 lc rgb "light-pink" title "当週未完了バグ件数",\
     f(x) with line linecolor rgb "blue" linewidth 3 title "",\
     infile using 0:4:xtic(1) with points pt 5 lc rgb "red" title "", \
     infile using 0:3:(sprintf("%d",($3))) axes x1y2 with labels font 'ipag,10' offset 0.3,0.5 title ""

