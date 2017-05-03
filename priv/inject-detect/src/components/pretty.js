export function block(query) {
    return JSON.stringify(JSON.parse(query), null, 4)
               .replace(/: "string"/g, ": String")
               .replace(/: "array"/g, ": Array")
               .replace(/: "date"/g, ": Date");
}

export function line(query) {
    return query
        .replace(/:"string"/g, ":String")
        .replace(/:"array"/g, ":Array")
        .replace(/:"date"/g, ":Date");
}

export function commas(number) {
    return Number(number).toLocaleString();
}
