const MONTH_NAMES = [
	'janeiro',
	'fevereiro',
	'março',
	'abril',
	'maio',
	'junho',
	'julho',
	'agosto',
	'setembro',
	'outubro',
	'novembro',
	'dezembro',
]

function getFormattedDate(date, prefomattedDate = false, hideYear = false) {
	const day = date.getDate()
	const month = MONTH_NAMES[date.getMonth()]
	const year = date.getFullYear()
	const hours = date.getHours()
	let minutes = date.getMinutes()

	if (minutes < 10) {
		minutes = `0${minutes}`
	}

	if (prefomattedDate) {
		return `${prefomattedDate} às ${hours}:${minutes}`
	}

	if (hideYear) {
		return `${day} de ${month} às ${hours}:${minutes}`
	}

	return `${day} de ${month} de ${year} às ${hours}:${minutes}`
}

export function timeAgo(dateParam) {
	if (!dateParam) {
		return 'Desconhecido'
	}

	let date
	try {
		date = typeof dateParam === 'object' ? dateParam : new Date(dateParam)
	} catch (e) {
		return 'Data inválida'
	}

	if (isNaN(date)) {
		return 'Data inválida'
	}
	const DAY_IN_MS = 86400000
	const today = new Date()
	const yesterday = new Date(today - DAY_IN_MS)
	const seconds = Math.round((today - date) / 1000)
	const minutes = Math.round(seconds / 60)
	const isToday = today.toDateString() === date.toDateString()
	const isYesterday = yesterday.toDateString() === date.toDateString()
	const isThisYear = today.getFullYear() === date.getFullYear()

	if (seconds < 5) {
		return 'Agora mesmo'
	} else if (seconds < 60) {
		return `Há ${seconds} segundos`
	} else if (seconds < 90) {
		return 'Há um minuto'
	} else if (minutes < 60) {
		return `Há ${minutes} minutos`
	} else if (isToday) {
		return getFormattedDate(date, 'Hoje')
	} else if (isYesterday) {
		return getFormattedDate(date, 'Ontem')
	} else if (isThisYear) {
		return getFormattedDate(date, false, true)
	}

	return getFormattedDate(date)
}