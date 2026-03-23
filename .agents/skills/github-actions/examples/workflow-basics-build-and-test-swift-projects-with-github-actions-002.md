# Build and Test Swift Projects with GitHub Actions

**Category**: workflow-basics
**Source**: https://docs.github.com/en/actions/tutorials/build-and-test-code/swift

## Description

This GitHub Actions workflow example illustrates the process of building and testing Swift code. It first checks out the repository, then sets up Swift version 5.3.3 using `swift-actions/setup-swift`, and finally executes `swift build` and `swift test` commands to compile and run tests for the project.

## Example Code

```yaml
# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.
steps:
  - uses: actions/checkout@v5
  - uses: swift-actions/setup-swift@65540b95f51493d65f5e59e97dcef9629ddf11bf
    with:
      swift-version: "5.3.3"
  - name: Build
    run: swift build
  - name: Run tests
    run: swift test
```
