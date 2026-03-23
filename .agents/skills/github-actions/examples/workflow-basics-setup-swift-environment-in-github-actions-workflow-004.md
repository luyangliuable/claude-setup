# Setup Swift Environment in GitHub Actions Workflow

**Category**: workflow-basics
**Source**: https://docs.github.com/en/actions/tutorials/build-and-test-code/swift

## Description

This GitHub Actions workflow snippet demonstrates how to initialize a Swift development environment. It utilizes the `swift-actions/setup-swift` action to install a specific Swift version (5.3.3) and includes a step to verify the installation by checking the Swift compiler version.

## Example Code

```yaml
# separate terms of service, privacy policy, and support
# documentation.
steps:
  - uses: swift-actions/setup-swift@65540b95f51493d65f5e59e97dcef9629ddf11bf
    with:
      swift-version: "5.3.3"
  - name: Get swift version
    run: swift --version # Swift 5.3.3
```
