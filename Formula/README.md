# CLI formulae

Add future command-line tools as `Formula/<tool-name>.rb`. Use a versioned source
or binary URL, a verified SHA-256, required dependencies, an `install` method,
and a focused `test do` block. Desktop applications belong in `Casks/`.

Follow the [Formula cookbook](https://docs.brew.sh/Formula-Cookbook).
Add formula audit and test coverage when the first formula lands. This tap does
not build bottles for casks.
