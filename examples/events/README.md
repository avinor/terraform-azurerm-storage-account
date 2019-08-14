# Storage account events example

This example creates a simple storage account that send events to an eventhub when blobs are created / updated. It requires the id of event hub as input. Event hub can be created with the `avinor/event-hubs/azurerm` module.

Example uses [tau](https://github.com/avinor/tau).
