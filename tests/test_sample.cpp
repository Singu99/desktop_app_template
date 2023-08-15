// Define CATCH_CONFIG_MAIN to let Catch2 provide the main function
#define CATCH_CONFIG_MAIN
// Include the catch.hpp header file
#include "catch.hpp"
// Include the header file of the code you want to test
#include "binary_search.hpp"

// Write your test cases using TEST_CASE macro
TEST_CASE("Binary search works correctly", "[binary_search]") {
    // Create a vector of sorted integers
    std::vector<int> v = {1, 3, 5, 7, 9};
    // Use REQUIRE macro to check for boolean expressions
    REQUIRE(binary_search(v, 1) == 0); // 1 is at index 0
    REQUIRE(binary_search(v, 9) == 4); // 9 is at index 4
    REQUIRE(binary_search(v, 4) == -1); // 4 is not in the vector
    // Use SECTION macro to divide the test case into smaller parts
    SECTION("Empty vector returns -1") {
        std::vector<int> empty;
        REQUIRE(binary_search(empty, 1) == -1);
    }
    SECTION("Vector with one element works") {
        std::vector<int> one = {42};
        REQUIRE(binary_search(one, 42) == 0);
        REQUIRE(binary_search(one, 0) == -1);
    }
}
