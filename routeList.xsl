<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8"/>
<xsl:strip-space elements="*"/>
<xsl:param name="updated">daglig</xsl:param>

<xsl:template match="osm">
  <html>
    <head>
      <title>
        <xsl:value-of select="relation[position()=1]/tag[@k='type']/@v"/>
        <xsl:text> på OSM i Norge</xsl:text>
      </title>
      <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
      <link rel="stylesheet" type="text/css" href="style.css"/>
      <script type="text/javascript" src="http://code.jquery.com/jquery-1.6.min.js">
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
        <a href="http://wiki.openstreetmap.org/wiki/Relation">Relasjoner</a>
        <xsl:text> med type=</xsl:text>
        <xsl:value-of select="relation[position()=1]/tag[@k='type']/@v"/>
        <xsl:text> på </xsl:text>
        <a href="http://www.openstreetmap.no/">OpenStreetMap i Norge</a>
      </h1>
      <ul id="list">
        <xsl:apply-templates select="relation">
          <xsl:sort select="tag[@k='route']/@v"/>
          <xsl:sort select="tag[@k='network']/@v"/>
          <xsl:sort select="tag[@k='ref']/@v" data-type="number"/>
          <xsl:sort select="tag[@k='name']/@v"/>
        </xsl:apply-templates>
      </ul>
      <p id="response"></p>
      <address>
        <xsl:text>Oppdatert </xsl:text>
        <xsl:value-of select="$updated"/>
        <xsl:text> fra </xsl:text>
        <a href="http://download.geofabrik.de/osm/europe/">norway.osm</a>
        <xsl:text> med </xsl:text>
        <a href="https://github.com/vibrog/osm-routelist"
           >kode publisert på GitHub</a>
        <br/>
        <xsl:text>Data: © </xsl:text>
        <a href="http://www.openstreetmap.org/">OpenStreetMap</a>
        <xsl:text> og bidragsytere, </xsl:text>
        <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>
      </address>
      <script>
        <xsl:text><![CDATA[
$('a[href*="localhost"]').click(function(event){
  event.preventDefault();
  var url=$(this).attr("href");
  var msg;
  try {
    var xmlhttp=new XMLHttpRequest();
    xmlhttp.open("GET",url,false);
    xmlhttp.send(null);
    msg=xmlhttp.responseText;
  }
  catch(err) {
    msg="Feil: Editoren svarte ikke.";
  }
  $("#response").text(msg);
  $("#response").fadeIn(500).delay(2000).fadeOut(500);
});
]]></xsl:text></script>
    </body>
  </html>
</xsl:template>

<xsl:template match="relation">
  <li class="{tag[@k='route']/@v}">
    <a href="http://www.openstreetmap.org/browse/relation/{@id}"
       title="id:{@id}">
      <xsl:if test="tag[@k='ref']
                    and (
                      tag[@k='name']
                      or tag[@k='loc_name']
                      or tag[@k='to']
                    )
                    and (
                      tag[@k='route']/@v='bus' or
                      tag[@k='route']/@v='tram' or
                      tag[@k='route']/@v='subway' or
                      tag[@k='route']/@v='train' or
                      tag[@k='route']/@v='ferry'
                    )">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="tag[@k='ref']/@v"/>
        <xsl:text>] </xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="tag[@k='name']">
          <xsl:value-of select="tag[@k='name']/@v"/>
        </xsl:when>
        <xsl:when test="tag[@k='loc_name']">
          <xsl:text>"</xsl:text>
          <xsl:value-of select="tag[@k='loc_name']/@v"/>
          <xsl:text>"</xsl:text>
        </xsl:when>
        <xsl:when test="tag[@k='to']">
          <xsl:text>rt:</xsl:text>
          <xsl:if test="tag[@k='from']">
            <xsl:value-of select="tag[@k='from']/@v"/>
            <xsl:text>–</xsl:text>
          </xsl:if>
          <xsl:if test="tag[@k='via']">
            <xsl:value-of select="tag[@k='via']/@v"/>
            <xsl:text>–</xsl:text>
          </xsl:if>
          <xsl:value-of select="tag[@k='to']/@v"/>
        </xsl:when>
        <xsl:when test="tag[@k='ref']">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="tag[@k='ref']/@v"/>
        </xsl:when>
        <xsl:when test="tag[@k='note']">
          <xsl:text>nb:</xsl:text>
          <xsl:value-of select="tag[@k='note']/@v"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>id:</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>

    <xsl:if test="tag[@k='route']">
      <xsl:text>: </xsl:text>
      <a href="http://taginfo.openstreetmap.de/tags/route={tag[@k='route']/@v}">
        <xsl:value-of select="tag[@k='route']/@v"/>
      </a>
    </xsl:if>
    <xsl:if test="tag[@k='network']">
      <xsl:text> /</xsl:text>
      <a href="http://taginfo.openstreetmap.de/tags/network={tag[@k='network']/@v}">
        <xsl:value-of select="tag[@k='network']/@v"/>
      </a>
    </xsl:if>

    <xsl:if test="(tag[@v='route'] and not(tag[@k='route']))
                  or tag[@k='fixme']">
      <xsl:variable name="tooltip">
        <xsl:choose>
          <xsl:when test="tag[@k='fixme']">
            <xsl:value-of select="tag[@k='fixme']/@v"/>
          </xsl:when>
          <xsl:when test="not(tag[@k=tag[@k='type']/@v])">
            <xsl:text>Mangler </xsl:text>
            <xsl:value-of select="tag[@k='type']/@v"/>
            <xsl:text>-verdi</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:text> </xsl:text>
      <img src="warning.png" alt="warning" title="{$tooltip}"/>
    </xsl:if>

    <span class="change">
      <xsl:text>, </xsl:text>
      <a href="http://www.openstreetmap.org/browse/changeset/{@changeset}"
         title="{@changeset} {@user}">
        <xsl:value-of select="substring-before(@timestamp,'T')"/>
      </a>
    </span>

    <span class="view">
      <xsl:text> </xsl:text>
      <a href="http://www.openstreetmap.org/?relation={@id}">
        <img src="map.png" alt="kart" title="Se på kart"/>
      </a>
      <xsl:text> </xsl:text>
      <a href="http://ra.osmsurround.org/downloadServlet/gpx/{@id}">
        <img src="export.png" alt="gpx" title="Eksporter GPS spor"/>
      </a>
      <xsl:text> </xsl:text>
      <a href="http://localhost:8111/import?url=http://api.openstreetmap.org/api/0.6/relation/{@id}/full">
        <img src="edit.png" alt="rediger" title="Rediger"/>
      </a>
    </span>

  </li>
</xsl:template>

<xsl:template match="text()|@*"/>

</xsl:stylesheet>
