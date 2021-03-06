# ------------------------------------
#
#	UKB geographical analysis
#
# ------------------------------------




shinyUI(fluidPage(


	# Load a different font for the app
	tags$head(
		tags$link(rel="stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Source+Sans+Pro")
	),

# This is to explain you have a CSS file that custom the appearance of the app
includeCSS("www/style.css") ,




# -------------------------------------------------------------------------------------
# === ROW : title + Main tabs
fluidRow( align="center",
	br(),
	helpText(
		strong("Genes & Geography in Great Britain", style="color:black; font-size:30pt")
	),
	helpText(
		"Version 1.0"
	)
),
fluidRow( align="center",
	br(),
	column(5, offset=3, align="center", radioGroupButtons( "section",label = NULL, choices=c("Home"=0, "Methods"=2, "Explore"=1, "Compare"=3, "Load your data"=4), selected=1 )),

	# Customization button
	column(1, offset=0, align="right",
		dropdownButton(
			circle = TRUE, icon = icon("wrench"), width = "600px", tooltip = tooltipOptions(title = "Custom your maps!"),

			h2("Geographical Unit"),
			hr(),
			h5("Choose below how you want to visualize the geographic distribution of the genetic measures: Region = local authority level, Hexagones = hexagones."),
			selectInput(inputId = "map_geo_unit", label = "", choices = c("Region"=1, "Hexagones"=3) ),
			br(), br(),

			h2("Transformation"),
			hr(),
			h5("Choose below whether you want to see an untransformed version of the map or a cartogram."),
			selectInput(inputId = "map_geo_transfo", label = "", choices = c("No transformation"=1, "Cartogram"=2) ),
			br(), br(),

			h2("Color Scale"),
			hr(),
			h5("Choose your color scheme below."),
			strong("type of color scale:"),
			selectInput(inputId = "type_scale", label = "", choices = c("Bin", "Quantile", "Numerical"), selected="Quantile"),

			strong("Color Palette:"),
			selectInput(inputId = "choice_palette", label = "", choices = c("Blues", "Reds", "viridis", "magma", "BuPu"), selected="Reds"),

			strong("Number of bins (Bin option only):"),
			sliderInput("slider_quantile", "", min=3, max=20, value=6, ticks=F)

		)
	),
	column(1, align="left", bookmarkButton("Share what you see"))
),

column(8, offset=2, hr()),


# -------------------------------------------------------------------------------------



	# #########
	#	TAB 0
	# #########
	conditionalPanel("input.section == 0",
		fluidRow(column(6, offset=3, align="left",
			br(), br(),
			h2("Summary"),
			hr(),
			h5("We conducted a study on the geographic distributions of human DNA differences
			in Great Britain. Human DNA variation is not randomly distributed across
			geographic regions. Regional differences in human DNA have been long known
			to reflect ancestry differences from the distant past. We
			investigated the extent to which DNA variants that influence heritable
			human characteristics also show regional differences. We looked at genetic
			variation associated with physical health, mental health, substance use, personality,
			BMI, reproduction, height, and educational attainment. "),
			br(),
			h2("Links"),
			hr(),
			h5("The article can be found", a("here", href="https://www.nature.com/articles/s41562-019-0757-5"),"."),
			h5("A document with our results explained in layman’s terms can be found", a("here", href="https://www.scribd.com/document/430555452/Abdellaoui-2019-NHB-faq"),"."),
			br(),
			h2("Funding"),
			hr(),
			h5("This research was supported by the Australian National Health and Medical
			Research Council (1107258, 1078901, 1078037, 1056929, 1048853, and 1113400),
			and the Sylvia & Charles Viertel Charitable Foundation (Senior Medical Research Fellowship).
			A.A. & K.J.H.V are supported by the Foundation Volksbond Rotterdam. A.A. & M.G.N.
			are supported by ZonMw grant 849200011 and 531003014 from The Netherlands Organisation
			for Health Research and Development. B.P.Z. received funding from The Australian
			Research Council (FT160100298). The research was conducted using data from
			the UK Biobank Resource (Application Number: 12514) and dbGaP (Accession Number: phs000674)."),
			br(), br(), br(),br(),
			fluidRow(align="center",
				actionButton(inputId='ab1', label="Github", icon = icon("github"), onclick ="location.href='https://github.com/holtzy/UKB_geo_application';"),
				actionButton(inputId='ab1', label="Paper", icon = icon("file-o"), onclick ="location.href='https://www.nature.com/articles/s41562-019-0757-5';"),
				actionButton(inputId='ab1', label="FAQ", icon = icon("file-o"), onclick ="location.href='https://www.scribd.com/document/430555452/Abdellaoui-2019-NHB-faq';")
			),
			br(), br()
			)

		)),




# #########
#	TAB 1
# #########
conditionalPanel("input.section == 1",
	column(2, offset=1,
		br(), br(), br(), br(),br(), br(), br(), br(),br(), br(), br(), br(),
		h2("Welcome"),
		hr(),
		h5("Here you can explore the geographical distribution of a wide range of genetic variables derived from the ", strong(a("UK Biobank dataset", href="http://www.ukbiobank.ac.uk")), "(N=320,940 unrelated individuals)."),
		br(),
		h5("We included over 100 variables for visualization. Feel free to play around with the buttons on the right to customize and export the visualizations. Use the compare tab above to explore the relationship between these genetic variables."),
		br(), br(), br(),br(), br(), br(), br()
	),






	# MAP
	column(6, align="center",
		leafletOutput("main_map", height="800px", width="100%") %>% withSpinner( color= "#2ecc71"),
		br(), br(),
		uiOutput("title_map1"),
		uiOutput("moran_map1")
	),




	# RIGHT SIDE
	column(2, align="right",
		br(), br(), br(), br(),br(), br(), br(), br(),
		h2("Genetic Variables"),
		hr(),
		h5("Below you can choose to visualize the geographical distribution of 33 polygenic scores and 100 principal components (PCs) that reflect ancestry differences within the UK. Polygenic scores are available with and without correction for the 100 PCs. See the methods or ", strong(a("our article", href="https://www.nature.com/articles/s41562-019-0757-5")), " for details on how these variables have been computed."),
		uiOutput("map_variable_button")
	),
	column(2, align="right",
		br(), br(),
		h2("Moran's I"),
		hr(),
		h5( strong(a("Moran's I",  href="http://onlinelibrary.wiley.com/doi/10.1111/j.1538-4632.2007.00708.x/abstract;jsessionid=154996FCB55E5EE7CBD2B3B65BC1DB5C.f02t03")), " is a measure of spatial autocorrelation, i.e., the degree to which values are clustered together in geographic space. Like regular correlations, the values of Moran’s I range from -1 (dispersed) to 0 (randomly distributed) to 1 (clustered together). Click on the plus button below to see a ranking of the genetic variables based on their Moran’s I."),
		dropdownButton( circle = TRUE, icon = icon("plus"), size= "s", width="600px", right=TRUE, up=TRUE,
			conditionalPanel("input.moranbar == 1", plotOutput("barplotPRS", height="780px")),
			conditionalPanel("input.moranbar == 2", plotOutput("barplotPC", height="780px")),
			fluidRow(align="center", radioGroupButtons( "moranbar",label = NULL, choices=c("Traits"=1, "PCs"=2), selected=1 ))
		)
	)
),
br(), br(),










# #########
#	TAB  (COMPARE)
# #########
conditionalPanel("input.section == 3",

	fluidRow(column(4, offset=4, align="center", h5("In this section, you can compare the geographical distribution of several genetic variables. Select up to four variables to visualize next to each other below. Scroll further down this page to inspect the scatterplot matrix and correlation estimates between every pair of genetic variables."))),
	br(), br(), br(),

	# And now the 4 maps
	fluidRow(
		column(3, offset=0, align="center",
			br(),br(),
			uiOutput("multimap_variable_button1"),
			leafletOutput("compar_map1", height=multimap_height) %>% withSpinner( color= "#2ecc71"),
			br(),
			uiOutput("title_multimap1")
		),
		column(3, offset=0, align="center",
			br(),br(),
			uiOutput("multimap_variable_button2"),
			leafletOutput("compar_map2", height=multimap_height) %>% withSpinner( color= "#2ecc71"),
			br(),
			uiOutput("title_multimap2")
		),
		column(3, offset=0, align="center",
			br(),br(),
			uiOutput("multimap_variable_button3"),
			leafletOutput("compar_map3", height=multimap_height) %>% withSpinner( color= "#2ecc71"),
			br(),
			uiOutput("title_multimap3")
		),
		column(3, offset=0, align="center",
			br(),br(),
			uiOutput("multimap_variable_button4"),
			leafletOutput("compar_map4", height=multimap_height) %>% withSpinner( color= "#2ecc71"),
			br(),
			uiOutput("title_multimap4")
		)
	),

	# Legend
	fluidRow(align="center", h3(tags$u(tags$b("Figure 2")),": Geographical distribution of several variables across the UK.")),






	# Scatterplot of pairwise comparison
	br(),
	fluidRow( align="center",
		column(4, offset=4,
			hr(),
			h5("Here are a couple of scatterplots showing the relationship between each pair of variables you have selected:")
		)
	),
	fluidRow(
		column(6, align="right", uiOutput("choice_X_scatter")),
		column(6, align="left", uiOutput("choice_Y_scatter"))
	),
	br(),
	fluidRow(align="center", column(6, offset=3, plotlyOutput("scatter", height="700px", width="700px") %>% withSpinner( color= "#2ecc71"))),
	fluidRow(align="center", column(4, offset=4, h3(tags$u(tags$b("Figure 3")),": Scatterplot showing the relationship between 2 variables. Each point represent a region of the map. Size and color are proportional to the number of people per region."))),








	# Heatmap
	br(),
	fluidRow( align="center",
		column(4, offset=4,
			br(),
			hr(),
			h5("Correlation between genetic variables")
		)
	),
	fluidRow(align="center",
		column(6, offset=3, plotlyOutput("heatmap", width="850px", height="850px") %>% withSpinner( color= "#2ecc71")),
		column(1, br(),br(),br(),br(),br(),br(),br(), radioGroupButtons(inputId = "varY_heatmap", label = "", choices = c("PRS (no correction)" = 1, "PRS corrected by PCs"=2, "PCs" = 3), selected=2, direction = "vertical") )
	),
	fluidRow(align="center", column(4, offset=4, h3(tags$u(tags$b("Figure 4")),": Heatmap displaying the Pearson correlation coefficient between variable. Pick up the group of traits of the Y axis using the right buttons (and use bottom buttons for the X axis)."))),
	fluidRow(align="center", radioGroupButtons(inputId = "varX_heatmap", label = "", choices = c("PRS (no correction)" = 1, "PRS corrected by PCs"=2, "PCs" = 3), selected=2))


),















# #########
#	TAB (METHOD)
# #########
conditionalPanel("input.section == 2",

	fluidRow(column(6, offset=3, align="left",
		br(), br(),
		h2("Introduction"),
		hr()
	)),
	fluidRow(column(6, offset=3, align="justify",
		h5("The first law of geography states that everything is related to everything else, but ", strong(a("near things are more
		related than distant things",  href="https://www.jstor.org/stable/143141?seq=1#page_scan_tab_contents")), ". Humans living near each other are more related and tend to share more
		DNA sequence than distant human beings, which is reflected in ", strong(a("genome-wide allele frequency
		differences",  href="https://www.nature.com/articles/nature07331")), " on a global scale as well as on ", strong(a("finer scales",  href="https://www.nature.com/articles/ejhg201348")), ". This clustering on ancestry is a result of
		historic population movements, genetic drift, natural selection, and/or admixture. Here, we examine
		geographic distributions of ancestry and genome-wide complex trait variation in Great Britain.")
	)),
	br(),



	fluidRow(column(6, offset=3, align="left",
		br(), br(),
		h2("Participants"),
		hr()
	)),
	fluidRow(column(6, offset=3, align="justify",
		h5("The participants of this study come from ", strong(a("UK Biobank (UKB)",  href="https://www.nature.com/articles/s41586-018-0579-z")), ", which has received ethical approval from
		the National Health Service North West Centre for Research Ethics Committee (reference:
		11/NW/0382). A total of 502,655 participants aged between 37 and 73 years old were recruited in the
		UK between 2006 and 2010. They underwent a wide range of cognitive, health, and lifestyle
		assessments, provided blood, urine, and saliva samples, and agreed to have their health followed
		longitudinally.")
	)),
	br(),


	fluidRow(column(6, offset=3, align="left",
		br(), br(),
		h2("Genotypes and QC"),
		hr()
	)),
	fluidRow(column(6, offset=3, align="justify",
		h5("To capture British ancestry, we first excluded individuals with non-European ancestry. Ancestry was
		determined using Principal Component Analysis (PCA) in", strong(a("GCTA",  href="https://www.ncbi.nlm.nih.gov/pubmed/21167468")), ". The UKB dataset was projected onto the
		first two principle components (PCs) from the 2,504 participants of the 1000 Genomes Project (", strong(a("ref",  href="https://www.ncbi.nlm.nih.gov/pubmed/26432245")), "), using
		HM3 SNP with minor allele frequence (MAF) > 0.01 in both datasets."),
		h5("Next, participants from UKB were
		assigned to one of five super-populations from the 1000 Genomes project: European, African, East-
		Asian, South-Asian, or Admixed. Assignments for European, African, East-Asian, and South-Asian
		ancestries were based on > 0.9 posterior-probability of belonging to the 1000 Genomes reference
		cluster, with the remaining participants classified as Admixed. Posterior-probabilities were calculated
		under a bivariate Gaussian distribution where this approach generalizes the k-means method to take
		account of the shape of the reference cluster. We used a uniform prior and calculated the vectors of
		means and 2x2 variance-covariance matrices for each super-population. A total of 456,426 subjects
		were identified to have a European ancestry."),
		h5("A PCA was then conducted on individuals of European ancestry using flashPCA 10 in order to
		capture ancestry differences within the British population. In order to capture ancestry differences in
		homogenous populations, genotypes should be pruned for LD and long-range LD regions removed. The
		LD pruned (r2 < .1) UKB dataset without long-range LD regions consisted of 137,102 genotyped SNPs. The
		PCA to construct British ancestry-informative PCs was conducted on this SNP set with minimized LD on
		unrelated individuals and was then projected onto the complete set of European individuals.")
	)),
	br(),


	fluidRow(column(6, offset=3, align="left",
		br(), br(), br(),
		h2("Polygenic Scores"),
		hr()
	)),
	fluidRow(column(6, offset=3, align="justify",
		h5("Polygenic scores, the genome-wide sum of alleles weighted by their estimated effect sizes, were
		computed for 33 traits. The effect size estimates came from genome-wide association studies (GWASs)
		that were chosen to not have included the UKB dataset to avoid over-estimation of the genetic
		predisposition of a trait. The polygenic scores were computed using the SBLUP approach, which
		maximizes the predictive power by creates scores with BLUP properties that account for linkage
		disequilibrium (LD) between SNPs. The traits included psychiatric disorders, substance use,
		anthropomorphic traits, personality dimensions, educational attainment, cardiovascular disease, and
		type-2 diabetes. In order to examine the geographic clustering of polygenic scores beyond the clustering
		of ancestry, we created an additional set of polygenic scores that had the first 100 British ancestry-
		informative PCs regressed out. See Supplementary Table 1 of our ", strong(a("article", href="https://www.nature.com/articles/s41562-019-0757-5")), " for a full list of the polygenic
		scores and their GWASs."),
		br()
	)),
	br(),br(),



	fluidRow(column(6, offset=3, align="left",
		br(), br(), br(),
		h2("Visualization"),
		hr()
	)),
	fluidRow(column(6, offset=3, align="justify",
		h5("We divided Great Britain into local authority regions. We also offer the option to divide the territory into hexagones with identical area ", strong(a("(source)",  href="https://xinye1.github.io/projects/brexit-cartogram-leaflet/")), " . In both cases, we computed the average value of each genetic variable per region."),
		h5("A cartogram representation is also available, where the area of each region is transformed proportionaly to the  number of individuals it contains. This has been done using the rubber sheet distortion algorithm ",strong(a("(Dougenik et al. 1985)",  href="https://xinye1.github.io/projects/brexit-cartogram-leaflet/")), " implemented in the ", strong(a("cartogram R library",  href="https://github.com/sjewo/cartogram"))),
		h5("To evaluate the spatial autocorrelation of a variable, we computed it's ", strong(a("Moran's I value",  href="http://www.jstor.org/stable/2532039?seq=2#page_scan_tab_contents"))," using the ", strong(a("spdep",  href="https://cran.r-project.org/web/packages/spdep/spdep.pdf")), " library"),
		h5("The main result of this study have been obtained using the", strong(a("R programming",  href="https://www.r-project.org/about.html")), "language. Interactive maps were made using the ",strong(a("leaflet library",  href="https://rstudio.github.io/leaflet/")) ,"developped by", strong(a("Rstudio",  href="https://www.rstudio.com")),". All code for this interactive website is available on ",  strong(a("Github",  href="https://github.com/holtzy/UKB_geo_application"))," and further details are available in our publication. Feel free to contact us for further information.")
	)),
	br(),br(),
	fluidRow(align="center",
		actionButton(inputId='ab1', label="Github", icon = icon("github"), onclick ="location.href='https://github.com/holtzy/UKB_geo_application';"),
		actionButton(inputId='ab1', label="Paper", icon = icon("file-o"), onclick ="location.href='https://www.nature.com/articles/s41562-019-0757-5';"),
		actionButton(inputId='ab1', label="FAQ", icon = icon("file-o"), onclick ="location.href='https://www.scribd.com/document/430555452/Abdellaoui-2019-NHB-faq';")
	)

),







# #########
#	TAB : ADD YOUR DATA
# #########
conditionalPanel("input.section == 4",

	fluidRow(column( 4, offset=4, align="center",
		br(),
		h5("It is possible to load your own data in this application to visualize it on a map of Great Britain. First load your file which must be in a specific format. Once this file is correctly uploaded, you can calculate summary statistics per area and visualize it")
	)),

	fluidRow(column(7, offset=2, align="left",
		br(),
		h2("1 - Load your file"),
		hr(),
		h5("Your file must be composed by at least 3 columns. The two first columns must be longitude and latitude respectively (use OSGB 1936 projection, as provided in the UK Biobank dataset). All other columns are your variables that must be normalized and centered. Each line is an individual. File can be compressed (.gz). Respect header shown in the example. Column must be separated by spaces. Note that an example file is provided", a("here",  href="https://github.com/holtzy/UKB_geo_application/blob/master/DATA/toy_dataset.txt",".") ),
		br(), br()
	)),

	fluidRow( align="center",
		column(4,
			h6("Select your file"),
			br(), br(), br(),
			fileInput("file1", "" , multiple = FALSE)
		),
		column(4,
			h6("What it should look like:"),
			dataTableOutput('doc_ex1' , width="70%" )
		),
		column(4,
			h6("What it does look like:"),
			uiOutput("error_message"),
			dataTableOutput('doc_real' , width="70%" )
		)
	),

	fluidRow(column(7, offset=2, align="left",
		br(), br(), br(), br(),br(),
		h2("2 - Calculate summary statistics"),
		hr(),
		h5("Once your file as been read correctly, you can run the spatial analysis. This will calculate summary statics for every region of the maps and build the cartograms. A pop-up window will inform you once the computation will be over. It will thus be possible to go back on the exploration and compare tabs; your variable(s) will be available in the 'variable' button"),
		br(),
		actionButton("button_computation", "Run analysis"),
		conditionalPanel("output.flagOK",
			downloadButton("downloadData", "Download your aggregated data")
		),
		uiOutput("info_message") %>% withSpinner( color= "#2ecc71"),
		useSweetAlert(),
		br()
	))



),









# #########
#	FOOTER
# #########


# -------------------------------------------------------------------------------------
# === 9/ Footer
fluidRow( align="center" ,
	br(), br(),
	column(4, offset=4,
		hr(),
		br(), br(),
		"A project by", strong(a("A. Abdellaoui",  href="https://twitter.com/dr_appie")), " et al. Webpage by", strong(a("Y. Holtz",  href="https://www.yan-holtz.com")),".",
		br(),
		"Source code available on", strong(a("Github",  href="https://github.com/holtzy/UKB_geo_application")),".",
		br(),
		"Copyright © 2019 Genes, Geography in the UKB",
		br(), br(),br()

	),
	br(),br()
)


# -------------------------------------------------------------------------------------





# Close the ui
))
