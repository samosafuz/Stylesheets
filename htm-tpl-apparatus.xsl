<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" version="2.0">
  <!-- Apparatus creation: look in tpl-apparatus.xsl for documentation -->
  <xsl:include href="tpl-apparatus.xsl"/>

  <!-- DDBDP Apparatus framework -->
  <xsl:template name="tpl-apparatus">
    <!-- An apparatus is only created if one of the following is true -->
    <xsl:if
      test=".//t:choice | .//t:subst | .//t:app |
       .//t:hi[@rend = 'diaeresis' or @rend = 'grave' or @rend = 'acute' or @rend = 'asper' or @rend = 'lenis' or @rend = 'circumflex'] |
       .//t:del[@rend='slashes' or @rend='cross-strokes'] | .//t:milestone[@rend = 'box']">

      <h2>Apparatus</h2>
      <div id="apparatus">
        <!-- An entry is created for-each of the following instances
                  * choice, subst or app not nested in another;
                  * hi not nested in the app part of an app;
                  * del or milestone.
        -->
        <xsl:for-each
          select="(.//t:choice | .//t:subst | .//t:app)[not(ancestor::t:*[local-name()=('choice','subst','app')])] |
               .//t:hi[@rend=('diaeresis','grave','acute','asper','lenis','circumflex')][not(ancestor::t:*[local-name()=('orig','reg','sic','corr','lem','rdg') 
               or self::t:del[@rend='corrected'] 
               or self::t:add[@place='inline']][1][local-name()=('reg','corr','rdg') 
               or self::t:del[@rend='corrected']])] |
           .//t:del[@rend='slashes' or @rend='cross-strokes'] | .//t:milestone[@rend = 'box']">

          <!-- Found in tpl-apparatus.xsl -->
          <xsl:call-template name="ddbdp-app">
            <xsl:with-param name="apptype">
              <xsl:choose>
                <xsl:when test="self::t:choice[child::t:orig and child::t:reg]">
                  <xsl:text>origreg</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:choice[child::t:sic and child::t:corr]">
                  <xsl:text>siccorr</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:subst">
                  <xsl:text>subst</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:app[@type='alternative']">
                  <xsl:text>appalt</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:app[@type='editorial'][starts-with(t:lem/@resp,'BL ')]">
                  <xsl:text>appbl</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:app[@type='editorial'][starts-with(t:lem/@resp,'PN ')]">
                  <xsl:text>apppn</xsl:text>
                </xsl:when>
                <xsl:when test="self::t:app[@type='editorial']">
                  <xsl:text>apped</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- called from tpl-apparatus.xsl -->
  <xsl:template name="lbrk-app">
    <br/>
  </xsl:template>

  <!-- Used in htm-{element} and above to add linking to and from apparatus -->
  <xsl:template name="app-link">
    <!-- location defines the direction of linking -->
    <xsl:param name="location"/>
    <!-- Does not produce links for translations -->
    <xsl:if test="not(ancestor::t:div[@type = 'translation'])">
      <!-- Only produces a link if it is not nested in an element that would be in apparatus -->
      <xsl:if
        test="not((local-name() = 'choice' or local-name() = 'subst' or local-name() = 'app')
         and (ancestor::t:choice or ancestor::t:subst or ancestor::t:app))">
        <xsl:variable name="app-num">
          <xsl:value-of select="name()"/>
          <xsl:number level="any" format="01"/>
        </xsl:variable>
        <xsl:call-template name="generate-app-link">
          <xsl:with-param name="location" select="$location"/>
          <xsl:with-param name="app-num" select="$app-num"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Called by app-link to generate the actual HTML, so other projects can override this template for their own style -->
  <xsl:template name="generate-app-link">
    <xsl:param name="location"/>
    <xsl:param name="app-num"/>
    <xsl:choose>
      <xsl:when test="$location = 'text'">
        <a>
          <xsl:attribute name="href">
            <xsl:text>#to-app-</xsl:text>
            <xsl:value-of select="$app-num"/>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:text>from-app-</xsl:text>
            <xsl:value-of select="$app-num"/>
          </xsl:attribute>
          <xsl:text>(*)</xsl:text>
        </a>
      </xsl:when>
      <xsl:when test="$location = 'apparatus'">
        <a>
          <xsl:attribute name="id">
            <xsl:text>to-app-</xsl:text>
            <xsl:value-of select="$app-num"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>#from-app-</xsl:text>
            <xsl:value-of select="$app-num"/>
          </xsl:attribute>
          <xsl:text>^</xsl:text>
        </a>
        <xsl:text> </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- IOSPE "mini apparatus" framework  -->

  <!-- called from htm-teidivedition.xsl -->
  <xsl:template name="tpl-iospe-apparatus">
    <xsl:if test=".//t:choice[child::t:corr] or .//t:subst or .//t:hi[@rend=('subscript','superscript')]">
      <xsl:variable name="listapp">
        <!-- generate a list of app entries, with line numbers for each (and render them later) -->
        <xsl:for-each
          select=".//(t:choice[child::t:corr]|t:subst|t:hi[@rend=('subscript','superscript')])[not(ancestor::t:rdg)]">
          <xsl:element name="app">
            <xsl:attribute name="n">
              <xsl:value-of select="preceding::t:lb[1]/@n"/>
              <!-- NOTE: need to handle line ranges -->
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="self::t:choice">
                <xsl:text>orig. </xsl:text>
                <xsl:call-template name="iospe-appcontext">
                  <!-- template below: strips diacritics, omits reg/corr/add/ex, and uppercases -->
                  <xsl:with-param name="context"
                    select="(ancestor::t:w|ancestor::t:name|ancestor::t:placeName|ancestor::t:num)[1]"
                  />
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="self::t:subst and child::t:add and child::t:del">
                <xsl:text>corr. ex </xsl:text>
                <xsl:call-template name="iospe-appcontext">
                  <!-- template below: strips diacritics, omits reg/corr/add/ex, and uppercases -->
                  <xsl:with-param name="context"
                    select="(ancestor::t:w|ancestor::t:name|ancestor::t:placeName|ancestor::t:num)[1]"
                  />
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="self::t:hi[@rend=('subscript','superscript')]">
                <xsl:apply-templates/>
                <xsl:choose>
                  <xsl:when test="@rend='subscript'">
                    <xsl:text> i.l.</xsl:text>
                  </xsl:when>
                  <xsl:when test="@rend='superscript'">
                    <xsl:text> s.l.</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <p class="miniapp">
        <xsl:if test="ancestor-or-self::t:div[@type='textpart'][@n]">
          <xsl:attribute name="id">
            <xsl:text>miniapp</xsl:text>
            <xsl:for-each select="ancestor-or-self::t:div[@type='textpart'][@n]">
              <xsl:value-of select="@n"/>
              <xsl:text>-</xsl:text>
            </xsl:for-each>
          </xsl:attribute>
        </xsl:if>
        <xsl:for-each select="$listapp/app">
          <xsl:if test="not(preceding-sibling::app[@n=current()/@n])">
            <xsl:value-of select="@n"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="."/>
          <xsl:if test="not(position()=last())">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template name="iospe-appcontext">
    <xsl:param name="context"/>
    <xsl:variable name="text">
      <xsl:apply-templates mode="iospe-context" select="$context"/>
    </xsl:variable>
    <xsl:value-of
      select="upper-case(translate(normalize-unicode($text,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;',''))"
    />
  </xsl:template>
  <xsl:template mode="iospe-context" match="t:reg|t:corr|t:add|t:ex|t:supplied|t:rdg"/>

</xsl:stylesheet>
