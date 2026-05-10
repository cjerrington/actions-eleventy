# GitHub Action for Eleventy

Use this action to build your static website with [Eleventy](https://www.11ty.dev/).

To use it, create a `.github/workflows/eleventy_build.yml` file which [uses this repository](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idsteps) as an action.

Here's an example which builds the site with this action, then deploys to GitHub Pages with [peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages):

```yaml
name: Eleventy Build
on: [push]

jobs:
  build_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        uses: cjerrington/actions-eleventy@v2
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          publish_dir: _site
          publish_branch: gh-pages
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

This action accepts a couple of optional inputs:

| Input Name             | Required? | Default | Description                                                            |
| ---------------------- | :-------: | :-----: | ---------------------------------------------------------------------- |
| `args`                 |    No     |  `""`   | Arguments to pass to the Eleventy invocation                           |
| `install_dependencies` |    No     | `false` | If set to `true`, `npm install` will be run before Eleventy is invoked |

For example:

```yaml
- name: Build
  uses: cjerrington/actions-eleventy@v2
  with:
    args: '--output=_dist'
    install_dependencies: true
```

## Migrating from v1 to v2

v2 replaces the Docker container action with a **composite action** that runs natively on the GitHub runner. This means faster execution (no Docker image build/pull) and simpler maintenance.

### What changed

| Aspect       | v1 (Docker)                   | v2 (Composite)                         |
| ------------ | ----------------------------- | -------------------------------------- |
| Runtime      | Custom Docker container       | Native on the runner                   |
| Dependencies | Eleventy pre-installed globally | Resolved via `npx` (cached by npm)    |
| `args` input | Optional, no default          | Optional, defaults to `''`             |
| `install_dependencies` | Must be `true` or unset | Must be `'true'` (string) or `'false'` |

### Steps to migrate

1. Update the action reference from `@v1.x` to `@v2` (or `@master`).
2. If you use `install_dependencies: true`, change it to `install_dependencies: 'true'` (string, since composite action inputs are always strings).
3. Remove any workflow workarounds you may have added to handle the Docker container (e.g. custom `npm install` steps before the action — v2 handles this natively).
4. The `DEPLOY_TOKEN` secret is no longer needed — use the built-in `GITHUB_TOKEN` instead (or keep your own if you prefer).

**Before (v1):**
```yaml
- uses: actions/checkout@master
- name: Build
  uses: cjerrington/actions-eleventy@v1.3
  with:
    install_dependencies: true
```

**After (v2):**
```yaml
- uses: actions/checkout@v4
- name: Build
  uses: cjerrington/actions-eleventy@v2
  with:
    install_dependencies: 'true'
```
