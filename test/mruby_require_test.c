/* sample.c */
#include <stdio.h>

#include <mruby.h>
#include <mruby/dump.h>
#include <mruby/variable.h>
#include <mruby/proc.h>
#include <mruby_require.h>

extern const char data_main[];

static int
check_result(mrb_state *mrb)
{
  /* Error check */
  /* $ko_test and $kill_test should be 0 */
  mrb_value ko_counter = mrb_gv_get(mrb, mrb_intern(mrb, "$ko_counter"));

  if (FIXNUM_P(ko_counter) && mrb_fixnum(ko_counter) == 0){
      return EXIT_SUCCESS;
  }else{
      return EXIT_FAILURE;
  }
}

int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  int n = -1;
  int ret;

  if (mrb == NULL) {
    fprintf(stderr, "Invalid mrb_state, exiting mruby");
    return EXIT_FAILURE;
  }

  mrb_init_kernel_require(mrb);  /* initialize this library */

  n = mrb_read_irep(mrb, data_main);
  mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_top_self(mrb));
  ret = check_result(mrb);
  mrb_close(mrb);

  return ret;
}
