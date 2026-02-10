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

namespace Pixielity\Contracts;

use Pixielity\Exceptions\RuntimeException;

/**
 * Interface Application.
 *
 * The foundational contract for all Pixielity Framework applications.
 * This ensures that any implementation of the framework adheres to the core lifecycle.
 *
 * @author Pixielity Team <team@pixielity.com>
 */
interface Application
{
    /**
     * Boot the application services and providers.
     *
     * @throws RuntimeException If the application fails to boot.
     */
    public function boot(): void;

    /**
     * Get the framework version.
     */
    public function version(): string;
}
