# `Massign` - simple matrix construction in R

### What is this?
An `R` package with a single function: the matrix assignment operator `%<-%`.

### Why is this?
What's simpler:

```R

M <- matrix(c(1, 0.2, -0.3, 0.4, 0.2, 1, 0.6, -0.4, -0.3, 0.6, 1, 0.4, 0.4,
              -0.4, 0.4, 1),
            nrow = 4,
            ncol = 4,
            byrow = TRUE)
```
or

```R

M %<-% "   1,  0.2, -0.3,  0.4
         0.2,    1,  0.6, -0.4
        -0.3,  0.6,    1,  0.4
         0.4, -0.4,  0.4,    1"
```

I like the second better. Hence `Massign`.

### How do I install it?
```R

devtools::install_github("vankesteren/Massign")
library(Massign)
```

### Can you give a more formal description?
Constructing matrices for quick prototyping can be very annoying in
R, requiring the user to think about how to fill the matrix with values using
the matrix() function. The %<-% operator solves that issue by allowing the user
to construct string matrices that look like actual matrices.

### FAQ
#### Why the choice for `%<-%`?
R users may already be used to the other matrix operations like `%*%` and `%^%`
(from `expm`). I felt this was a logical choice in that context.
