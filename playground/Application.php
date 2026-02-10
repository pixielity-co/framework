<?php

declare(strict_types=1);

/**
 * Pixielity Framework Playground
 */

namespace Pixielity\Playground;

use Pixielity\Foundation\Application as BaseApplication;

/**
 * Class Application
 *
 * This class extends the core Pixielity Foundation to allow for custom 
 * experimentation and testing within the playground environment.
 */
class Application extends BaseApplication
{
    /**
     * Override boot to add playground-specific logging.
     */
    public function boot(): void
    {
        parent::boot();
        
        echo "Pixielity Enterprise Application [v{$this->version()}] Booted from Playground!\n";
    }
}
