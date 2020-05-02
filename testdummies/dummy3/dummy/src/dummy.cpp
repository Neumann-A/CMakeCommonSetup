
#include "dummy.h"
#include "dummy_private.h"

int dummy_func_impl(int i)
{
    return i;
}

int dummy_func(void)
{
    return dummy_func_impl(42);   
}