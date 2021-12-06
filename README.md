# MetricsTools_for_Redmine

## Ubuntu 14.04LTS へのインストール
### Gnuplot のインストール
  ```
  $ sudo apt-get install gnuplot
  ```

### 各 Perl モジュールのインストール
#### JSON モジュールのインストール
  ```
  $ sudo apt-get install libjson-perl
  ```
#### User Angent モジュールのインストール
  ```
  $ sudo apt-get install libwww-perl
  ```
#### Datetime モジュールのインストール
  ```
  $ sudo apt-get install libdatetime-perl
  $ sudo apt-get install libdatetime-format-strptime-perl
  ```

#### Perl Object 指向モジュールのインストール
  Ubuntu のリポジトリにも CPAN にもビルド済みのパッケージはないようなのでソー
  スからビルドしインストールする。

  ```
  $ wget http://search.cpan.org/CPAN/authors/id/K/KI/KIMOTO/Object-Simple-3.1801.tar.gz
  $ tar xfvz Object-Simple-3.1801.tar.gz
  $ cd Object-Simple-3.1801
  $ perl Makefile.PL
  $ sudo make install
  ```

## MetricsTools_for_Redmine のインストール
  任意のディレクトリ上で以下を実行する。

  ```
  $ git clone https://github.com/tkatsu/MetricsTools_for_Redmine.git
  ```
  オリジナル版は以下の松谷さんのもの。

  ```
  https://github.com/Mattani/MetricsTools_for_Redmine.git
  ```

## 実行スクリプトの設定
  1. 同梱されている `test.sh` を適当な名前でコピーし、動作環境に合わせて
  以下のように編集する。(この例では `test.sh` の名称のままとする。)

  ```
  :
  WORKSPACE=.
  DOCPATH=/var/www/html/statistics/redmine/YOUR_PROJECT
  APIKEY= ※redmine の個人設定画面で表示させたAPIアクセスキー
  URL=http://YOUR.HOSTNAME.COM/YOU_REDMINE/projects/YOUR_PROJECT/issues.json?status_id='*'
  :
  ```
  ウェブサーバの `DocumentRoot` が `/var/www/html` になっている例。
  全てのステータスのチケットを JSON 形式で取得する為、 URL の最後を
  `issues.json?status='*'` としている。

  2. 合わせて test.sh から呼ばれる `test.pl` も適当な名称でコピーし、当該プロジェクト
  に合わせ、トラッカーやステータスの名称などを変更する。

  ```
  :
  # 放置日数の集計で、対象とするトラッカー(2つ以上を指定する場合は、gp/UntouchedDays.gp も
  # 変更する必要あり。)
  &UntouchedDays::setTargetTracker(['バグ','仕様変更']);

  # 放置日数の集計で、対象外とするステータス
  &UntouchedDays::setExcludeStatus(['却下','破棄','終了']);

  # 信頼度成長曲線の起点日(月曜とか金曜などの曜日区切りの日にするのがよい)
  &CountEachWeek::setStartDate('2016-11-07');

  # 信頼度成長曲線の終点日
  # (指定しない場合は、起点日から数えて7で割り切れる実行日以前の日となる)
  #&CountEachWeek::setEndDate('2016-12-02');

  # 信頼度成長曲線で、Open 状態と見なすステータス
  &CountEachWeek::setOpenStatus(['新規','進行中','解決','フィードバック']);
  :
  ```

## 実行

 ```
 $ ./test.sh
 ```
 Redmine からデータを取得し作成したグラフが DOCPATH で指定したディレクトリに保存される。
  
 この例では、`/var/www/html/statistics/redmine/YOUR_PROJECT/images` に png 形式のグラフが保存される。

## グラフの表示
  Redmine の当該プロジェクトの Wiki で上記 png ファイルを参照する。(以下はMarkdown 記法の例)
  ```
  ## 平均完了日数
  ![平均完了日数](http://YOUR.HOSTNAME.COM/statistics/redmine/YOUR_PROJECT/images/Sample_ClosedInEachMonth.png "平均完了日数")
  ## 放置日数の分布
  ![放置日数](http://YOUR.HOSTNAME.COM/statistics/redmine/YOUR_PROJECT/images/Sample_UntouchedDays.png "放置日数")
  ## 信頼度成長曲線
  ![信頼度成長曲線](http://YOUR.HOSTNAME.COM/statistics/redmine/YOUR_PROJECT/images/Sample_CountEachWeek.png "信頼成長度曲線")

  ```
## グラフの定期更新
  必要に応じ、jenkins等を使用し、上記 シェルスクリプトを定期的に実行し、グラフを更新する。
  
以上
