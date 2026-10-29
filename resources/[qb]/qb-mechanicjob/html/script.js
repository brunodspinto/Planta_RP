const navbarOptions = {
    // https://forums.gta5-mods.com/topic/3842/tutorial-handling-meta
    power: [
        { id: "fMass", label: "Massa", description: "Peso do veículo em kg", min: 0, max: 10000 },
        { id: "fInitialDragCoeff", label: "Coeficiente de arrasto", description: "Aumenta para simular a resistência do ar", min: 0, max: 100 },
        { id: "fDownforceModifier", label: "Downforce", description: "Força aerodinâmica aplicada ao veículo", min: 0, max: 100 },
        { id: "nInitialDriveGears", label: "Mudanças", description: "Número de mudanças do veículo", min: 1, max: 10 },
        { id: "fInitialDriveForce", label: "Força motriz", description: "Força transmitida pela caixa", min: 0, max: 100 },
        { id: "fDriveInertia", label: "Inércia do motor", description: "Rapidez com que o motor chega ao limite de rotação", min: 0, max: 2 },
        { id: "fDriveBiasFront", label: "Tração dianteira", description: "Traseira: 0.0 | Integral: 0.5 | Dianteira: 1.0", min: 0, max: 1 },
        { id: "fInitialDriveMaxFlatVel", label: "Velocidade máxima", description: "Velocidade no limite de rotação na última mudança", min: 0, max: 1000 },
        { id: "fClutchChangeRateScaleUpShift", label: "Embraiagem a subir", description: "Valor mais alto = mudanças mais rápidas", min: 0, max: 100 },
        { id: "fClutchChangeRateScaleDownShift", label: "Embraiagem a descer", description: "Valor mais alto = mudanças mais rápidas", min: 0, max: 100 },
    ],
    braking: [
        { id: "fSteeringLock", label: "Ângulo de viragem", description: "Ângulo máximo de viragem das rodas", min: 0, max: 1 },
        { id: "fBrakeForce", label: "Força de travagem", description: "Potência geral dos travões", min: 0, max: 100 },
        { id: "fBrakeBiasFront", label: "Distribuição de travagem", description: "Trás: 0.0 | Igual: 0.5 | Frente: 1.0", min: 0, max: 1 },
        { id: "fHandBrakeForce", label: "Força do travão de mão", description: "Força do travão de mão", min: 0, max: 100 },
    ],
    traction: [
        { id: "fTractionCurveMax", label: "Aderência máxima", description: "Aderência em curva", min: 0, max: 100 },
        { id: "fTractionCurveMin", label: "Aderência mínima", description: "Aderência a acelerar e a travar", min: 0, max: 100 },
        { id: "fTractionCurveLateral", label: "Curva de aderência lateral", description: "Forma da curva de aderência lateral", min: 0, max: 100 },
        { id: "fTractionSpringDeltaMax", label: "Altura máxima de aderência", description: "Distância ao chão a partir da qual o carro perde aderência", min: 0, max: 100 },
        { id: "fLowSpeedTractionLossMult", label: "Perda de aderência a baixa velocidade", description: "Mais baixo: menos burnout | Mais alto: mais burnout", min: 0, max: 100 },
        { id: "fTractionBiasFront", label: "Distribuição de aderência", description: "Trás: 0.1 | Igual: 0.5 | Frente: 0.99", min: 0, max: 1 },
        { id: "fCamberStiffnesss", label: "Rigidez do camber", description: "Aderência em drift", min: 0, max: 100 },
        { id: "fTractionLossMult", label: "Perda de aderência", description: "Aderência no alcatrão e na lama", min: 0, max: 100 },
    ],
    suspension: [
        { id: "vecCentreOfMassOffset", label: "Centro de massa", description: "Desloca o centro de gravidade (direita, frente, cima)", min: 0, max: 100 },
        { id: "vecInertiaMultiplier", label: "Multiplicador de inércia", description: "Inércia de rotação", min: 0, max: 100 },
        { id: "fSuspensionForce", label: "Força da suspensão", description: "Rigidez da suspensão", min: 0, max: 100 },
        { id: "fSuspensionCompDamp", label: "Amortecimento em compressão", description: "Valores maiores = mais rígido", min: 0, max: 100 },
        { id: "fSuspensionReboundDamp", label: "Amortecimento em extensão", description: "Valores maiores = mais rígido", min: 0, max: 100 },
        { id: "fSuspensionUpperLimit", label: "Limite superior da suspensão", description: "Quanto as rodas podem subir (visual)", min: 0, max: 100 },
        { id: "fSuspensionLowerLimit", label: "Limite inferior da suspensão", description: "Quanto as rodas podem descer (visual)", min: 0, max: 100 },
        { id: "fSuspensionRaise", label: "Altura da suspensão", description: "Altura da carroçaria em relação às rodas", min: 0, max: 100 },
        { id: "fSuspensionBiasFront", label: "Distribuição da suspensão", description: "Rigidez da suspensão à frente/atrás", min: 0, max: 1 },
        { id: "fAntiRollBarForce", label: "Barra estabilizadora", description: "Números maiores = menos inclinação da carroçaria", min: 0, max: 100 },
        { id: "fAntiRollBarBiasFront", label: "Distribuição da barra estabilizadora", description: "Frente: 0 | Trás: 1", min: 0, max: 1 },
        { id: "fRollCentreHeightFront", label: "Centro de rolamento à frente", description: "Números maiores = menos capotamentos", min: -0.15, max: 0.15 },
        { id: "fRollCentreHeightRear", label: "Centro de rolamento atrás", description: "Números maiores = menos capotamentos", min: -0.15, max: 0.15 },
    ],
    miscellaneous: [
        { id: "fPercentSubmerged", label: "Percentagem submersa", description: "Percentagem submersa até o veículo se afogar", min: 0, max: 100 },
        { id: "fCollisionDamageMult", label: "Dano de colisão", description: "Multiplica o dano de colisões", min: 0, max: 10 },
        { id: "fDeformationDamageMult", label: "Dano de deformação", description: "Multiplica o dano na carroçaria", min: 0, max: 10 },
        { id: "fWeaponDamageMult", label: "Dano de armas", description: "Multiplica o dano de armas", min: 0, max: 10 },
        { id: "fEngineDamageMult", label: "Dano no motor", description: "Multiplica o dano no motor", min: 0, max: 10 },
        { id: "fPetrolTankVolume", label: "Capacidade do depósito", description: "Combustível que se perde quando o depósito é danificado", min: 0, max: 100 },
        { id: "fOilVolume", label: "Quantidade de óleo", description: "Quantidade de óleo", min: 0, max: 100 },
        { id: "nMonetaryValue", label: "Valor", description: "Define a reação dos NPCs ao veículo", min: 0, max: 1000000 },
    ],
};

