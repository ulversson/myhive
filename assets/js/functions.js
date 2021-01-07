import countdown from 'moment-countdown'

const decodeHtml = (html) => {
    var txt = document.createElement("textarea")
    txt.innerHTML = html
    return txt.value
}

async function getBase64ImageFromUrl(imageUrl) {
    var res = await fetch(imageUrl)
    var blob = await res.blob()

    return new Promise((resolve, reject) => {
        var reader = new FileReader()
        reader.addEventListener("load", function() {
            resolve(reader.result)
        }, false);

        reader.onerror = () => {
            return reject(this)
        };
        reader.readAsDataURL(blob)
    })
}

const groupArrayByDate = (data, key) => {
    const groups = data.reduce((groups, item) => {
        const date = item[key].split('T')[0];
        if (!groups[date]) {
            groups[date] = [];
        }
        groups[date].push(item);
        return groups;
    }, {});

    return Object.keys(groups).map((date) => {
        return {
            date,
            items: groups[date]
        };
    });
}

const humanFileSize = (bytes, si = false, dp = 1) => {
    const thresh = si ? 1000 : 1024;

    if (Math.abs(bytes) < thresh) {
        return bytes + ' B';
    }

    const units = si ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'] : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
    let u = -1;
    const r = 10 ** dp;

    do {
        bytes /= thresh;
        ++u;
    } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1);


    return bytes.toFixed(dp) + ' ' + units[u];
}

const countdownToDate = (date) => {
    return moment(date).countdown().toString()
}


export default {
    decodeHtml,
    getBase64ImageFromUrl,
    groupArrayByDate,
    humanFileSize,
    countdownToDate
}