# Quick Reference Guide

## 🚀 Common Commands

### Testing
```bash
composer test                    # Run all tests
composer test:unit              # Unit tests only
composer test:integration       # Integration tests only
composer test:coverage          # Tests with HTML coverage
make test                       # Run all tests (Make)
```

### Code Quality
```bash
composer analyse                # Run PHPStan
composer format                 # Format code with Pint
composer format:check           # Check formatting
composer rector                 # Preview refactoring
composer rector:fix             # Apply refactoring
make analyse                    # Run PHPStan (Make)
make format                     # Format code (Make)
```

### CI/CD
```bash
composer ci                     # Quick CI (format, analyse, test)
composer ci:full                # Full CI with mutation testing
make ci                         # Quick CI (Make)
make ci-full                    # Full CI (Make)
```

### Maintenance
```bash
composer audit                  # Security audit
composer validate               # Validate composer.json
composer dump                   # Dump optimized autoloader
make clean                      # Clean cache/logs
make clean-all                  # Clean everything including vendor
```

## 📁 File Locations

### Configuration
- `composer.json` - Root package configuration
- `phpunit.xml` - PHPUnit configuration
- `phpstan.neon` - PHPStan configuration
- `pint.json` - Laravel Pint configuration
- `phpcs.xml` - PHP_CodeSniffer configuration
- `rector.php` - Rector configuration
- `infection.json` - Mutation testing configuration

### Source Code
- `src/Contracts/` - Framework interfaces
- `src/Exceptions/` - Exception classes
- `src/Foundation/` - Core framework
- `src/PackageA/` - Package A
- `src/PackageB/` - Package B
- `playground/` - Development playground

### Tests
- `tests/Unit/` - Unit tests
- `tests/Integration/` - Integration tests
- `tests/Feature/` - Feature tests
- `src/*/tests/` - Package tests

### Documentation
- `README.md` - Main documentation
- `docs/DEVELOPMENT.md` - Development guide
- `docs/SETUP_SUMMARY.md` - Setup summary
- `CHANGELOG.md` - Version history
- `PRODUCTION_CHECKLIST.md` - Production checklist

### Build Artifacts
- `var/cache/` - Cache files
- `var/log/` - Log files
- `coverage/` - Coverage reports
- `.phpunit.cache/` - PHPUnit cache

## 🔧 Tool Versions

- PHP: ^8.3 || ^8.4 || ^8.5
- PHPUnit: ^11.5
- PHPStan: ^2.0
- Larastan: ^3.0
- Laravel Pint: ^1.24
- Rector: ^2.3
- Infection: ^0.29

## 📊 Quality Targets

- **Code Coverage**: 80%+
- **Mutation Score**: 80% MSI, 90% covered MSI
- **PHPStan Level**: 8
- **Code Style**: PSR-12 + Laravel

## 🎯 Workflow

### 1. Development
```bash
# Make changes
vim src/Foundation/Application.php

# Format code
composer format

# Run tests
composer test
```

### 2. Quality Check
```bash
# Static analysis
composer analyse

# Check formatting
composer format:check

# Preview refactoring
composer rector
```

### 3. Before Commit
```bash
# Run CI
make ci

# Or full suite
make ci-full
```

### 4. Commit
```bash
git add .
git commit -m "feat: add new feature"
git push
```

## 📦 Package Management

### Add New Package
```bash
# Create directory
mkdir -p src/PackageC/{src,tests}

# Create composer.json
# Add to root composer.json repositories
# Add to root composer.json replace

# Install
composer require pixielity/package-c:@dev
```

### Update Dependencies
```bash
composer update
composer update --with-all-dependencies
```

## 🐛 Troubleshooting

### Clear Caches
```bash
make clean
composer clear-cache
rm -rf .phpunit.cache
```

### Reinstall Dependencies
```bash
rm -rf vendor composer.lock
composer install
```

### Fix Permissions
```bash
chmod -R 755 var/
chmod -R 755 coverage/
```

## 📝 Git Commit Types

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Code style
- `refactor:` Refactoring
- `test:` Tests
- `chore:` Build/tools

## 🔗 Useful Links

- [PHP Documentation](https://www.php.net/docs.php)
- [PHPUnit](https://phpunit.de/documentation.html)
- [PHPStan](https://phpstan.org/user-guide/getting-started)
- [Laravel Pint](https://laravel.com/docs/pint)
- [Rector](https://getrector.com/documentation)
- [Infection](https://infection.github.io/guide/)

## 💡 Tips

- Use `make help` to see all Make commands
- Use `composer list` to see all Composer scripts
- Run `composer ci` before committing
- Keep tests fast (mock external dependencies)
- Write descriptive commit messages
- Update CHANGELOG.md for notable changes

---

**Quick Start**: `make install && make test && make ci`
