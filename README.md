
# List routes from OpenStreetMap

Script and XSLT style sheet used to produce a list of
[relation routes](http://wiki.openstreetmap.org/wiki/Route)
found on OpenStreetMap (OSM) in Norway.

Microformatting indicates OSM keys:
[ref] name, "loc_name", rp:(from-)(via-)to, #ref, nb:note, id:osm-id, /network


### Instructions

Download OSM data, e.g. nightly extract from
[Geofabrik](http://download.geofabrik.de/osm/):

    curl --silent --connect-timeout 10 \
     -z norway.osm.pbf -o norway.osm.pbf \
     http://download.geofabrik.de/osm/europe/norway.osm.pbf

Filter routes using
[Osmosis](http://wiki.openstreetmap.org/wiki/Osmosis),
but we\'re not interested in road networks:

    osmosis --rb norway.osm.pbf \
     --tf accept-relations type=route \
     --tf reject-relations route=road \
     --tf reject-relations route=junction \
     --tf reject-relations route=detour \
     --tf reject-relations route=power \
     --tf reject-ways \
     --tf reject-nodes \
     --wx routes.osm

Apply the XSLT style sheet:

    xsltproc --stringparam updated "`date -r routes.osm "+%Y-%m-%d"`" \
     routeList.xsl routes.osm > public_html/index.html

The result can be seen at <http://www.vidargundersen.com/routes/>


-----

Symbols by
[Trafikanten](http://trafikanten.no/),
[Statens Kartverk](http://www.statkart.no/filestore/Standardisering/docs/symbol.pdf),
[Vegvesenet](http://www.vegvesen.no/Trafikkinformasjon/Lover+og+regler/Trafikkskilt),
[Geotag Icon Project](http://www.geotagicons.com/),
[Robert Szczepanek](http://www.mricons.com/show/iconset:gis-icons),
[Yusuke Kamiyamane](http://findicons.com/icon/116512/050).
