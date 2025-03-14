function updateHubspot() {
    const parsedSelection = JSON.parse('[' + selection + ']')
    let rawBodyObj = {}
    parsedSelection.forEach((item) => {
        rawBodyObj = {
            "properties": {
                "firstname": item.firstname,
                "lastname": item.lastname,
                "company": item.company,
                "email": item.email,
                "custom_notes": item.custom_notes,
            }

        }
        rawBody = JSON.stringify(rawBodyObj)
        console.log(rawBody)
    })
}
