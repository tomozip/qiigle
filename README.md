# Qiigle
Googleのように直感的で探しやすく、Qiita記事を楽しめるようなUIのアプリを意識しました。

![Qiigle_mid](https://user-images.githubusercontent.com/26210799/61195966-71a82c80-a706-11e9-8251-fd8e2d5a22fa.gif)

自作のデザインファイルは`design/`以下に置いてあります。

## How to Build
```bash
$ pod install
$ carthage update --platform ios
```

## Features
###  トップページ
トップページでは、検索窓を表示させるだけにせず、検索をせずとも記事を楽しめるようおすすめの記事を自動で一覧表示させました。

<img src="https://i.gyazo.com/4835fc3517e723574507a2a450b1ccb6.png" alt="Image from Gyazo" width="285"/>

#### 機能
- キーワード検索
- おすすめ記事の一覧取得

#### こだわり
- 検索・おすすめ記事の取得、どちらも20件ずつ取得し最下部までスクロールするとさらに20件の取得が行われるようなページング
- 検索・おすすめ記事の取得時、リクエストから結果表示までのローディング画面の用意
- 記事をタップした後に、記事のHTMLのレンダリングが重く画面遷移までの待機時間があるため、遷移中のローディング画面の用意


### 記事詳細ページ
上部に記事タイトル・ユーザー情報・いいね数を表示し、またHTML文字列から記事本文を表示させるようにしました。

<img src="https://i.gyazo.com/8ad1809f0f2f83c7c131c6e33130570b.png" alt="Image from Gyazo" width="285"/>

#### 機能
- いいね数をタップするといいねしたユーザーの一覧ページへ遷移

#### こだわり
- 記事をレンダリングする際、Markdownを表示させるライブラリを使うと画像が表示されなかったため、HTMLを元にレンダリングするよう変更
- HTMLからレンダリングする際、画像幅が画面を飛び出さないようにresizeするよう対応


### いいねユーザー一覧ページ
<img src="https://i.gyazo.com/4f32acf8572150594d51fbad0c5fea6f.png" alt="Image from Gyazo" width="287"/>

#### こだわり
- まずユーザーを20件取得し、最下部までスクロールするとさらに20件の取得が行われるようなページング
- 表示ユーザー数が記事のいいね数と同じになったタイミングで、これ以上不要なページングリクエストがされないよう対応


## Architecture
Qiigleでは[ReactorKit](https://github.com/ReactorKit/ReactorKit)を使用した Flux + ReactiveProgramming での設計を採用しました。
また、API通信をReactiveに対応させるため、[Moya](https://github.com/Moya/Moya)を使用したAPI通信を採用しています。

ReactorKitでは主に、以下２つのファイルが使用されます。
- ViewController
- Reactor

例として、`qiigle/UI/Home/` 以下の`HomeViewController.swift`と`HomeViewReactor.swift`を見ると分かり易かと思います。

ReactorKitでのAPI通信のコードも書いているので参考にしてみてください。
