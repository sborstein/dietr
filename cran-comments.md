## Resubmission
This is an update that includes new package features. Note, in this version I have:

* Created unit tests using testthat for functions in which the examples are wrapped with /donttest. It is not feasable to unwrap these functions from /donttest as the functions and examples connect to a remote database and take longer than 5 seconds to run. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph and have testthat test files with similar names. 
* Addressed issues where unit tests failed on CRAN as they could not connect to remote database. These tests will now skip if a connection can not be made. Please note that these tests ran succesfully on Travis-CI as well as R WinBuilder, but previous submissions have had issues connecting to the database during CRAN tests.

## Test environments
* local Windows 10 install, R 4.0.1
* ubuntu 16.04 (on travis-ci), R 4.0.0
* win-builder (devel and release), R 4.0.0

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, Windows 10, win-builder (dev), and win-builder (release)