# Development Guide

This guide covers the development workflow, tools, and best practices for the Pixielity Framework.

## Table of Contents

- [Setup](#setup)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Code Quality](#code-quality)
- [Package Development](#package-development)
- [CI/CD](#cicd)

## Setup

### Prerequisites

- PHP 8.3, 8.4, or 8.5
- Composer 2.0+
- Node.js 18+ (optional, for formatting)
- Make (optional, for convenience commands)

### Installation

```bash
# Clone repository
git clone https://github.com/pixielity/framework.git
cd framework

# Install dependencies
composer install

# Or use Make
make install
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/my-new-feature
```

### 2. Make Changes

Edit files in `src/`, `playground/`, or package directories.

### 3. Format Code

```bash
# Auto-format
composer format

# Or check formatting
composer format:check
```

### 4. Run Tests

```bash
# All tests
composer test

# Specific suite
composer test:unit
composer test:integration
```

### 5. Static Analysis

```bash
# Run PHPStan
composer analyse

# Check for refactoring opportunities
composer rector
```

### 6. Commit Changes

```bash
git add .
git commit -m "feat: add new feature"
```

### 7. Push and Create PR

```bash
git push origin feature/my-new-feature
```

## Testing

### Test Structure

```
tests/
├── Unit/           # Unit tests (isolated classes)
├── Integration/    # Integration tests (component interactions)
└── Feature/        # Feature tests (complete features)
```

### Writing Tests

#### Unit Test Example

```php
<?php

namespace Pixielity\Tests\Unit;

use PHPUnit\Framework\TestCase;
use Pixielity\Foundation\Container;

class ContainerTest extends TestCase
{
    private Container $container;

    protected function setUp(): void
    {
        $this->container = new Container();
    }

    public function test_can_bind_and_resolve(): void
    {
        $this->container->bind('key', fn() => 'value');
        
        $this->assertSame('value', $this->container->get('key'));
    }
}
```

#### Integration Test Example

```php
<?php

namespace Pixielity\Tests\Integration;

use PHPUnit\Framework\TestCase;
use Pixielity\Foundation\Application;

class ApplicationIntegrationTest extends TestCase
{
    public function test_application_boots_with_container(): void
    {
        $app = new Application();
        $app->boot();
        
        $this->assertTrue($app->isBooted());
        $this->assertInstanceOf(Container::class, $app->getContainer());
    }
}
```

### Running Tests

```bash
# All tests
composer test

# Unit tests only
composer test:unit

# Integration tests only
composer test:integration

# With coverage
composer test:coverage

# Specific test file
vendor/bin/phpunit tests/Unit/ContainerTest.php

# Specific test method
vendor/bin/phpunit --filter test_can_bind_and_resolve
```

### Test Coverage

```bash
# Generate HTML coverage report
composer test:coverage

# View report
open coverage/html/index.html
```

### Mutation Testing

```bash
# Run mutation tests
composer mutate

# View results
cat var/log/infection.log
```

## Code Quality

### PHPStan (Static Analysis)

PHPStan analyzes code for type errors and bugs without running it.

```bash
# Run analysis
composer analyse

# Generate baseline (for existing errors)
composer analyse:baseline
```

**Configuration**: `phpstan.neon`

**Level**: 8 (0-9, 9 is strictest)

### Laravel Pint (Code Formatting)

Pint formats code according to Laravel conventions.

```bash
# Format code
composer format

# Check formatting without fixing
composer format:check
```

**Configuration**: `pint.json`

**Preset**: Laravel

### Rector (Automated Refactoring)

Rector automatically refactors code to modern standards.

```bash
# Preview changes (dry-run)
composer rector

# Apply changes
composer rector:fix
```

**Configuration**: `rector.php`

**Target**: PHP 8.4

### PHP_CodeSniffer

Additional code style checking.

```bash
# Check code style
composer cs:check

# Fix code style
composer cs:fix
```

**Configuration**: `phpcs.xml`

**Standard**: PSR-12

## Package Development

### Creating a New Package

1. Create package directory:

```bash
mkdir -p src/PackageC/{src,tests}
```

2. Create `composer.json`:

```json
{
    "$schema": "https://getcomposer.org/schema.json",
    "name": "pixielity/package-c",
    "description": "Package C description",
    "type": "library",
    "license": "MIT",
    "require": {
        "php": "^8.3 || ^8.4 || ^8.5"
    },
    "autoload": {
        "psr-4": {
            "Pixielity\\PackageC\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Pixielity\\PackageC\\Tests\\": "tests/"
        }
    }
}
```

3. Add to root `composer.json`:

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "./src/PackageC",
            "options": {
                "symlink": true
            }
        }
    ],
    "replace": {
        "pixielity/package-c": "self.version"
    }
}
```

4. Install package:

```bash
composer require pixielity/package-c:@dev
```

### Package Structure

```
src/PackageC/
├── src/              # Source code
├── tests/            # Tests
│   ├── Unit/
│   └── Integration/
├── composer.json     # Package configuration
├── LICENSE           # License file
└── README.md         # Package documentation
```

## CI/CD

### GitHub Actions

The project uses GitHub Actions for CI/CD.

**Workflow**: `.github/workflows/ci.yml`

**Jobs**:
- Tests (PHP 8.3, 8.4)
- Code Quality (PHPStan, Pint, Rector)
- Security Audit
- Mutation Testing (on PRs)

### Running CI Locally

```bash
# Quick CI check
make ci

# Full CI suite
make ci-full
```

### Pre-commit Checks

Before committing, run:

```bash
# Format code
composer format

# Run tests
composer test

# Static analysis
composer analyse

# Or all at once
make ci
```

## Best Practices

### Code Style

- Follow PSR-12 coding standard
- Use strict types: `declare(strict_types=1);`
- Add type declarations for all parameters and return types
- Use readonly properties where appropriate
- Prefer composition over inheritance

### Testing

- Write tests for all new features
- Aim for 80%+ code coverage
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies

### Documentation

- Add PHPDoc blocks for public methods
- Document complex logic with inline comments
- Update README when adding features
- Keep CHANGELOG.md up to date

### Git Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test changes
- `chore:` Build/tooling changes

Examples:
```
feat: add container binding support
fix: resolve circular dependency issue
docs: update installation guide
test: add integration tests for application
```

## Troubleshooting

### Composer Issues

```bash
# Clear cache
composer clear-cache

# Reinstall dependencies
rm -rf vendor composer.lock
composer install
```

### PHPStan Issues

```bash
# Clear cache
rm -rf var/cache/phpstan

# Regenerate baseline
composer analyse:baseline
```

### Test Failures

```bash
# Clear test cache
rm -rf .phpunit.cache

# Run specific test with verbose output
vendor/bin/phpunit --verbose tests/Unit/MyTest.php
```

## Resources

- [PHP Documentation](https://www.php.net/docs.php)
- [PHPUnit Documentation](https://phpunit.de/documentation.html)
- [PHPStan Documentation](https://phpstan.org/user-guide/getting-started)
- [Laravel Pint Documentation](https://laravel.com/docs/pint)
- [Rector Documentation](https://getrector.com/documentation)
