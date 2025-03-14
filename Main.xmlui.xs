function updateHubspot() {
    const parsedSelection = JSON.parse('[' + selection + ']')
    let rawBodyObj = {}
    let i = 0
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

/*
'{
      "properties": {
        "firstname": "Alice",
        "lastname": "Johnson",
        "company": "TechCorp",
        "email": "alice.johnson@techcorp.com",
        "custom_notes": "Sample note for Alice Johnson"
      }
    }'
*/