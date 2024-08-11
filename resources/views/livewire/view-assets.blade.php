<div>
    @foreach($assets as $asset)
        <div wire:key="$asset->id"
             class="grid grid-cols-2 w-full border border-black border-t-0 first:border-t ">
            <div class="p-2 border-r-black border-r">
                <p> {{ $asset->name }} </p>
            </div>
            <div class="p-2">
                <p>{{$asset->value}}</p>
            </div>
        </div>
    @endforeach
</div>
