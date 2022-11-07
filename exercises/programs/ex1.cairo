// Create a function that accepts a parameter and logs it
func log_value(y: felt) {
   // Start a hint segment that uses python print()
    let p = 1;
    %{ print(f"passing value: {ids.p}") %}
   // This exercise has no tests to check against.

    return ();
}
