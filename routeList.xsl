<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8"/>
<xsl:param name="updated"/>
<xsl:strip-space elements="*"/>

<xsl:template match="osm">
  <html>
    <head>
      <title>Ruter i Norge</title>
      <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
      <style type="text/css">
        <xsl:text disable-output-escaping="yes"><![CDATA[
body {
  font-family:"Droid Sans","Trebuchet MS",Helvetica,Arial,sans-serif;
  font-size:11pt;
  max-width:50em;
  margin:.8em auto;
  padding:1em;
}
input {
  width:100%;
  height:2em;
  font-size:14pt;
  border:1px solid gray;
  -moz-border-radius:4px;
  border-radius:4px;
  -webkit-border-radius:4px;
  margin-top:1em;
}
ul {
  list-style-type: none;
  padding: 0px;
  margin: 0px;
}
li {
  background-repeat: no-repeat;
  background-position: 0px 5px;
  padding-left: 18px;
  line-height:1.4em;
}
li.bicycle { background-image: url(bicycle.png); }
li.mtb { background-image: url(mtb.png); }
li.hiking { background-image: url(hiking.png); }
li.foot { background-image: url(foot.png); }
li.running { background-image: url(running.png); }
li.ski { background-image: url(ski.png); }
li.wheelchair { background-image: url(wheelchair.png); }
li.bus { background-image: url(bus.png); }
li.train, li.railway { background-image: url(train.png); }
li.subway { background-image: url(subway.png); }
li.tram, li.light_rail { background-image: url(tram.png); }
li.ferry { background-image: url(ferry.png); }
a { color:inherit; text-decoration:none; }
.fixme { color:red; background-color:yellow; }
.change, .view { color:lightgray; }
.view { display:none; color:gray; }
li:hover .view { display:inline; }
]]></xsl:text>
      </style>
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js">
        <xsl:text> </xsl:text>
      </script>
      <script type="text/javascript">
        <xsl:text disable-output-escaping="yes"><![CDATA[
(function ($) {

  // custom css expression for a case-insensitive contains()
  jQuery.expr[':'].Contains = function(a,i,m){
      return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
  };

  function listFilter(header, list) { // header is any element, list is an unordered list
    // create and add the filter form to the header
    var form = $("<form>").attr({"action":"#"}),
        input = $("<input>").attr({"type":"text"});
    $(form).append(input).appendTo(header);

    $(input)
      .change( function () {
        var filter = $(this).val();
        if(filter) {
          // this finds all links in a list that contain the input,
          // and hide the ones not containing the input while showing the ones that do
          $matches = $(list).find(':Contains(' + filter + ')').parent();
          $('li', list).not($matches).slideUp();
          $matches.slideDown();
        } else {
          $(list).find("li").slideDown();
        }
        return false;
      })
      .keyup( function () {
        // fire the above change event after every letter
        $(this).change();
      });
  }

  //ondomready
  $(function () {
    listFilter($("#header"), $("#list"));
  });
}(jQuery));
]]></xsl:text>
      </script>
    </head>
    <body>
      <h1 id="header">
        <a href="http://wiki.openstreetmap.org/wiki/Route"
           >Ruter</a> i Norge
      </h1>
      <ul id="list">
        <xsl:apply-templates select="relation">
          <xsl:sort select="tag[@k='route']/@v"/>
          <xsl:sort select="tag[@k='network']/@v"/>
          <xsl:sort select="tag[@k='name']/@v"/>
          <xsl:sort select="tag[@k='ref']/@v" data-type="number"/>
        </xsl:apply-templates>
      </ul>
      <xsl:if test="$updated">
        <p class="change">Oppdatert <xsl:value-of select="$updated"/></p>
      </xsl:if>
    </body>
  </html>
</xsl:template>

<xsl:template match="relation">
  <li class="{tag[@k='route']/@v}">
    <a href="http://www.openstreetmap.org/browse/relation/{@id}">
      <xsl:choose>
        <xsl:when test="tag[@k='name']">
          <xsl:value-of select="tag[@k='name']/@v"/>
        </xsl:when>
        <xsl:when test="tag[@k='ref']">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="tag[@k='ref']/@v"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>id:</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
    <xsl:text>: </xsl:text>
    <span class="route">
      <xsl:choose>
        <xsl:when test="tag[@k='route']">
          <a href="http://taginfo.openstreetmap.de/tags/route={tag[@k='route']/@v}">
            <xsl:value-of select="tag[@k='route']/@v"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <span class="fixme">
            <a href="http://taginfo.openstreetmap.de/keys/route"
               title="Se vanlige verdier i Taginfo"
               >ingen route-verdi</a>
          </span>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="tag[@k='network']">
        <xsl:text> /</xsl:text>
        <a href="http://taginfo.openstreetmap.de/tags/network={tag[@k='network']/@v}">
          <xsl:value-of select="tag[@k='network']/@v"/>
        </a>
      </xsl:if>
    </span>
    <span class="change">
      <xsl:text>, </xsl:text>
      <a href="http://www.openstreetmap.org/browse/changeset/{@changeset}">
        <xsl:value-of select="substring-before(@timestamp,'T')"/>
      </a>
      <xsl:text> av </xsl:text>
      <a href="http://www.openstreetmap.org/user/{@user}">
        <xsl:value-of select="@user"/>
      </a>
    </span>
    <span class="view">
      <xsl:text> — </xsl:text>
      <a href="http://www.openstreetmap.org/?relation={@id}">
        <xsl:text>kart</xsl:text>
      </a>
      <xsl:text>, </xsl:text>
      <a href="http://127.0.0.1:8111/import?url=http://api.openstreetmap.org/api/0.6/relation/{@id}/full">
        <xsl:text>josm</xsl:text>
      </a>
      <xsl:text>, </xsl:text>
      <a href="http://ra.osmsurround.org/downloadServlet/gpx/{@id}">
        <xsl:text>gpx</xsl:text>
      </a>
    </span>
  </li>
</xsl:template>

<xsl:template match="text()|@*"/>

</xsl:stylesheet>
