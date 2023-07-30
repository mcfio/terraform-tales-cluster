# Contributing

## Git Commit Guidelines

This project uses [Semantic Versioning](https://semver.org). Commit messages to
automatically determine the version bumps, so they should adhere to the conventions 
of [Conventional Commits (v1.0.0-beta.4)](https://www.conventionalcommits.org/en/v1.0.0-beta.4/).

### TL;DR

- Commit messages starting with `fix: ` trigger a patch version bump
- Commit messages starting with `feat: ` trigger a minor version bump
- Commit messages starting with `BREAKING CHANGE: ` trigger a major version bump.
- Others: commit types other than fix: and feat: are allowed, for example chore:, docs:, style:, refactor:, perf:, test:, and others.

## Automatic versioning

Each push to `main` triggers a [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/)
CI job that determines and pushes a new version tag (if any) based on the
last version tagged and the new commits pushed. Notice that this means that if a
Merge Request contains, for example, several `feat: ` commits, only one minor
version bump will occur on merge. If your Merge Request includes several commits
you may prefer to ignore the prefix on each individual commit and instead add
an empty commit sumarizing your changes like so:

```
git commit --allow-empty -m '[BREAKING CHANGE|feat|fix]: <changelog summary message>'
```
