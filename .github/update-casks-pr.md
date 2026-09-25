Update casks from stable WolffTech GitHub Releases. SHA-256 values were calculated from the downloaded DMGs.

Before merging, inspect the new bundles for changes to architecture, minimum macOS, signing, notarization, and uninstall behavior. Run lifecycle tests in a disposable macOS environment.

This workflow validates syntax, style, audit, release discovery, and updater tests before opening the PR. The separate PR checks workflow waits for approval in the Actions tab before it runs on this bot's PRs.
