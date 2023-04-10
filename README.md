# Autobrew Legacy Builder

System libraries for building legacy R packages on MacOS High-Sierra.

*This is not an officially supported project.*

__UPDATE:__ This repository only builds legacy (high-sierra) binaries, for R 4.2 and below on CRAN.

Starting R 4.3, CRAN is targetting MacOS 11 (Big Sur). For those binaries, including arm64 flavors, use the new [homebrew-cran](https://github.com/autobrew/homebrew-cran) tap.

## What is this

CRAN targets MacOS 10.13 (High-Sierra) on R 4.2, however this version of MacOS is no longer supported by Apple, and the current Homebrew no longer works there. Autobrew is a fork from upstream [homebrew-core](https://github.com/homebrew/homebrew-core) from the last day of MacOS 10.11 support. We selectively backport and adapt formulae needed for building R packages.

We do not expect anyone to run this version locally; it is only intended to run on MacOS high-sierra on Travis-CI. The produced binaries are eventually [combined](https://github.com/autobrew/bundler) into bundles which contain the given libraries along with all dependencies needed to build the R package.

These self-contained bundles are then published into the [autobrew archive](https://github.com/autobrew/archive), and can easily be downloaded by R packages using these [scripts](https://github.com/autobrew/scripts).

## Contributing

If you send a pull request, the formula that has been changed will automatically be built on Travis CI. At the end of the CI run the new binary bottle is uploaded to `file.io` and you see a download link in the Travis log.
