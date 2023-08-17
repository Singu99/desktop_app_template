// test.cpp
#define CATCH_CONFIG_MAIN // This tells Catch to provide a main() - only do this in one cpp file
#include <catch2/catch_test_macros.hpp>

// A function to be tested
int add(int a, int b) {
    return a + b;
}

// A test case
TEST_CASE("addition works", "[math]") {
    // Some assertions
    REQUIRE(add(1, 2) == 3);
    REQUIRE(add(-1, 1) == 0);
    REQUIRE(add(0, 0) == 0);
}


