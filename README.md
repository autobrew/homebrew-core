# Autobrew Core

System libraries for building R packages.

## What is this

CRAN currently targets MacOS 10.13 (High-Sierra), however this version of MacOS is no longer supported by Apple, and the current Homebrew no longer works there. Autobrew is a fork from upstream [homebrew-core](https://github.com/homebrew/homebrew-core) from the last day of MacOS 10.11 support. We selectively backport and adapt formulae needed for building R packages.

This is not an officially supported project.

## Contributing

If you send a pull request, the formula that has been changed will automatically be built on Travis CI. At the end of the CI run the new binary bottle is uploaded to `file.io` and you see a download link in the Travis log.
