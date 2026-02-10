<?php

/**
 * Rector Configuration - Production Ready.
 *
 * Automated refactoring and code modernization for the Pixielity Framework.
 * This configuration is optimized for production use with comprehensive
 * rule sets and proper exclusions.
 *
 * @see https://github.com/rectorphp/rector
 * @see https://getrector.com/documentation
 *
 * Usage:
 *   Preview changes:  composer rector
 *   Apply changes:    composer rector:fix
 *   Specific path:    vendor/bin/rector process src/PackageA --dry-run
 *
 * @version 2.0.0
 *
 * @author Pixielity Development Team
 */

declare(strict_types=1);

use Rector\CodingStyle\Rector\Encapsed\EncapsedStringsToSprintfRector;
use Rector\CodingStyle\Rector\Stmt\NewlineAfterStatementRector;
use Rector\Config\RectorConfig;
use Rector\DeadCode\Rector\ClassMethod\RemoveUnusedPrivateMethodRector;
use Rector\DeadCode\Rector\Property\RemoveUnusedPrivatePropertyRector;
use Rector\Php81\Rector\Property\ReadOnlyPropertyRector;
use Rector\Privatization\Rector\ClassMethod\PrivatizeFinalClassMethodRector;
use Rector\Set\ValueObject\SetList;
use Rector\TypeDeclaration\Rector\ClassMethod\AddVoidReturnTypeWhereNoReturnRector;
use Rector\TypeDeclaration\Rector\ClassMethod\ParamTypeByMethodCallTypeRector;
use RectorLaravel\Set\LaravelSetList;
use RectorLaravel\Set\Packages\Faker\FakerSetList;
use RectorLaravel\Set\Packages\Livewire\LivewireSetList;

