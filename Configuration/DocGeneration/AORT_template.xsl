<!DOCTYPE doctypeName [
   <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<P>&nbsp; </P>
		<H2 id="OneFusionFrameworkRelease12(1)-Summary">Summary</H2>
		<p> These are the Release Notes of AortaTest <b><xsl:value-of
					select="bugFixesList/jiraRelease"/></b> of <b><xsl:value-of
					select="bugFixesList/projectDescription"/></b>
		</p>
		<p>This release demo's Aorta Functionality </p>
		<P>&nbsp; </P>
		<h3>Bamboo releases</h3>
		<p>Bamboo release number for this release is <b><xsl:value-of
					select="bugFixesList/shortReleaseName"/></b>. </p>
		<p>In the deployment project, please select release "<xsl:value-of
				select="bugFixesList/shortReleaseName"/>" to deploy this release. </p>


		<H3 id="OneFusionFrameworkRelease12(1)-SVNLocation">SVN location</H3>
		<P>This release is located at the following location:</P>
		<P>https://aorta-bamboo-2138150000.eu-west-1.elb.amazonaws.com/tags/AortaTest/CI/<xsl:value-of
				select="bugFixesList/svnReleaseNumber"/>
		</P>
		<P>Alternatively, the branch location can be used if the tag is not yet available:</P>
		<P> https://aorta-bamboo-2138150000.eu-west-1.elb.amazonaws.com/branches/CIO_PE/ExternalProjects/OneFusionTestProject </P>
		<P>&nbsp; </P>

		<h3>Documentation</h3>
		<ul>
			<li>Aorta Test Releases: <a
					href="http://54.171.15.62:8000/display/AORT/Release+Notes"
				>http://54.171.15.62:8000/display/AORT/Release+Notes</a></li>
			<li>Aorta Test Documentation Home: <a
					href="http://54.171.15.62:8000/display/AORT/AORTATest+Home"
				>http://54.171.15.62:8000/display/AORT/AORTATest+Home</a></li>
		</ul>
		<p> </p>
		<DIV class="columnLayout single" data-layout="single">
			<DIV class="cell normal" data-type="normal">
				<DIV class="innerCell">
					<h2>Changes in this release</h2>
					<table>

						<xsl:for-each select="bugFixesList/bugfix">
							<tr>
								<td>
									<xsl:value-of select="issueTypeName"/>
								</td>
								<td>
									<xsl:value-of select="key"/>
								</td>
								<td>
									<xsl:value-of select="summary"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
					
				</DIV>
			</DIV>
		</DIV>
	</xsl:template>
</xsl:stylesheet>
