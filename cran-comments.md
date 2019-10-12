## Resubmission
This is a resubmission. In this version I have:

* Removed redundant elements from the title in DESCRIPTION
* Changed examples using \dontrun to \donttest. These examples connect to an external database and take more than 5 seconds to run.
* Eliminated an accidentally commented out code line in examples for the function DietTroph. Comments explaining the example were left in.
* I have added a citation to the book describing the equations used in the package. These are also cited in the documentation of the functions.

## Test environments
* local OS X install, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* win-builder (devel and release), R 3.6.1

## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, OS X,win-builder (dev), and win-builder (release)
