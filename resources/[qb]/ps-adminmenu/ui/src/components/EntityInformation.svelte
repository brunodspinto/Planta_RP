<script>
    import { ENTITY_INFO } from "@store/entityInfo"
	import { fly } from "svelte/transition"
</script>

<div class="w-screen h-screen flex items-center">
    <div class="w-[25vh] bg-primary flex flex-col gap-[2vh] rounded-[0.5vh] p-[2vh] ml-[2vh] font-medium" transition:fly={{ x: -100 }}>
        <div class="h-[2vh] w-full flex items-center gap-[1vh] text-[1.5vh]">
            <i class="fas fa-code"></i>
            <p>Informação da entidade</p>
        </div>
        <div>
            <p>Modelo: {$ENTITY_INFO?.name}</p>
            <p>Hash: {$ENTITY_INFO?.hash}</p>
            <br>
            <p>C - Copiar informação</p>
            <p>E - Apagar entidade</p>
            <p>ESC - Fechar</p>
        </div>
    </div>
</div>