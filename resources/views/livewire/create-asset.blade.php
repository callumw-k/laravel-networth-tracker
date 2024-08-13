<div>
    <form wire:submit="createAsset">
        <div class="grid grid-cols-[2fr,1fr,40px] border border-black border-t-0 ">
            <input wire:model="assetName" class="border-r border-r-black p-2 min-w-0" placeholder="Asset name">
            <input wire:model="assetValue" class="px-2 w-auto min-w-0" placeholder="Value">
            <div class="px-2 flex justify-center border-l-black border-l">
                <button type="submit">
                    <x-heroicon-c-plus class="size-6"/>
                </button>
            </div>
        </div>
    </form>
</div>
