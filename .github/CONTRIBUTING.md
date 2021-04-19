# Contributing to abscorr

People are actively encouraged to contribute to this package. The intention of this project is to provide 
an avenue for people to learn about and improve their R package development skills. 


## Contribute Code

To contribute code please fork the project by clicking on the `fork` link in the top 
right of the github repository. This will create a version of the package that you can 
work on. Once you have completed your changes they can be submitted via a Pull Request (PR).

New code should follow the tidyverse [style guide](http://style.tidyverse.org).
You can use the [styler](https://CRAN.R-project.org/package=styler) package to
apply these styles, but please don't restyle code that has nothing to do with 
your PR.  


## Contribute Tests

We use [testthat](https://cran.r-project.org/package=testthat). If you are submitting a 
new function please ensure it has an associated test.

Tests are a vital development tool, but they are also a great way to learn about how a 
package works. You can go through the examples in the existing tests. If you think a 
use case does not have a test please submit one.


## Contribute to Documentation

We use [roxygen2](https://cran.r-project.org/package=roxygen2), with
[Markdown syntax](https://roxygen2.r-lib.org/articles/rd-formatting.html), 
for package documentation. 

We also use [pkgdown](https://cran.r-project.org/package=pkgdown) to generate a 
package website. If you have created a new function and documented it with 
[roxygen2](https://cran.r-project.org/package=roxygen2) you can update the site using:

```r
pkgdown::build_site()
```

Long-form package documentation is contained in package vignettes. These [rmarkdown](https://cran.r-project.org/package=rmarkdown)
files are all located in the vignettes folder. Package vignettes can be rendered all together 
(pretty slow) or one at a time using:

```r
pkgdown::build_articles()

# OR

pkgdown::build_article('abscorr.Rmd')
```

For user-facing changes, add a bullet to the top of `NEWS.md` below the
current development version header describing the changes made.



## File an Issue

If you’ve found a bug or have a suggestion for improvements, create an associated issue 
and illustrate the bug with a minimal [reprex](https://www.tidyverse.org/help/#reprex).



## Fixing typos

Small typos or grammatical errors in documentation may be edited directly using
the GitHub web interface, so long as the changes are made in the _source_ file.

*  YES: you edit a roxygen comment in a `.R` file below `R/`.
*  NO: you edit an `.Rd` file below `man/`.



## Code of Conduct

Please note that the abscorr project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this
project you agree to abide by its terms.


## Attribution

This `CONTRIBUTING.md` document is adapted from [pkgdown](https://github.com/r-lib/pkgdown/blob/master/.github/CONTRIBUTING.md)
