<?php

declare(strict_types=1);

/**
 * Pixielity Framework.
 *
 * @link https://pixielity.com
 *
 * @copyright Copyright (c) 2026 Pixielity Team
 * @license https://opensource.org/licenses/MIT MIT License
 */

namespace Pixielity\Foundation;

use Pixielity\Contracts\Application as ApplicationContract;

/**
 * Class Application.
 *
 * The core implementation of the Pixielity Framework. This class manages the
 * application lifecycle, service registration, and core framework state.
 */
class Application extends Container implements ApplicationContract
{
    /**
     * The framework version.
     *
     * @var string
     */
    public const VERSION = '1.0.0-dev';

    /**
     * Indicates if the application has been booted.
     */
    protected bool $booted = false;

    /**
     * Create a new Pixielity application instance.
     */
    public function __construct()
    {
        // Initialize core framework components
    }

    /**
     * Boot the application services and providers.
     */
    public function boot(): void
    {
        if ($this->booted) {
            return;
        }

        // Execution of boot logic
        // ...

        $this->booted = true;
    }

    /**
     * Get the framework version.
     */
    public function version(): string
    {
        return static::VERSION;
    }
}
