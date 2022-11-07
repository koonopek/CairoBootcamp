// Perform and log output of simple arithmetic operations
func simple_math() {
   // adding 13 +  14
   let p = 13 + 14;
   %{ print(f"passing value: {ids.p}") %}
   // multiplying 3  * 6
   let a = 3 * 6;

   %{ print(f"passing value: {ids.a}") %}
   // dividing 6 by 2
   let b = 6 / 2;

   %{ print(f"passing value: {ids.b}") %}
   // dividing 70 by 2
   let c = 70 /2;

   %{ print(f"passing value: {ids.c}") %}
   // dividing 7 by 2
   let d = 7 /2;
   %{ print(f"passing value: {ids.d}") %}

    return ();
}