let currentStats = {};

const generateNavbarItems = () => {
    const navbar = document.querySelector(".navbar");
    navbar.innerHTML = "";

    Object.keys(navbarOptions).forEach((option) => {
        const button = document.createElement("button");
        button.classList.add("nav-item");
        button.id = option;
        button.textContent = { power: "Potência", braking: "Travagem", traction: "Aderência", suspension: "Suspensão", miscellaneous: "Outros" }[option] ?? option.charAt(0).toUpperCase() + option.slice(1);
        navbar.appendChild(button);
    });
};

const displayFieldsForNavbarOption = (option) => {
    const contentArea = document.getElementById("content-area");
    contentArea.innerHTML = "";
    const selectedOptions = navbarOptions[option];

    selectedOptions.forEach((option) => {
        const inputContainer = document.createElement("div");
        inputContainer.classList.add("input-container");

        const inputLabel = document.createElement("label");
        inputLabel.classList.add("input-label");
        inputLabel.htmlFor = option.id;
        inputLabel.textContent = option.label || option.id;

        const numberInput = document.createElement("input");
        numberInput.type = "number";
        numberInput.id = option.id;
        numberInput.classList.add("number-input");
        numberInput.value = currentStats[option.id] !== undefined ? currentStats[option.id] : "";

        if (option.min !== undefined) {
            numberInput.min = option.min;
        }
        if (option.max !== undefined) {
            numberInput.max = option.max;
        }

        if (option.description) {
            inputLabel.addEventListener("mouseover", () => {
                document.getElementById("table-description").textContent = option.description;
            });

            inputLabel.addEventListener("mouseout", () => {
                document.getElementById("table-description").textContent = "";
            });
        }

        inputContainer.appendChild(inputLabel);
        inputContainer.appendChild(numberInput);
        contentArea.appendChild(inputContainer);
    });
};

const openTuner = (stats) => {
    currentStats = stats;
    document.querySelector(".tablet").style.display = "block";
    generateNavbarItems();
    displayFieldsForNavbarOption("power");
};

const saveSettings = () => {
    const contentArea = document.getElementById("content-area");
    let data = {};
    let isInputValid = true;

    const inputContainers = contentArea.querySelectorAll(".input-container");
    inputContainers.forEach((container) => {
        const inputElement = container.querySelector(".number-input");
        if (inputElement) {
            const value = parseFloat(inputElement.value);
            const min = parseFloat(inputElement.min);
            const max = parseFloat(inputElement.max);

            if (value < min || value > max) {
                console.log(inputElement.id + " out of range");
                isInputValid = false;
            } else {
                data[inputElement.id] = value;
            }
        }
    });

    if (isInputValid) {
        fetch("https://qb-mechanicjob/saveTune", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
        });
    }
};

const resetSettings = () => {
    fetch("https://qb-mechanicjob/reset", { method: "POST" });
    closeTuner();
};

const closeTuner = () => {
    document.querySelector(".tablet").style.display = "none";
    fetch("https://qb-mechanicjob/closeTuner", { method: "POST" });
};

document.addEventListener("click", function (event) {
    const targetId = event.target.id;
    const targetClass = event.target.className;

    if (targetClass === "nav-item") {
        displayFieldsForNavbarOption(targetId);
        return;
    }

    switch (targetId) {
        case "save-button":
            saveSettings();
            break;
        case "reset-button":
            resetSettings();
            break;
        case "cancel":
            closeTuner();
            break;
    }
});

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeTuner();
    }
});

window.addEventListener("message", function (event) {
    var eventData = event.data;
    if (eventData.action == "openTuner") {
        openTuner(eventData.stats);
    }
});
