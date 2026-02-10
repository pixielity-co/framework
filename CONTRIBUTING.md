# Contributing to Pixielity Framework

Thank you for your interest in contributing to the Pixielity Framework! As an enterprise-grade project, we maintain high standards for code quality and documentation.

## Code of Conduct

Please be respectful and professional in all interactions. We follow the standard Contributor Covenant.

## Development Process

1.  **Fork the Repository**: Create your own fork of the monorepo.
2.  **Strict Typing**: Every PHP file MUST include `declare(strict_types=1);`.
3.  **Docblocks**: All classes, methods, and properties MUST have comprehensive docblocks.
4.  **Testing**: New features MUST include unit tests with 100% coverage for the new logic.
5.  **Static Analysis**: Your code MUST pass PHPStan Level 9 analysis.
    ```bash
    composer analyse
    ```
6.  **Code Style**: We use Laravel Pint for styling.
    ```bash
    composer lint
    ```

## Branching Strategy

- `main`: Production-ready code.
- `develop`: Integration branch for new features.
- `feature/*`: Individual feature branches.

## Pull Request Guidelines

- Provide a clear description of the changes.
- Link any related issues.
- Ensure all CI/CD stages pass.

## Security

If you discover a security vulnerability, please do NOT open a public issue. Instead, email security@pixielity.com.
