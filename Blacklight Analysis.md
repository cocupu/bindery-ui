# What Blacklight Does

## Receives Queries
Translate Request params to a valid request for index (solr) & use index client library (rsolr) to query the index
Log search history (per user/session)
Keep track of configured query types (ie. search by title), sorting options and how to apply them

## Generates Responses
Decide which serialization to return
Keep track of mappings between (solr documents) and supported serializations, perform those mappings when requested


### For Static HTML Pages


#### Knows how to Render
Search Form

#### Knows how to Render the following based on a set of Search Results
Facet List
Facet Hit, Count & Link to Facet
Search Constraints (“you searched for…”)
Pagination
Suggestions?
Results List - Gallery, List, Compact List
Title of each search result
Appropriate fields per-result for search results (Configured fields for index views)
Links to view details of each search result

#### Knows how to Render the following based on a Document
Title 
Field Values (Configured fields for show/“detail” view)


