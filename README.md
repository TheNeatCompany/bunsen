bunsen
======

Bunsen is a cache warming tool for MongoDB systems.

Some use cases include:

* Loading collection data or indexes into the OS filesystem cache
* Loading collections from lazily-loaded backup media (e.g. AWS EBS snapshots) into block storage

## quick start
Load data for zebras and unicorns followed by indexes for unicorns and minotaurs from the "mydb" database:

    ./bin/bunsen warm --host db7.domain.tld --database mydb --collections zebras unicorns --indexes unicorns minotaurs

Note that the order of collections and indexes is significant.
Collections are always loaded first, followed by indexes in the order specified.
You can use this to your advantage if short on memory as things will be evicted from cache in the order listed.
