function updateHubspot() {
    console.log('update')
    const parsedSelection = JSON.parse('[' + selection + ']') // why necessary to wrap brackets? it initially had them.
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
