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

use Psr\Container\ContainerInterface;

/**
 * Interface Container
 *
 * The core Dependency Injection Container contract for the Pixielity Framework.
 * Inspired by Laravel's Illuminate\Contracts\Container.
 *
 * @package Pixielity\Contracts
 */
interface Container extends ContainerInterface
{
    /**
     * Register a binding with the container.
     *
     * @param string $abstract
     * @param mixed $concrete
     * @param bool $shared
     * @return void
     */
    public function bind(string $abstract, mixed $concrete = null, bool $shared = false): void;

    /**
     * Register a shared binding in the container (Singleton).
     *
     * @param string $abstract
     * @param mixed $concrete
     * @return void
     */
    public function singleton(string $abstract, mixed $concrete = null): void;

    /**
     * Resolve the given type from the container.
     *
     * @param string $abstract
     * @return mixed
     */
    public function make(string $abstract): mixed;
}
