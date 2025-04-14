function sendToHubspot() {
    newContacts.forEach( (contact) => {
        contactToSend = contact
        console.log('sending', contactToSend)
    })
}
