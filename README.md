# Pixielity Framework

[![CI](https://github.com/pixielity/framework/workflows/CI/badge.svg)](https://github.com/pixielity/framework/actions)
[![codecov](https://codecov.io/gh/pixielity/framework/branch/main/graph/badge.svg)](https://codecov.io/gh/pixielity/framework)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PHP Version](https://img.shields.io/badge/php-%5E8.3%20%7C%20%5E8.4%20%7C%20%5E8.5-blue)](https://php.net)

Enterprise-ready PHP framework with monorepo architecture, designed for scalability, maintainability, and modern development practices.

## Features

- **Monorepo Architecture**: Manage multiple packages in a single repository
- **PSR Compliant**: Follows PSR-7, PSR-11, PSR-15 standards
- **Type Safe**: Full PHP 8.3+ type declarations
- **Production Ready**: Comprehensive testing, linting, and quality tools
- **Developer Experience**: Modern tooling with Composer scripts and Makefile

## Requirements

- PHP 8.3, 8.4, or 8.5
- Composer 2.0+
- Node.js 18+ (for formatting tools)

## Installation

```bash
# Clone the repository
git clone https://github.com/pixielity/framework.git
cd framework

# Install dependencies
composer install

# Or use Make
make install
```

## Quick Start

```bash
# Run tests
composer test

# Run static analysis
composer analyse

# Format code
composer format

# Run full CI suite
make ci
```

## Project Structure

```
.
├── src/
│   ├── Contracts/          # Framework contracts/interfaces
│   ├── Exceptions/         # Exception classes
│   ├── Foundation/         # Core framework classes
│   ├── PackageA/           # Example package A
│   └── PackageB/           # Example package B
├── playground/             # Development playground
├── tests/                  # Framework tests
│   ├── Unit/
│   ├── Integration/
│   └── Feature/
├── config/                 # Configuration files
└── var/                    # Cache and logs
```

## Available Commands

### Composer Scripts

```bash
# Testing
composer test                    # Run all tests
composer test:unit              # Run unit tests only
composer test:integration       # Run integration tests only
composer test:coverage          # Run tests with coverage report

# Code Quality
composer analyse                # Run PHPStan static analysis
composer analyse:baseline       # Generate PHPStan baseline
composer format                 # Format code with Pint
composer format:check           # Check code formatting
composer cs:check               # Check code style with PHP_CodeSniffer
composer cs:fix                 # Fix code style issues

# Refactoring
composer rector                 # Preview Rector changes (dry-run)
composer rector:fix             # Apply Rector changes

# Security & Quality
composer audit                  # Check for security vulnerabilities
composer mutate                 # Run mutation testing
composer validate               # Validate composer.json

# CI
composer ci                     # Run CI checks (format, analyse, test)
composer ci:full                # Run full CI suite with mutation testing
```

### Make Commands

```bash
make help                       # Show all available commands
make install                    # Install dependencies
make test                       # Run tests
make analyse                    # Run static analysis
make format                     # Format code
make ci                         # Run CI suite
make clean                      # Clean cache and artifacts
```

## Development Workflow

### 1. Code Changes

```bash
# Make your changes
vim src/Foundation/Application.php

# Format code
composer format

# Run tests
composer test
```

### 2. Quality Checks

```bash
# Static analysis
composer analyse

# Code style check
composer format:check

# Refactoring suggestions
composer rector
```

### 3. Before Commit

```bash
# Run full CI suite
make ci

# Or with mutation testing
make ci-full
```

## Testing

### Running Tests

```bash
# All tests
composer test

# Specific test suite
composer test:unit
composer test:integration

# With coverage
composer test:coverage
```

### Writing Tests

Tests are organized by type:

- **Unit Tests**: `tests/Unit/` - Test individual classes in isolation
- **Integration Tests**: `tests/Integration/` - Test component interactions
- **Feature Tests**: `tests/Feature/` - Test complete features

Example unit test:

```php
<?php

namespace Pixielity\Tests\Unit;

use PHPUnit\Framework\TestCase;
use Pixielity\Foundation\Application;

class ApplicationTest extends TestCase
{
    public function test_application_can_be_instantiated(): void
    {
        $app = new Application();
        
        $this->assertInstanceOf(Application::class, $app);
    }
}
```

## Code Quality Tools

### PHPStan (Static Analysis)

```bash
# Run analysis
composer analyse

# Generate baseline for existing errors
composer analyse:baseline
```

Configuration: `phpstan.neon`

### Laravel Pint (Code Formatting)

```bash
# Format code
composer format

# Check formatting
composer format:check
```

Configuration: `pint.json`

### Rector (Automated Refactoring)

```bash
# Preview changes
composer rector

# Apply changes
composer rector:fix
```

Configuration: `rector.php`

### Infection (Mutation Testing)

```bash
# Run mutation tests
composer mutate
```

Configuration: `infection.json`

## Packages

### PackageA

Core service functionality.

**Location**: `src/PackageA/`

**Installation**: `composer require pixielity/package-a`

### PackageB

Extended functionality module.

**Location**: `src/PackageB/`

**Installation**: `composer require pixielity/package-b`

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Security

If you discover any security-related issues, please email team@pixielity.com instead of using the issue tracker.

See [SECURITY.md](SECURITY.md) for more information.

## License

The Pixielity Framework is open-sourced software licensed under the [MIT license](LICENSE).

## Credits

- [Pixielity Team](https://pixielity.com)
- [All Contributors](https://github.com/pixielity/framework/contributors)

## Support

- [Documentation](https://docs.pixielity.com)
- [Issue Tracker](https://github.com/pixielity/framework/issues)
- [Discussions](https://github.com/pixielity/framework/discussions)
