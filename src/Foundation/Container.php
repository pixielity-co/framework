<?php

declare(strict_types=1);

/**
 * Pixielity Framework
 *
 * @link https://pixielity.com
 * @copyright Copyright (c) 2026 Pixielity Team
 * @license https://opensource.org/licenses/MIT MIT License
 */

namespace Pixielity\Foundation;

use Pixielity\Contracts\Container as ContainerContract;
use Pixielity\Exceptions\RuntimeException;
use Closure;
use ReflectionClass;
use ReflectionParameter;

/**
 * Class Container
 *
 * A lightweight, high-performance Dependency Injection Container.
 * This is the "brain" of the Pixielity Framework, managing object instantiation 
 * and dependency resolution.
 *
 * @package Pixielity\Foundation
 */
class Container implements ContainerContract
{
    /**
     * The container's shared instances (singletons).
     *
     * @var array<string, mixed>
     */
    protected array $instances = [];

    /**
     * The container's bindings.
     *
     * @var array<string, array{concrete: mixed, shared: bool}>
     */
    protected array $bindings = [];

    /**
     * Register a binding with the container.
     */
    public function bind(string $abstract, mixed $concrete = null, bool $shared = false): void
    {
        if (is_null($concrete)) {
            $concrete = $abstract;
        }

        $this->bindings[$abstract] = compact('concrete', 'shared');
    }

    /**
     * Register a shared binding in the container.
     */
    public function singleton(string $abstract, mixed $concrete = null): void
    {
        $this->bind($abstract, $concrete, true);
    }

    /**
     * Resolve the given type from the container.
     */
    public function make(string $abstract): mixed
    {
        // If it's a singleton and already resolved, return it
        if (isset($this->instances[$abstract])) {
            return $this->instances[$abstract];
        }

        $concrete = $this->getConcrete($abstract);

        // Build the object
        if ($this->isBuildable($concrete, $abstract)) {
            $object = $this->build($concrete);
        } else {
            $object = $this->make($concrete);
        }

        // Store if shared
        if ($this->isShared($abstract)) {
            $this->instances[$abstract] = $object;
        }

        return $object;
    }

    /**
     * Check if a type is registered in the container.
     */
    public function has(string $id): bool
    {
        return isset($this->bindings[$id]) || isset($this->instances[$id]);
    }

    /**
     * Get the resolved value for a given identifier.
     */
    public function get(string $id): mixed
    {
        if (!$this->has($id)) {
            throw new RuntimeException("Target [{$id}] is not binding in container.");
        }

        return $this->make($id);
    }

    /**
     * Instantiate a concrete instance of the given type.
     */
    protected function build(mixed $concrete): mixed
    {
        if ($concrete instanceof Closure) {
            return $concrete($this);
        }

        $reflector = new ReflectionClass($concrete);

        if (!$reflector->isInstantiable()) {
            throw new RuntimeException("Target [{$concrete}] is not instantiable.");
        }

        $constructor = $reflector->getConstructor();

        if (is_null($constructor)) {
            return new $concrete;
        }

        $parameters = $constructor->getParameters();
        $instances = $this->resolveDependencies($parameters);

        return $reflector->newInstanceArgs($instances);
    }

    /**
     * Resolve all dependencies from the reflection parameters.
     * 
     * @param ReflectionParameter[] $parameters
     * @return array<int, mixed>
     */
    protected function resolveDependencies(array $parameters): array
    {
        $dependencies = [];

        foreach ($parameters as $parameter) {
            $type = $parameter->getType();
            
            if ($type && !$type->isBuiltin()) {
                $dependencies[] = $this->make($parameter->getType()->getName());
            } elseif ($parameter->isDefaultValueAvailable()) {
                $dependencies[] = $parameter->getDefaultValue();
            } else {
                throw new RuntimeException("Unresolvable dependency [{$parameter}] in class {$parameter->getDeclaringClass()->getName()}");
            }
        }

        return $dependencies;
    }

    protected function getConcrete(string $abstract): mixed
    {
        return $this->bindings[$abstract]['concrete'] ?? $abstract;
    }

    protected function isBuildable(mixed $concrete, string $abstract): bool
    {
        return $concrete === $abstract || $concrete instanceof Closure;
    }

    protected function isShared(string $abstract): bool
    {
        return isset($this->instances[$abstract]) || ($this->bindings[$abstract]['shared'] ?? false);
    }
}