return RectorConfig::configure()
    // =========================================================================
    // PATHS CONFIGURATION
    // =========================================================================
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/playground',
    ])
    // =========================================================================
    // CACHE CONFIGURATION
    // =========================================================================
    ->withCache(__DIR__ . '/build/rector')
    // =========================================================================
    // SKIP CONFIGURATION
    // =========================================================================
    ->withSkip([
        // =====================================================================
        // PATHS TO SKIP
        // =====================================================================
        // Third-party dependencies
        '*/vendor/*',
        __DIR__ . '/vendor',
        // Storage and cache
        '*/storage/*',
        '*/cache/*',
        '*/bootstrap/cache/*',
        // Build artifacts
        '*/build/*',
        '*/dist/*',
        '*/var/*',
        // Test fixtures (intentionally old code)
        '*/tests/Fixtures/*',
        '*/tests/fixtures/*',
        '*/tests/Stubs/*',
        '*/tests/stubs/*',
        // Generated files
        '*/_ide_helper.php',
        '*/_ide_helper_models.php',
        '*/ide-helper.php',
        // =====================================================================
        // RULES TO SKIP
        // =====================================================================
        // Don't convert string interpolation to sprintf (Laravel convention)
        EncapsedStringsToSprintfRector::class,
        // Don't force newlines after statements (formatting handled by Pint)
        NewlineAfterStatementRector::class,
        // =====================================================================
        // RULES TO SKIP FOR SPECIFIC PATHS
        // =====================================================================
        // Don't make properties readonly in DTOs (they need to be mutable)
        ReadOnlyPropertyRector::class => [
            '*/Data/*',
            '*/DTO/*',
            '*/Dtos/*',
            '*/DataTransferObjects/*',
        ],
        // Don't remove "unused" properties in Models (they're for frameworks)
        RemoveUnusedPrivatePropertyRector::class => [
            '*/Models/*',
        ],
        // Don't remove "unused" methods in Observers (lifecycle hooks)
        RemoveUnusedPrivateMethodRector::class => [
            '*/Observers/*',
        ],
        // Don't add void return types to magic methods
        AddVoidReturnTypeWhereNoReturnRector::class => [
            '*/Concerns/*',
        ],
        // Don't add parameter types to __call magic method
        ParamTypeByMethodCallTypeRector::class => [
            '*/Concerns/*',
            '*/Traits/*',
        ],
        // Don't privatize trait methods
        PrivatizeFinalClassMethodRector::class => [
            '*/Traits/*',
        ],
    ])
    // =========================================================================
    // PHP VERSION TARGET
    // =========================================================================
    ->withPhpSets(
        php84: true  // Target PHP 8.4 features
    )
    // =========================================================================
    // RULE SETS - COMPREHENSIVE PRODUCTION CONFIGURATION
    // =========================================================================
    ->withSets([
        // =====================================================================
        // CODE QUALITY IMPROVEMENTS
        // =====================================================================

        /*
         * Dead Code Removal
         *
         * Removes code that has no effect:
         * - Unused private methods and properties
         * - Unused imports and variables
         * - Unreachable code after return/throw
         * - Empty methods and blocks
         * - Unused parameters
         * - Dead conditions
         */
        SetList::DEAD_CODE,

        /*
         * Code Quality Improvements
         *
         * Improves code quality and readability:
         * - Simplify boolean expressions
         * - Use null coalescing operator
         * - Combine consecutive assignments
         * - Simplify array functions
         * - Inline single-use variables
         * - Remove unnecessary parentheses
         * - Simplify ternary operators
         * - Use spaceship operator
         */
        SetList::CODE_QUALITY,

        /*
         * Coding Style Consistency
         *
         * Applies consistent coding style:
         * - Short array syntax []
         * - Consistent string quotes
         * - Consistent null comparison
         * - Consistent boolean naming
         * - Remove unnecessary semicolons
         * - Consistent use of strict comparison
         */
        SetList::CODING_STYLE,

        /*
         * Early Return Pattern
         *
         * Refactors nested conditions to use early returns:
         * - Reduces nesting levels
         * - Improves readability
         * - Makes code flow clearer
         * - Reduces cognitive complexity
         */
        SetList::EARLY_RETURN,

        /*
         * Privatization
         *
         * Makes class members as private as possible:
         * - Changes public to protected if only used in class
         * - Changes protected to private if only used in class
         * - Makes methods final if not overridden
         * - Reduces public API surface
         */
        SetList::PRIVATIZATION,

        /*
         * Type Declarations
         *
         * Adds missing type declarations:
         * - Parameter types
         * - Return types
         * - Property types
         * - Void return types
         * - Mixed types where needed
         * - Union and intersection types
         */
        SetList::TYPE_DECLARATION,

        /*
         * Naming Conventions
         *
         * Improves naming conventions:
         * - Descriptive variable names
         * - Boolean method names (is*, has*, should*)
         * - Getter/setter standardization
         * - Remove Hungarian notation
         */
        SetList::NAMING,

        /*
         * Instanceof Checks
         *
         * Optimizes instanceof checks:
         * - Removes redundant instanceof checks
         * - Simplifies type checking logic
         * - Improves performance
         */
        SetList::INSTANCEOF,
        // =====================================================================
        // LARAVEL-SPECIFIC RULES
        // =====================================================================

        /*
         * Laravel 11 Upgrades
         *
         * Modernizes Laravel code to version 11:
         * - Updates deprecated methods
         * - Modernizes facades usage
         * - Updates helper functions
         * - Converts to new conventions
         */
        LaravelSetList::LARAVEL_110,

        /*
         * Laravel Code Quality
         *
         * Improves Laravel-specific code quality:
         * - Simplifies array helpers
         * - Optimizes collection usage
         * - Improves query builder usage
         * - Standardizes helper functions
         */
        LaravelSetList::LARAVEL_CODE_QUALITY,

        /*
         * Laravel Array Strings
         *
         * Converts string-based array access to proper methods:
         * - array_get() to Arr::get()
         * - array_set() to Arr::set()
         * - array_has() to Arr::has()
         * - str_* to Str::*
         */
        LaravelSetList::LARAVEL_ARRAY_STR_FUNCTION_TO_STATIC_CALL,

        /*
         * Laravel Eloquent Magic Method
         *
         * Converts magic methods to explicit methods:
         * - Dynamic where methods to explicit where
         * - Improves IDE support
         * - Better static analysis
         */
        LaravelSetList::LARAVEL_ELOQUENT_MAGIC_METHOD_TO_QUERY_BUILDER,

        /*
         * Laravel Facade
         *
         * Optimizes facade usage:
         * - Converts to proper facade calls
         * - Improves performance
         * - Better type hints
         */
        LaravelSetList::LARAVEL_FACADE_ALIASES_TO_FULL_NAMES,

        /*
         * Laravel Legacy
         *
         * Removes legacy Laravel patterns:
         * - Old helper functions
         * - Deprecated methods
         * - Legacy conventions
         */
        LaravelSetList::LARAVEL_LEGACY_FACTORIES_TO_CLASSES,

        /*
         * Laravel Container String
         *
         * Converts string-based container calls to class constants:
         * - app('service') to app(Service::class)
         * - Improves refactoring safety
         * - Better IDE support
         */
        LaravelSetList::LARAVEL_CONTAINER_STRING_TO_FULLY_QUALIFIED_NAME,

        /*
         * Laravel If Helpers
         *
         * Modernizes conditional helpers:
         * - optional() to ?->
         * - when() to match expressions
         * - unless() to proper conditionals
         */
        LaravelSetList::LARAVEL_IF_HELPERS,
        // =====================================================================
        // LARAVEL PACKAGE-SPECIFIC RULES
        // =====================================================================

        /*
         * Faker Modernization
         *
         * Updates Faker usage to modern syntax:
         * - Converts deprecated Faker methods
         * - Updates to Faker v2+ syntax
         * - Improves type safety
         */
        FakerSetList::FAKER_10,

        /*
         * Livewire v3 Upgrades
         *
         * Modernizes Livewire components to v3:
         * - Updates component syntax
         * - Converts lifecycle hooks
         * - Updates property binding
         * - Modernizes event handling
         */
        LivewireSetList::LIVEWIRE_30,
    ])
    // =========================================================================
    // IMPORT NAMES CONFIGURATION
    // =========================================================================
    ->withImportNames(
        importNames: true,  // Add use statements
        importDocBlockNames: true,  // Import in PHPDoc
        importShortClasses: false,  // Don't import short names (App, User, etc.)
        removeUnusedImports: true,  // Remove unused imports
    )
    // =========================================================================
    // PARALLEL PROCESSING - OPTIMIZED FOR PRODUCTION
    // =========================================================================
    ->withParallel(
        timeoutSeconds: 300,  // 5 minutes timeout (increased for large codebases)
        maxNumberOfProcess: 8,  // 8 parallel processes (balanced for stability)
        jobSize: 15,  // 15 files per job (optimized for balance)
    )
    // =========================================================================
    // ADDITIONAL CONFIGURATION
    // =========================================================================
    /*
     * Cache Directory
     *
     * Rector uses cache to speed up subsequent runs.
     * Cache is stored in /tmp by default.
     */
    ->withCache(
        cacheDirectory: __DIR__ . '/var/cache/rector',
    )
    /*
     * File Extensions
     *
     * Process only PHP files.
     */
    ->withFileExtensions(['php'])
    /*
     * Root Files
     *
     * Include root-level PHP files.
     */
    ->withRootFiles()
    /*
     * Memory Limit
     *
     * Increase memory limit for large codebases.
     */
    ->withMemoryLimit('2G');
