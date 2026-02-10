# Pixielity Foundation

Core application and container implementation for the Pixielity Framework.

## Installation

```bash
composer require pixielity/foundation
```

## Description

The Foundation package provides the core building blocks of the Pixielity Framework:

- Application bootstrap and lifecycle
- Dependency injection container
- Service provider registration
- Configuration management

## Usage

```php
<?php

use Pixielity\Foundation\Application;

// Create and bootstrap application
$app = new Application();
$app->boot();

// Use the container
$app->bind('service', fn() => new Service());
$service = $app->get('service');
```

## License

MIT License. See [LICENSE](LICENSE) for details.
