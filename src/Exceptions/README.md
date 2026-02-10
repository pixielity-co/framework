# Pixielity Exceptions

Framework exception classes for the Pixielity Framework.

## Installation

```bash
composer require pixielity/exceptions
```

## Description

This package contains all exception classes used throughout the Pixielity Framework:

- `PixielityException` - Base exception class
- `RuntimeException` - Runtime exceptions
- And more...

## Usage

```php
<?php

use Pixielity\Exceptions\RuntimeException;

throw new RuntimeException('Something went wrong');
```

## License

MIT License. See [LICENSE](LICENSE) for details.
