
# Sample implementation of `require` of mruby.

## Overview
This is a sample implementation of `require` of mruby.

## How to use

Prepare sample files as follows:

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

Compile these files to binary files with mrbc.  
Do not forget to use `-B` option, not `-C`.

    % mrbc -Bdata_test test.rb
    % mrbc -Bdata_main main.rb

Variable name should be set to `data_#{filename}`, so filename should not include an invalid character for C variable name, such as "-".

Now you have `test.c` and `main.c`.

Compile these files and link them when you build your own mruby's application.  
For example, prepare the following file:

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

Do not forget to call `mrb_init_kernel_require`.

Compile this file and link with `libmruby_require.a`, `libmruby.a`, `libmruby_core.a`, `test.o`, `main.o`.


