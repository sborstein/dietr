## Resubmission
This is a resubmission. In this version I have:

* Created unit tests using testthat for functions in which the examples are wrapped with /donttest. It is not feasable to unwrap these functions from /donttest as the functions and examples connect to a remote database and take longer than 5 seconds to run. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph and have testthat test files with similar names. 

## Test environments
* local Windows 10 install, R 4.0.1
* ubuntu 16.04 (on travis-ci), R 4.0.0
* win-builder (devel and release), R 4.0.1

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, win-builder (dev), and win-builder (release)