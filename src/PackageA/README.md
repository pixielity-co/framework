# Pixielity Package A

Core service functionality for the Pixielity Framework.

## Installation

```bash
composer require pixielity/package-a
```

## Usage

```php
<?php

use Pixielity\PackageA\Service;

$service = new Service();
$result = $service->execute();
```

## Testing

```bash
# Run package tests
composer test

# From root
vendor/bin/phpunit src/PackageA/tests
```

## License

MIT License. See [LICENSE](LICENSE) for details.
