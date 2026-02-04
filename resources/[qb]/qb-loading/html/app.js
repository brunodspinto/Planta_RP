const { ref, onMounted } = Vue

const load = Vue.createApp({
  setup () {
    // Variáveis Essenciais
    const audioplay = ref(true);
    const firstslide = ref(1);
    const secondap = ref(true);

    // --- FUNÇÃO DE SOM (Integrada no Vue para não falhar) ---
    function toggleAudio() {
        // Inverter a variável visual (ícone)
        audioplay.value = !audioplay.value;

        // Controlar o áudio real
        var audio = document.getElementById("audio");
        if (audio) {
            // Se audioplay for true, muted é false. Se for false, muted é true.
            audio.muted = !audioplay.value;
        }
    }

    // Inicialização segura
    onMounted(() => {
        // Garantir volume baixo ao iniciar
        setTimeout(() => {
            var audio = document.getElementById("audio");
            if (audio) { 
                audio.volume = 0.05;
                // Tenta dar play caso o browser tenha bloqueado
                if (audioplay.value && audio.paused) {
                    audio.play().catch(e => console.log("Autoplay bloqueado"));
                }
            }
        }, 100);
    });

    return {
      firstslide,
      secondap,
      audioplay,
      toggleAudio, // Devolvemos a função para o HTML usar
      
      // Mantivemos estas variáveis vazias só para o Vue não reclamar de nada
      DownloadTitle: '',
      DownloadDesc: '',
      download: ref(true)
    }
  }
})

load.use(Quasar, { config: {} })
load.mount('#loading-main')

// --- BARRA DE PROGRESSO (Código padrão) ---
let count = 0;
let thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) { count = data.count; },
    initFunctionInvoking(data) { 
        if(document.querySelector(".thingy")) {
            document.querySelector(".thingy").style.left = "0%";
            document.querySelector(".thingy").style.width = (data.idx / count) * 100 + "%";
        }
    },
    startDataFileEntries(data) { count = data.count; },
    performMapLoadFunction(data) { 
        ++thisCount; 
        if(document.querySelector(".thingy")) {
            document.querySelector(".thingy").style.left = "0%";
            document.querySelector(".thingy").style.width = (thisCount / count) * 100 + "%";
        }
    },
};

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});