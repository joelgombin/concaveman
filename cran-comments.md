## Test environments
* local R installation (Ubuntu 20.04), R 4.0.0
* Github Actions, macOS-latest, R 4.0.0
* Github Actions, window-latest, R 4.0.0
* Github Actions, Ubuntu 16.04, R 4.0.0
* Github Actions, Ubuntu 16.04, R 3.6.0
* Github Actions, Ubuntu 16.04, R 3.5.0
* Github Actions, Ubuntu 16.04, R 3.4.0
* Github Actions, Ubuntu 16.04, R 3.3.0

mac-OS latest with R-devel fails in Github Actions, but I believe that this is because no binary version of sf is available for it. 

Please note that, due to dependency conflicts for `sf` 0.9, testing may fail in some environments. It is in particular the case for rhub, which does not allow to use the ubuntugis-unstable PPA necessary to get the necessary versions of GDAL, GEOS and PROJ4 for sf 0.9. This is why I favored Github Actions. 

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.

## Downstream dependencies

I ran `revdepcheck::revdep_check()`. There is no problem with the downstream dependencies.
