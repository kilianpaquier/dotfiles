---
applyTo: "**/.gitlab-ci.{yml,yaml},**/.gitlab/**/*.{yml,yaml}"
description: GitLab CI conventions
globs: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
paths: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
---

# GitLab CI

## To Be Continuous

Use [To Be Continuous](https://gitlab.com/to-be-continuous) components whenever a supported tool or workflow is needed. Each component's available `inputs` are defined in its template file.

Template URL pattern: `https://gitlab.com/to-be-continuous/{component}/-/raw/main/templates/gitlab-ci-{component}.yml`

Exception: `semantic-release` uses alias `semrel` → `gitlab-ci-semrel.yml`.

Available components: `ansible`, `aws`, `azure`, `bash`, `docker`, `gcloud`, `golang`, `gradle`, `helm`, `maven`, `node`, `pre-commit`, `python`, `renovate`, `rust`, `semantic-release`, `sonar`, `terraform`.

## Includes

- Use `include: - component:` for all external templates. Prefer it over `project:`, `remote:`, and `template:`.
- Use `inputs:` to pass parameters to a component.
- Pin component references to a tag:
  ```yaml
  - component: gitlab.com/org/template/job@1.5.0
    inputs:
      some-input: value
  ```
- Use `include: - local:` only for referencing local pipeline files within the same repo.

## Job key ordering

Order job keys as follows (omit keys that are not needed):

1. `extends`
2. `stage`
3. `image`
4. `environment`
5. `needs`
6. `dependencies`
7. `rules`
8. `variables`
9. `before_script`
10. `script`
11. `after_script`
12. `artifacts`
13. `cache`
14. `allow_failure`
15. `interruptible`

## Jobs

- Names: `kebab-case`. Use `:` as a namespace separator (e.g., `semantic-release:dry-run`).
- Set `needs: []` for jobs that must run immediately without waiting on prior stages.
- Set `interruptible: true` globally via `default:` block; override with `interruptible: false` for release jobs.

## Variables

- Names: `SCREAMING_SNAKE_CASE`.

## Rules

- Use `rules:` with `if/when` pairs. Prefer `rules:` over `only:/except:`.
- Prefer conditions with explicit `when: never` to block cases; end with `when: on_success` as the fallback:

  ```yaml
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: never
    - when: on_success
  ```
