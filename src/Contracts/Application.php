<?php

declare(strict_types=1);

/**
 * Pixielity Framework
 *
 * @link https://pixielity.com
 * @copyright Copyright (c) 2026 Pixielity Team
 * @license https://opensource.org/licenses/MIT MIT License
 */

namespace Pixielity\Contracts;

/**
 * Interface Application
 *
 * The foundational contract for all Pixielity Framework applications.
 * This ensures that any implementation of the framework adheres to the core lifecycle.
 *
 * @package Pixielity\Contracts
 * @author Pixielity Team <team@pixielity.com>
 */
interface Application
{
    /**
     * Boot the application services and providers.
     *
     * @return void
     * @throws \Pixielity\Exceptions\RuntimeException If the application fails to boot.
     */
    public function boot(): void;

    /**
     * Get the framework version.
     *
     * @return string
     */
    public function version(): string;
}
