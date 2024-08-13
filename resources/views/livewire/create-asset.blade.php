<div>
    <form wire:submit="createAsset">
        <div class="grid grid-cols-3 border border-black border-t-0 ">
            <input wire:model="assetName" class="border-r border-r-black p-2" placeholder="Asset name">
            <input wire:model="assetValue" class="p-2" type="number" placeholder="value">
            <button type="submit"></button>
        </div>
    </form>
</div>
