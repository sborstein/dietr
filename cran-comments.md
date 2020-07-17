## Resubmission
This is a resubmission. In this version I have:

* Created unit tests using testthat for functions in which the examples are wrapped with /donttest. It is not feasible to unwrap these functions from /donttest as the functions and examples connect to a remote database and take longer than 5 seconds to run. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph and have testthat test files with similar names. I have checked the examples of these functions that are wrapped in /donttest using R CMD CHECK --run-donttest, and all ran without error.
* Addressed issues where unit tests failed on CRAN as they could not connect to a remote database. These tests will now skip if a connection can not be made. Please note that these tests ran successfully on Travis-CI as well as R WinBuilder and on my local Windows 10 and Mac OS environments, but previous submissions have had issues connecting to the database during CRAN checks.

## Test environments
* local Windows 10 install, R 4.0.2
* local Mac OS Catalina 10.15.5, R 3.6.0
* ubuntu 16.04 (on travis-ci), R 4.0.0
* win-builder (devel, release, and oldrelease)

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, Windows 10, Mac OS Catalina 10.15.5, win-builder (devel), win-builder (release), and win-builder (oldrelease)