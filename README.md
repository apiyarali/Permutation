# Permutation Calculator App

**Link to published app: [Permutation](https://apiyarali.shinyapps.io/Permutation/)**

## Overview
This project is a simple web application that allows users to compute the product of two given permutations and display the powers of a permutation. The core logic resides in `permcalc.R`, which implements functions for permutation calculations and will be useful in later applications.

## Features
- Computes the product of two permutations using a standard permutation multiplication method.
- Displays powers of a permutation until the identity permutation is reached.
- Uses cycle notation for representing permutations.
- Supports conjugation calculations for permutations.

## Core Functions in `permcalc.R`
### `Perm.apply()`
- Takes a permutation (expressed in cycle notation) and calculates its effect on an input value `x`.
- Both the input and output are string numerals (e.g., `"3"` instead of integer `3`).
- Uses substring search to locate characters in a cycle, handling cases where `x` is followed by a parenthesis.

### `Perm.cycle.convert()`
- Converts a vector of function values into cycle notation.
- Handles cases where indices need to be numeric (`as.numeric()` ensures proper conversion).
- Constructs cycles as a vector and collapses them into a single string using `paste()`.

### `Perm.multiply()`
- Multiplies two permutations by applying `Perm.apply()` twice.
- Converts the resulting function values into cycle notation.

### `Perm.powerString()`
- Computes successive powers of a permutation until the identity permutation appears.
- Outputs a string of all the computed powers, separated by an HTML line break.

## Usage
1. Open and run the `Permutation` app.
2. Enter two permutations in cycle notation and compute their product.
3. View the powers of a given permutation.
4. Learn about conjugation rules:
   - If `b` includes cycle `(x1 x2 ... xk)`, then `c = aba⁻¹` includes cycle `(y1 y2 ... yk)`, where `yi = a(xi)`.

## Mathematical Insights
- The structure of `ab` and `ba` cycles is the same due to conjugation properties.
- Permutations describe symmetries of objects like the octahedron and dodecahedron:
  - The **octahedron** supports all `4! = 24` color permutations through specific axis-based rotations.
  - The **dodecahedron** allows only even permutations (`5!/2 = 60`), explaining its subgroup structure.
