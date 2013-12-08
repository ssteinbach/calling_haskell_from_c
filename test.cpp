#include <HsFFI.h>

// haskell code
#include "Safe_stub.h"

#include <iostream>

/**
 * Example CPP code calling Haskell functions.
 */

int
main(int argc, char *argv[])
{
    hs_init(&argc, &argv);

    // fibonacci_hs is the haskell function
    for (auto i : {2,4,6,8})
    {
        auto result = fibonacci_hs(i);
        std::cout << "Fibonacci of " << i << ": " << result << std::endl;
    }

    hs_exit();
    return 0;
}
