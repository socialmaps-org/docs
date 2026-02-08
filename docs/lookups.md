# Lookups

OpenStreetMap famously does not have [Permanent IDs](https://wiki.openstreetmap.org/wiki/Permanent_ID) so how does Social Maps allow its users to look up places in its database?

Social Maps has a dedicated API endpoint to [look up a place](/api/#tag/places/get/v1/places/lookup) that requires the **name** and the **geo-coordinates** (i.e. **latitude** and **longitude**) of the place that the user is trying to retrieve (e.g. "Blackrock Castle" at 51.9001, -8.4024). The idea is that "name + location" is how we humans think when we define and distinguish a place from others. Therefore, the location does not have to be exact either, just good enough for the name provided to be unambiguously referring to a single place in that area.

Notice how our "name + location" approach is completely independent of OpenStreetMap IDs (e.g. [way/102437857](https://www.openstreetmap.org/way/102437857) for "Blackrock Castle"). This is intentional as OpenStreetMap IDs are not stable/permanent identifiers, as also explained on [Permanent IDs](https://wiki.openstreetmap.org/wiki/Permanent_ID). In addition, some OpenStreetMap clients such as [Organic Maps](https://organicmaps.app/)[^1] do not store OpenStreetMap IDs in their offline database so it would be impossible for them to look up places by OpenStreetMap IDs, whereas they can easily look up using "name + location".

[^1]:
    See the following discussions on their issue tracker:

    * \#1597 &mdash; [\[Editor\]: add "Show in OpenStreetMap" button](https://github.com/organicmaps/organicmaps/issues/1597)
    * \#2421 &mdash; [Share OSM node/way/relation link instead of 'OSM Go' links](https://github.com/organicmaps/organicmaps/issues/2421)
    * \#3344 &mdash; [Node links in Organic Maps do not link to nodes](https://github.com/organicmaps/organicmaps/issues/3344)

