# Blog

ブログシステム

## Ruby version

- See `.ruby-version`.

## Rails version

- See `Gemfile`.

## System dependencies

- Postgresql
- Redis
- Node.js >= 6.0.0
- Yarn >= 0.20.1
- Production
  - Heroku
  - AWS S3
- CI
  - Circle CI

## Project initiation

- リポジトリのクローン

```bash
$ git@github.com:startup-technology/blog.git
```

- Gemのインストール

```bash
$ bundle install --path vendor/bundle
```

- npmパッケージのインストール

```bash
$ yarn install
```

### Configuration

*ファイルの中身はご自身の環境に合わせて適宜変更してください*

- データベースの設定

```bash
$ cp -v config/database.yml{.default,}
```

- 環境変数の設定

```bash
$ cp -v .env{.default,}
```

*AWSのアクセスキーなどは個別に担当者に聞いてください。*

### Database creation

```bash
$ bundle exec rails db:create db:schema:load
```

### Database initialization

```bash
$ bundle exec rails db:seed
```

## Run rails server

```bash
$ bundle exec rails server
```

## Webpacker

JavaScriptのビルド

```
$ ./bin/webpack
```

webpack-dev-server の起動

```
$ ./bin/webpack-dev-server
```

## Spec

.rspec の設定

```bash
$ cp -v .rspec.default .rspec
```

テストの実行

```bash
$ bundle exec bin/rspec
```

## How to run the static code analysis

### Rubocop

```bash
$ bundle exec rubocop -R
```

### Reek

```bash
$ bundle exec reek
```

### Rails best practices

```bash
$ bundle exec rails_best_practices
```

### Brakeman

```bash
$ bundle exec brakeman
```

### ESLint

```bash
$ npm run lint
```

### SCSS-Lint

```bash
$ bundle exec scss-lint
```

### Slim-Lint

```bash
$ bundle exec slim-lint
```

## EditorConfig

-  ご自身のエディタに[EditorConfig](http://editorconfig.org/)のインストールをお願いします。

## Development controller

### Force login

- See `app/controllers/development/sessions_controller.rb`

```
http://localhost:3000/login_as/[user_id]
```

