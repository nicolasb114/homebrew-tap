# nicolasb114/homebrew-tap

Homebrew formulae for my projects.

## Install

```bash
brew install nicolasb114/tap/pd-status-wall
```

## Formulae

| Formula | Description |
|---|---|
| [`pd-status-wall`](Formula/pd-status-wall.rb) | [Status video wall for PagerDuty Business Services](https://github.com/nicolasb114/pd-status-wall) |

Installing through Homebrew also avoids macOS's quarantine prompt, which
a browser download of an un-notarized binary would otherwise hit.

## How the formula stays current

A [workflow](.github/workflows/update-formula.yml) in this repo checks
`pd-status-wall` hourly and bumps the formula when a new release appears,
taking checksums straight from that release's `SHA256SUMS`. It can also be
run on demand from the Actions tab to publish a release immediately.

It lives here rather than in `pd-status-wall` so it can push with the
built-in `GITHUB_TOKEN` - a workflow in the other repo would need a
hand-made cross-repo token.
