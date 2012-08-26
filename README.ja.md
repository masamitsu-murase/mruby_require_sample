
# mruby `require` のサンプル

## 概要

このライブラリは、mruby で `require` を試しに実装してみたときのサンプルです。

## 使い方

以下のようなサンプルファイルを用意します。

```ruby
# test.rb

class Test
  Const = "const"
end
```
```ruby
# main.rb

require("test")

p Test::Const
```

これらを mrbc でバイナリファイルにコンパイルします。  
`-B` の方であり、`-C` でないことに注意してください。

    % mrbc -Bdata_test test.rb
    % mrbc -Bdata_main main.rb

変数名は `data_#{filename}` にしてください。  
そのため、C で変数名として解釈できるように、ファイル名には "-" などを入れないでください。

これで `test.c`, `main.c` が得られた状態になります。

あとは、これらを mruby を用いたアプリケーションを作成する際に、コンパイルしてリンクさせてください。  
例えば、以下のようなファイルを用意します。

```c
/* sample.c */
#include <stdio.h>

#include <mruby.h>
#include <mruby/dump.h>
#include <mruby/proc.h>
#include <mruby_require.h>

extern const char data_main[];

int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  int n = -1;

  if (mrb == NULL) {
    fprintf(stderr, "Invalid mrb_state, exiting mruby");
    return EXIT_FAILURE;
  }

  mrb_init_kernel_require(mrb);  /* initialize this library */

  n = mrb_read_irep(mrb, data_main);
  mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_top_self(mrb));
  mrb_close(mrb);

  return EXIT_SUCCESS;
}
```

こちらをコンパイルし、`libmruby_require.a`, `libmruby.a`, `libmruby_core.a`, `test.o`, `main.o`, `test.o` とリンクさせればできあがりです。

## 仕組み
仕組みというほどややこしいことはしていませんが、 `-B` オプションでコンパイルされたものを、 `mrb_read_irep` で読み込んで実行させています。

`require("hoge")` の場合、`data_hoge` を読み込みに行っていますが、その際に `dlsym` で大域変数を探しに行っています。  
そのため、`strip` などで未参照のシンボルを削除してしまうと、 `data_***` が削除されてしまい、うまく動作しないでしょう。

詳しくは `test/mruby_require_test.c` などを見てみてください。

