
# List relation routes from OSM data

Script and XSLT style sheet used to produce a list of routes in Norway.

### Instructions

Download OSM data, e.g. nightly extract from
[Geofabrik](http://download.geofabrik.de/osm/):

    curl --silent --connect-timeout 10 \
     -z norway.osm.pbf -o norway.osm.pbf \
     http://download.geofabrik.de/osm/europe/norway.osm.pbf

Filter relation routes using
[Osmosis](http://wiki.openstreetmap.org/wiki/Osmosis),
but we\'re not interested in road networks:

    osmosis --rb norway.osm.pbf \
     --tf accept-relations type=route \
     --tf reject-relations route=road \
     --tf reject-relations route=junction \
     --tf reject-ways \
     --tf reject-nodes \
     --wx routes.osm

Apply the XSLT style sheet:

    xsltproc --stringparam updated "`date -r routes.osm "+%Y-%m-%d"`" \
     routeList.xsl routes.osm > public_html/index.html

The result can be seen at <http://www.vidargundersen.com/routes/>
