# Install Go dependencies in GitHub Actions

**Category**: workflow-basics
**Source**: https://docs.github.com/en/actions/tutorials/build-and-test-code/go

## Description

This GitHub Actions workflow sequence demonstrates how to install Go project dependencies using `go get`. It first checks out the repository and sets up a specific Go version (`1.21.x`) using `actions/setup-go`. Subsequently, it executes `go get` commands to fetch modules, including the current module, specific external modules, and modules at a particular version.

## Example Code

```yaml
    steps:
      - uses: actions/checkout@v5
      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: '1.21.x'
      - name: Install dependencies
        run: |
          go get .
          go get example.com/octo-examplemodule
          go get example.com/octo-examplemodule@v1.3.4
```
