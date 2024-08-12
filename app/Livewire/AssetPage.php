<?php

namespace App\Livewire;

use Cache;
use Illuminate\Contracts\View\Factory;
use Illuminate\Foundation\Application;
use Illuminate\View\View;
use Livewire\Component;
use Log;
use Psr\SimpleCache\InvalidArgumentException;

class AssetPage extends Component
{
    public function render(): Application|Factory|\Illuminate\Contracts\View\View|View
    {
        return view('livewire.pages.asset-page');
    }

    public function mount(): void
    {
        Cache::put('memcached_test', 'available');
        try {
            $value = Cache::get('my value') ?? "no value";
            Log::info('Memcached value: ' . $value);
        } catch (InvalidArgumentException $e) {
            Log::error('memcache not available');
        }
    }

}
