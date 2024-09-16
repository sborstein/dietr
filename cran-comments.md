## Resubmission
This is a resubmission. The below error, caused by an update of the dependency rfishbase, has now been fixed.

```
checking examples with --run-donttest ... ERROR
```

* There are unit tests using testthat for functions in which the examples are wrapped with /donttest. It is not feasible to unwrap these functions from /donttest as the functions and examples connect to a remote database and often take longer than 5 seconds to run. These functions are ConvertFishbaseFood, ConvertFishbaseDiet, FoodTroph, and DietTroph and have testthat test files with similar names. I have checked the examples of these functions that are wrapped in /donttest using R CMD CHECK --run-donttest, and all ran without error.

## Test environments
* local Windows 10 install, R 4.4.1
* Ubuntu 22.04.4  on GitHub Actions(devel, release, oldrelease)
* win-builder (devel, release, and oldrelease)
* macosx-arm64, R 4.4.1
## R CMD check results
0 errors | 0 warnings | 0 notes
For R CMD check ran with ubuntu, Windows 10, win-builder (devel), win-builder (release), and win-builder (oldrelease), macosx-arm64