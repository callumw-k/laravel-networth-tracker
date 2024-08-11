<?php

namespace App\Livewire;

use App\Models\Asset;
use Illuminate\Contracts\View\Factory;
use Illuminate\Foundation\Application;
use Illuminate\View\View;
use Livewire\Component;

class ViewAssets extends Component
{

    protected $listeners = ['asset-created' => '$refresh'];


    public function render(): Application|Factory|\Illuminate\Contracts\View\View|View
    {
        return view('livewire.view-assets', [
            'assets' => Asset::all()
        ]);
    }

}
