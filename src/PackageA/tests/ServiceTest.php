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

namespace Pixielity\PackageA\Tests;

use PHPUnit\Framework\TestCase;
use Pixielity\PackageA\Service;

/**
 * Class ServiceTest.
 *
 * Tests for the enterprise-grade PackageA Service component.
 */
class ServiceTest extends TestCase
{
    /** @test */
    public function it_can_execute_enterprise_action(): void
    {
        $service = new Service();
        $this->assertEquals('PackageA Enterprise Action Executed', $service->execute());
    }
}
