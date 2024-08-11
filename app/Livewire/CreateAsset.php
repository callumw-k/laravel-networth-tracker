<?php

namespace App\Livewire;

use App\Models\Asset;
use Illuminate\Contracts\View\Factory;
use Illuminate\Foundation\Application;
use Illuminate\View\View;
use Livewire\Component;

class CreateAsset extends Component
{

    public $assetName;
    public $assetValue;

    public function createAsset(): void
    {
        $asset = Asset::create([
            'name' => $this->pull('assetName'),
            'value' => $this->pull('assetValue'),
        ]);
        $asset->save();
        $this->dispatch('asset-created', $asset)->to(ViewAssets::class);
    }

    public function render(): Application|Factory|\Illuminate\Contracts\View\View|View
    {
        return view('livewire.create-asset');
    }
}
