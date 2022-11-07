# Task 1

Use cases for ZKP:
- Identity with set of attributes which are hidden like:
  - credit score
  - illnes
  - age
  - ...
- New loggin system, which doesn't leak any knowledge
- Proving computation was done:
  - for example that someone used some ML model to X result

# Task 2

Working with the following set of Integers S = {0,1,2,3,4,5,6,7,8}
What is
a) 4 + 5
b) 3 x 5

Answer:
a) 4 + 5 mod 9 = 0 
b) 3 x 5 mod 9 = 6

# Task 3
For S = {0,1,2,3,4,5,6,7,8}
a) Can we consider 'S' and the operation multiplication to be a group ?
b) Can we consider 'S' and the operation division to be a group ?

I assume that when multipliaction is multiplication with modulo, same with division.
Otherwise both of this operation aren't group cause $G*G not_in G$ for example $5 x 8$ or $5 / 8$

a) Associativity - yes
   Identity element - yes - 1
   Inverse element - nope
  So it is not a group

b) Some as a), because division is special case of multiplication
