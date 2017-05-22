export function block(query) {
    return JSON.stringify(JSON.parse(query), null, 4)
               .replace(/: "string"/g, ": String")
               .replace(/: "number"/g, ": Number")
               .replace(/: "boolean"/g, ": Boolean")
               .replace(/: "regex"/g, ": RegExp")
               .replace(/: "function"/g, ": Function")
               .replace(/: "date"/g, ": Date")
               .replace(/: "objectid"/g, ": ObjectID")
               .replace(/: "array"/g, ": Array");
}

export function line(query) {
    return query
        .replace(/:"string"/g, ":String")
        .replace(/:"number"/g, ":Number")
        .replace(/:"boolean"/g, ":Boolean")
        .replace(/:"regex"/g, ":RegExp")
        .replace(/:"function"/g, ":Function")
        .replace(/:"date"/g, ":Date")
        .replace(/:"objectid"/g, ":ObjectID")
        .replace(/:"array"/g, ":Array");
}

export function commas(number) {
    return Number(number).toLocaleString();
}
