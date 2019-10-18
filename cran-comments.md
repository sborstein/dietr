## Resubmission
This is a resubmission. In this version I have:

* Created unit tests for functions in which the examples are wrapped with /donttest. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph. These functions and the examples connect to a remote database and take longer than 5 seconds to run.

## Test environments
* local OS X install, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* win-builder (devel and release), R 3.6.1

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, OS X,win-builder (dev), and win-builder (release)