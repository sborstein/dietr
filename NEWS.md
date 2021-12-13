dietr 1.1.3
============

## Minor changes
* Fixed issue with assuming relative abundance provided would sum to 1 in Electivity function. The function has new option CalcAbundnace which allows users to calculate relative abundance if desired. If you previously used this function with relative abundance data that was incomplete and did not sum to 1, you may get incorrect results and should re-run analyses.
* Updated vignette.