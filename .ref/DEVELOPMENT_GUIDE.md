# Pixielity Laravel Ecosystem Development Guide

This document outlines the architecture, contribution workflow, and CI/CD processes for the Pixielity Laravel ecosystem. It explains where to push code and how changes propagate to Packagist.

## 1. Architecture Overview

The ecosystem is divided into two types of repositories:

1.  **Meta-Repositories (Monorepos)**: These contain multiple packages in a single repository. Changes derived here are automatically **split** and pushed to individual read-only repositories.
2.  **Standalone Repositories**: These are standard, single-package repositories.

---

## 2. Meta-Repositories (Monorepos)

For these packages, **DO NOT** push to the individual sub-repositories (e.g., `pixielity/laravel/framework/database`) directly. They are read-only mirrors.

### A. Framework Monorepo

- **Local Path**: `Framework/`
- **GitLab Repo**: `pixielity/laravel/framework/meta`
- **CI/CD Behavior**: Pushing to this repository triggers a GitLab CI pipeline that executes `git subtree split`. It extracts changes from specific sub-directories and force-pushes them to their respective dedicated repositories.

**Sub-Packages (Managed via Split):**
| Local Source Directory | Target GitLab Repository |
| :--- | :--- |
| `src/Actions` | `pixielity/laravel/framework/actions` |
| `src/Database` | `pixielity/laravel/framework/database` |
| `src/Workflow` | `pixielity/laravel/framework/workflow` |
| `src/Logging` | `pixielity/laravel/framework/logging` |
| `src/Routing` | `pixielity/laravel/framework/routing` |
| `src/Response` | `pixielity/laravel/framework/response` |
| `src/Container` | `pixielity/laravel/framework/container` |
| `src/Support` | `pixielity/laravel/framework/support` |
| `src/Uuid` | `pixielity/laravel/framework/uuid` |
| `src/Enum` | `pixielity/laravel/framework/enum` |
| ...and others | |

### B. Telemetry Monorepo

- **Local Path**: `Telemetry/`
- **GitLab Repo**: `pixielity/laravel/telemetry/meta`
- **Process**: Similar to Framework, changes are split and distributed.

**Sub-Packages:**
| Local Source Directory | Target GitLab Repository |
| :--- | :--- |
| `src/Debugbar` | `pixielity/laravel/telemetry/debugbar` |
| `src/Telescope` | `pixielity/laravel/telemetry/telescope` |
| `src/Horizon` | `pixielity/laravel/telemetry/horizon` |
| `src/Pulse` | `pixielity/laravel/telemetry/pulse` |
| `src/Health` | `pixielity/laravel/telemetry/health` |
| `src/Sentry` | `pixielity/laravel/telemetry/sentry` |

### **How to Contribute to Meta-Repos**

1.  Navigate to `Framework` or `Telemetry`.
2.  Make changes in the specific `src/ModuleName` directory.
3.  Commit and Push to `main` (or merge a PR).
    ```bash
    cd Framework
    git add .
    git commit -m "Update Database module"
    git push origin main
    ```
4.  **Wait for CI**: The GitLab CI pipeline will run `split` jobs (e.g., `split:database`). Once green, the changes are live in the sub-repo.

---

## 3. Standalone Repositories

These are independent repositories. You push code directly to them.

**List of Standalone Packages:**
| Local Path | GitLab Repository |
| :--- | :--- |
| `Contracts/` | `pixielity/laravel/contracts` |
| `Discovery/` | `pixielity/laravel/discovery` |
| `Foundation/` | `pixielity/laravel/foundation` |
| `docs/` | `pixielity/laravel/docs` |
| `SDUI/` | `pixielity/laravel/sdui` |
| `Settings/` | `pixielity/laravel/settings` |
| `ImportExport/` | `pixielity/laravel/import-export` |
| `FeatureFlags/` | `pixielity/laravel/feature-flags` |

### **How to Contribute to Standalone Repos**

1.  Navigate to the package directory (e.g., `SDUI`).
2.  Make changes.
3.  Commit and Push directly.
    ```bash
    cd SDUI
    git add .
    git commit -m "Add new component"
    git push origin main
    ```

---

## 4. Release & Packagist Flow

All repositories (both Standalone and the _targets_ of Meta splits) are registered on **Packagist**.

1.  **Webhooks**: Every repository has a GitLab Webhook configured to notify Packagist on `push` and `tag` events.
2.  **Versioning**:
    - **Meta**: Tagging the Meta repo (e.g., `v1.0.0`) **does not automatically tag** sub-repos via the split (unless specific tooling is used). Typically, you might need to release individual sub-packages or use a monorepo release tool.
    - _Current Setup_: We use a script `tag_all.js` (or similar) to apply tags across all repositories via API if needed.
3.  **Packagist Update**:
    - When code lands in the Target Repo (either direct push or via CI split), the Webhook triggers Packagist.
    - `composer update` will then see the new `dev-main` or tagged version.

## 5. Webhook Management (Packagist Integration)

To ensure Packagist is automatically updated when code is pushed to GitLab repositories, we use GitLab Webhooks.

### A. Configuring the Webhook

We use the **Token-in-URL** method because GitLab's `X-Gitlab-Token` header is sometimes stripped or not supported by all Packagist integrations.

**Endpoint:**

```
POST https://packagist.org/api/update-package?username={PACKAGIST_USER}&apiToken={PACKAGIST_TOKEN}
```

**GitLab Setup:** 11. Navigate to **Project > Settings > Webhooks**. 12. **URL**: Enter the endpoint above (replace placeholders with credentials). 13. **Secret Token**: Leave blank (authentication is in the URL). 14. **Trigger**: Check **Push events** and **Tag push events**. 15. **SSL verification**: Enable. 16. Click **Add webhook**.

### B. Testing Webhooks via API

You can programmatically verify that the webhook is functioning by triggering a test event from GitLab.

**Endpoint:**

```
POST /projects/:id/hooks/:hook_id/test/:trigger
```

**Parameters:**

- `id` (required): ID or URL-encoded path of the project (e.g., `pixielity%2Flaravel%2Fsdui`).
- `hook_id` (required): Integer ID of the project webhook you want to test.
- `trigger` (required): The event to simulate. Common values:
  - `push_events`
  - `tag_push_events`
  - `releases_events`

**Example Usage:**

```bash
curl --request POST --header "PRIVATE-TOKEN: <your_access_token>" \
     "https://gitlab.example.com/api/v4/projects/1/hooks/1/test/push_events"
```

**Rate Limits (GitLab 17.0+):**
This endpoint has specific rate limits:

- **GitLab 17.0**: 3 requests per minute per project webhook.
- **GitLab 17.1+**: 5 requests per minute per project and authenticated user.
- _Note_: On Self-Managed instances, administrators can disable this via the `web_hook_test_api_endpoint_rate_limit` feature flag.

**Example Response:**

```json
{
  "message": "201 Created"
}
```

## Summary Checklist

- **Editing `Database`?** -> Go to `Framework/src/Database`. Push to `Framework`. Wait for Split.
- **Editing `SDUI`?** -> Go to `SDUI`. Push to `SDUI`. Done.
- **Editing `Debugbar`?** -> Go to `Telemetry/src/Debugbar`. Push to `Telemetry`. Wait for Split.
