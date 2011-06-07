<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:t="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="t" version="2.0">
   <!-- Templates imported by [htm|txt]teigap.xsl -->

   <!-- style of the dot defined here -->
   <xsl:variable name="cur-dot">
      <xsl:choose>
         <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
            <xsl:text>&#xa0;&#xa0;&#x323;</xsl:text>
         </xsl:when>
         <xsl:when test="$leiden-style = 'panciera' and @reason='illegible'">
            <xsl:text>+</xsl:text>
         </xsl:when>
         <xsl:when test="$leiden-style='london'">
            <xsl:text>&#xb7;</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>.</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <!-- The highest value of @quantity that will have dots produced -->
   <xsl:variable name="cur-max">
      <xsl:choose>
         <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
            <xsl:number value="8"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:number value="3"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>



   <xsl:template match="t:gap[@reason='omitted']">
      <xsl:choose>
         <xsl:when test="$edition-type = 'diplomatic'"/>
         <xsl:otherwise>
            <xsl:text>&lt;</xsl:text>
            <xsl:call-template name="extent-string"/>
            <xsl:text>&gt;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template match="t:gap[@reason='ellipsis']">
      <xsl:choose>
         <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
            <xsl:if test="string(t:desc) != 'non transcribed'">
               <xsl:value-of select="t:desc"/>
               <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="@quantity">
                  <xsl:if test="@precision='low'">
                     <xsl:text>ca.</xsl:text>
                  </xsl:if>
                  <xsl:value-of select="@quantity"/>
               </xsl:when>
               <xsl:when test="@atLeast and @atMost">
                  <xsl:value-of select="@atLeast"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@atMost"/>
               </xsl:when>
               <xsl:when test="@atLeast ">
                  <xsl:text>&#x2265;</xsl:text>
                  <xsl:value-of select="@atLeast"/>
               </xsl:when>
               <xsl:when test="@atMost ">
                  <xsl:text>&#x2264;</xsl:text>
                  <xsl:value-of select="@atMost"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>?</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@unit"/>
            <xsl:if test="@quantity &gt; 1 or @extent='unknown' or @atLeast or @atMost">
               <xsl:text>s</xsl:text>
            </xsl:if>
            <xsl:if test="string(t:desc) = 'non transcribed'">
               <xsl:text> untranscribed</xsl:text>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> ... </xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template match="t:gap[@reason='illegible']">
      <!-- certainty -->
      <xsl:if test="child::t:certainty[@match='..']">
         <xsl:text>?</xsl:text>
      </xsl:if>

      <xsl:call-template name="extent-string"/>
   </xsl:template>


   <xsl:template match="t:gap[@reason='lost']">
      <xsl:choose>
         <xsl:when
            test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch') and @unit = 'line' and @extent = 'unknown'"/>
         <xsl:when test="$leiden-style = 'panceira' and @unit = 'line' and @extent = 'unknown'"/>
         <xsl:when test="@unit='line'">
            <xsl:text>[</xsl:text>
         </xsl:when>
         <xsl:otherwise>            
            <!-- Found in tpl-reasonlost.xsl -->
            <xsl:call-template name="lost-opener"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if
         test="$leiden-style='london' and preceding-sibling::node()[1][@part='M' or @part='I'] and not($edition-type='diplomatic')">
         <xsl:text>-</xsl:text>
      </xsl:if>

      <xsl:choose>
         <xsl:when test="$verse-lines='on' and parent::t:seg[@met or @real]">
            <xsl:call-template name="verse-string"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="extent-string"/>
         </xsl:otherwise>
      </xsl:choose>

      <!-- certainty -->
      <xsl:if test="child::t:certainty[@match='..']">
         <xsl:choose>
            <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
               <xsl:text>(?)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>?</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>

      <xsl:if
         test="$leiden-style='london' and following-sibling::node()[1][@part='M' or @part='F'] and not($edition-type='diplomatic')">
         <xsl:text>-</xsl:text>
      </xsl:if>

      <xsl:choose>
         <xsl:when
            test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch') and @unit = 'line' and @extent = 'unknown'"/>
         <xsl:when test="$leiden-style = 'panceira' and @unit = 'line' and @extent = 'unknown'"/>
         <xsl:when test="@unit='line'">
            <xsl:text>]</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <!-- Found in tpl-reasonlost.xsl -->
            <xsl:call-template name="lost-closer"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template name="extent-string">
      <!-- Precision of <gap> defined -->
      <xsl:variable name="circa">
         <xsl:choose>
            <xsl:when
               test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch') and
               (@precision='low' or (@unit='character' and @quantity &gt; $cur-max))">
               <xsl:text>ca.</xsl:text>
            </xsl:when>
            <xsl:when test="@precision='low' and not(starts-with($leiden-style, 'edh'))">
               <xsl:text>c. </xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="@extent='unknown'">
            <xsl:choose>
               <xsl:when test="$leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch'">
                  <xsl:choose>
                     <xsl:when test="@reason='lost' and @unit='line'">
                        <!--and (not(preceding-sibling::t:lb[2]) or not(following-sibling::*))-->
                        <xsl:text>-- -- -- -- -- -- -- -- -- --</xsl:text>
                     </xsl:when>
                     <xsl:when test="t:desc = 'vestiges' and @reason = 'illegible'">
                        <xsl:call-template name="tpl-vest">
                           <xsl:with-param name="circa" select="$circa"/>
                        </xsl:call-template>
                     </xsl:when>
                     <!-- reason illegible and lost caught in the otherwise -->
                     <xsl:otherwise>
                        <xsl:text> -ca.?- </xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="$leiden-style = 'london' and not($edition-type='diplomatic')">
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:text> ? </xsl:text>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
               </xsl:when>
               <xsl:when test="$leiden-style = 'london'">
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
               </xsl:when>
               <xsl:when test="$leiden-style = 'edh-itx'">
                  <xsl:text>3</xsl:text>
               </xsl:when>
               <xsl:when test="$leiden-style = 'panciera' or $leiden-style = 'edh-names'">
                  <xsl:text>---</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text> - - - </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@quantity and @unit='character'">
            <xsl:choose>
               <xsl:when test="$edition-type = 'diplomatic'">
                  <xsl:variable name="dots"
                     select="'····························································································································································'"/>
                  <xsl:value-of select="substring($dots, 1, number(@quantity))"/>
               </xsl:when>
               <xsl:when test="$leiden-style = 'edh-itx' and @quantity">
                  <xsl:choose>
                     <xsl:when test="@quantity &gt; 2">
                        <xsl:text>3</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@quantity"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="@quantity &gt; $cur-max or (@quantity &gt; 1 and @precision='low')">
                  <xsl:choose>
                     <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
                        <xsl:choose>
                           <xsl:when test="t:desc = 'vestiges' and @reason = 'illegible'">
                              <xsl:call-template name="tpl-vest">
                                 <xsl:with-param name="circa" select="$circa"/>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>- </xsl:text>
                              <xsl:value-of select="$circa"/>
                              <xsl:value-of select="@quantity"/>
                              <xsl:text> -</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="$leiden-style = 'panciera'">
                        <xsl:text>c. </xsl:text>
                        <xsl:value-of select="@quantity"/>
                     </xsl:when>
                     <xsl:when test="$leiden-style = 'london'">
                        <xsl:value-of select="$cur-dot"/>
                        <xsl:value-of select="$cur-dot"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$circa"/>
                        <xsl:value-of select="@quantity"/>
                        <xsl:value-of select="$cur-dot"/>
                        <xsl:value-of select="$cur-dot"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$cur-dot"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$circa"/>
                        <xsl:value-of select="@quantity"/>
                        <xsl:value-of select="$cur-dot"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>

               <xsl:when test="$cur-max &gt;= number(@quantity) and not(@atMost)">
                  <xsl:choose>
                     <xsl:when test="t:desc='vestiges' and @reason='illegible' and ($leiden-style='ddbdp' or $leiden-style='sammelbuch')">
                        <xsl:call-template name="tpl-vest">
                           <xsl:with-param name="circa" select="$circa"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="dot-out">
                           <xsl:with-param name="cur-num" select="number(@quantity)"/>
                        </xsl:call-template>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>

               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when
                        test="t:desc='vestiges' and @reason='illegible' and ($leiden-style='ddbdp' or $leiden-style='sammelbuch')">
                        <xsl:call-template name="tpl-vest">
                           <xsl:with-param name="circa" select="$circa"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text> - - - </xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

         <xsl:when test="@atLeast and @atMost and not(starts-with($leiden-style, 'edh'))">
            <!-- reason illegible and lost caught in the otherwise -->
            <xsl:choose>
               <xsl:when test="$leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch'">
                  <xsl:choose>
                     <xsl:when test="t:desc='vestiges' and @reason='illegible'">
                        <xsl:call-template name="tpl-vest">
                           <xsl:with-param name="circa" select="$circa"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:when test="@unit='character'">
                        <xsl:text> -</xsl:text>
                        <xsl:value-of select="@atLeast"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="@atMost"/>
                        <xsl:text>- </xsl:text>
                     </xsl:when>
                     <xsl:when test="@unit='line'">
                        <xsl:if test="@reason='illegible'">
                           <xsl:text>Traces </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="@atLeast"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="@atMost"/>
                        <xsl:text> lines</xsl:text>
                        <xsl:if test="@reason='lost'">
                           <xsl:text> missing</xsl:text>
                        </xsl:if>
                     </xsl:when>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="$leiden-style = 'panciera'">
                  <xsl:text>c. </xsl:text>
                  <xsl:value-of select="@atLeast"/> - <xsl:value-of select="@atMost"/>
               </xsl:when>
               <xsl:when test="$leiden-style = 'london'">
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$circa"/>
                  <xsl:value-of select="@atLeast"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@atMost"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$circa"/>
                  <xsl:value-of select="@atLeast"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@atMost"/>
                  <xsl:value-of select="$cur-dot"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>


         <xsl:when test="@quantity and @unit='line'">
            <xsl:choose>
               <xsl:when test="($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch')">
                  <xsl:choose>
                     <xsl:when test="desc = 'vestiges' and @reason = 'illegible'">
                        <xsl:call-template name="tpl-vest">
                           <xsl:with-param name="circa" select="$circa"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                           <!--<xsl:when test="@extent='unknown' and @reason='lost'">
                              <xsl:text>Text breaks</xsl:text>
                           </xsl:when>-->
                           <!--<xsl:when test="@extent='unknown' and @reason='illegible'">
                              <xsl:text>Traces</xsl:text>
                           </xsl:when>-->
                           <xsl:when test="@reason='lost'">
                              <xsl:value-of select="$circa"/>
                              <xsl:value-of select="@quantity"/>
                              <xsl:text> line</xsl:text>
                              <xsl:if test="@quantity &gt; 1">
                                 <xsl:text>s</xsl:text>
                              </xsl:if>
                              <xsl:text> missing</xsl:text>
                           </xsl:when>
                           <xsl:when test="@reason='illegible'">
                              <xsl:text>Traces </xsl:text>
                              <xsl:value-of select="$circa"/>
                              <xsl:value-of select="@quantity"/>
                              <xsl:text> line</xsl:text>
                              <xsl:if test="@quantity &gt; 1">
                                 <xsl:text>s</xsl:text>
                              </xsl:if>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="$leiden-style = 'london'">
                  <xsl:text>---</xsl:text>
               </xsl:when>
               <xsl:when test="$leiden-style = 'panciera' and not(following-sibling::t:lb)">
                  <xsl:text>- - - - - -</xsl:text>
               </xsl:when>
               <xsl:when test="$leiden-style = 'edh-itx'">
                  <xsl:choose>
                     <xsl:when test="not(following-sibling::t:lb)">
                        <xsl:text>&amp;</xsl:text>
                     </xsl:when>
                     <xsl:when test="count(preceding-sibling::t:lb) = 1">
                        <xsl:text>$</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>6</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text> - - - - - - - - - - </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>


         <xsl:when test="@quantity and @unit='cm'">
            <xsl:choose>
               <xsl:when
                  test="desc = 'vestiges' and ($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch') and @reason = 'illegible'">
                  <xsl:call-template name="tpl-vest">
                     <xsl:with-param name="circa" select="$circa"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$circa"/>
                  <xsl:value-of select="@quantity"/>
                  <xsl:text> cm </xsl:text>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>


         <xsl:otherwise>
            <xsl:choose>
               <xsl:when
                  test="desc = 'vestiges' and ($leiden-style = 'ddbdp' or $leiden-style = 'sammelbuch') and @reason = 'illegible'">
                  <xsl:call-template name="tpl-vest">
                     <xsl:with-param name="circa" select="$circa"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$leiden-style = 'edh-itx'">
                  <xsl:text>6</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:text> ? </xsl:text>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:value-of select="$cur-dot"/>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Template for lost verse, metre known -->
   <xsl:template name="verse-string">
      <xsl:choose>
         <xsl:when test="parent::t:seg[contains(@real,'+') or contains(@real,'-')]">
            <xsl:call-template name="scansion">
               <xsl:with-param name="met-string" select="translate(parent::t:seg/@real, '+-','ˉ˘')"/>
               <xsl:with-param name="string-len" select="string-length(parent::t:seg/@real)"/>
               <xsl:with-param name="string-pos" select="string-length(parent::t:seg/@real) - 1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="parent::t:seg[contains(@met,'+') or contains(@met,'-')]">
            <xsl:call-template name="scansion">
               <xsl:with-param name="met-string" select="translate(parent::t:seg/@met, '+-','ˉ˘')"/>
               <xsl:with-param name="string-len" select="string-length(parent::t:seg/@met)"/>
               <xsl:with-param name="string-pos" select="string-length(parent::t:seg/@met) - 1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="extent-string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- print macron and breve with intervening hard-spaces -->
   <xsl:template name="scansion">
      <xsl:param name="met-string"/>
      <xsl:param name="string-len"/>
      <xsl:param name="string-pos"/>
      <xsl:if test="$string-pos > -1">
         <xsl:text>&#xa0;</xsl:text>
         <xsl:value-of select="substring($met-string, number($string-len - $string-pos), 1)"/>
         <xsl:text>&#xa0;</xsl:text>
         <xsl:call-template name="scansion">
            <xsl:with-param name="met-string" select="$met-string"/>
            <xsl:with-param name="string-len" select="$string-len"/>
            <xsl:with-param name="string-pos" select="$string-pos - 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>


   <!-- Template for vestiges -->
   <xsl:template name="tpl-vest">
      <xsl:param name="circa"/>
      <xsl:text>Traces</xsl:text>
      <xsl:choose>
         <xsl:when test="@extent = 'unknown'">
            <xsl:if test="@unit='line'">
               <xsl:text> ?  lines</xsl:text>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$circa"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
               <xsl:when test="string(@atLeast) and string(@atMost)">
                  <xsl:value-of select="@atLeast"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@atMost"/>
               </xsl:when>
               <xsl:when test="string(@quantity)">
                  <xsl:value-of select="@quantity"/>
               </xsl:when>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="@unit = 'line'">
                  <xsl:text> line</xsl:text>
                  <xsl:if test="@quantity &gt; 1 or @atMost &gt; 1">
                     <xsl:text>s</xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@unit = 'character'">
                  <xsl:text> character</xsl:text>
                  <xsl:if test="@quantity &gt; 1 or @atMost &gt; 1">
                     <xsl:text>s</xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@unit = 'cm'">
                  <xsl:text> cm</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- Production of dots -->
   <xsl:template name="dot-out">
      <xsl:param name="cur-num"/>

      <xsl:if test="$cur-num &gt; 0">
         <xsl:value-of select="$cur-dot"/>

         <xsl:call-template name="dot-out">
            <xsl:with-param name="cur-num" select="$cur-num - 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
