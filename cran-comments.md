## Package Update
This is a package update that fixes a minor bug, typos in documentation, and adds a new feature to a function. Note:

* There are unit tests using testthat for functions in which the examples are wrapped with /donttest. It is not feasible to unwrap these functions from /donttest as the functions and examples connect to a remote database and often take longer than 5 seconds to run. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph and have testthat test files with similar names. I have checked the examples of these functions that are wrapped in /donttest using R CMD CHECK --run-donttest, and all ran without error.

## Test environments
* local Windows 10 install, R 4.1.2
* local Ubuntu 20.04, R 4.1.2
* ubuntu 16.04 (on travis-ci), R 4.0.2
* win-builder (devel, release, and oldrelease)

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, Windows 10, win-builder (devel), win-builder (release), and win-builder (oldrelease)