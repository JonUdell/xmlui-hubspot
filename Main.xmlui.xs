function sendToHubspot() {
    // Process only the first contact in the current batch
    if (newContacts.length > 0) {
        const contact = newContacts[0];
        contactToSend = {
            "properties": {
                "firstname": contact.firstname,
                "lastname": contact.lastname,
                "company": contact.company,
                "email": contact.email,
                "custom_notes": contact.notes,
            }
        }
        console.log('sending', contactToSend)

        // Remove the first contact from the newContacts array
        // We need to create a new array to trigger reactivity
        newContacts = newContacts.slice(1);
    }
}

function processNextContact() {
    // If there are more contacts to process, call sendToHubspot again
    if (newContacts.length > 0) {
        // We'll use delay to add a small pause between requests
        delay(200, () => sendToHubspot());
    }
}

