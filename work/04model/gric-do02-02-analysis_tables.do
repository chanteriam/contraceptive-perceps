capture log close
log using "00logs/gric-do02-02-analysis_tables", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-do02-02-analysis_tables.do
 
// Created 
 local dte   2022-02-18
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-02-19
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-do02-01-analysis.dta", clear

****************************************************************
//  Create dummy variables
****************************************************************
 
*****************
//  respondent race
***************** 
 // black
 gen r_black=0
 replace r_black=1 if r_race_t==0
 
 // hispanic - already created (r_hispanic)
 
 // white
 gen r_white=0
 replace r_white=1 if r_race_t==2
 
 // other race
 gen r_other_race=0
 replace r_other_race=1 if r_race_t==3

 
*****************
//  respondent gender
***************** 
 // woman
 gen r_woman=0
 replace r_woman=1 if r_gender==0
  
 // man
 gen r_man=0
 replace r_man=1 if r_gender==1
 
 // other gender
 gen r_other_gender=0
 replace r_other_gender=1 if r_gender==2

 
*****************
//  respondent education
***************** 
 // hs or less
 gen r_highschool=0
 replace r_highschool=1 if r_educ==0 
 
 // some college
 gen r_somecollege=0
 replace r_somecollege=1 if r_educ==1
 
 // 2-year degree
 gen r_twoyear=0
 replace r_twoyear=1 if r_educ==2
 
 // 4-year degree
 gen r_fouryear=0
 replace r_fouryear=1 if r_educ==3
 
 // master's, doctorate, or professional
 gen r_masters=0
 replace r_masters=1 if r_educ==4
 
 
****************************************************************
//  Create tables for regression models
**************************************************************** 
 
***************** 
//  ses
***************** 
 // local variables
 local r_char "r_age r_stab_child r_black r_hispanic r_other_race r_white r_man r_other_gender r_woman r_somecollege r_twoyear r_fouryear r_masters r_highschool com_iud com_pill" 
 local v_char "c_scale w_scale up_lifequal_now promisc up_likely up_welf up_resp_s"
 
 
 logistic bc_rec vig_ses
 margins, at(vig_ses=(0 1)) post
 mlincom 2-1
 
  logistic bc_rec i.vig_ses##c.c_scale
 margins, at(vig_ses=(0 1)) dydx(c_scale) post
 
   logistic bc_rec i.vig_ses##c.c_scale
 margins,  dydx(c_scale) post
 
 mlincom 2-1
 
 
 fre vig_ses
 
 // analyses (high-ses as base)
 eststo clear 
  
	// Model 1: Vig SES - fully unadjusted model 
	eststo: logistic bc_rec vig_ses
	
	//Model 2: Group 1 + Respondent Characteristics
	eststo: logistic bc_rec vig_ses `r_char'

	// Model 3: Group 1 + Vignette Characteristics
	eststo: logistic bc_rec vig_ses `v_char'
	// test up_lifequal_now == up_lifequal_up
	// pwcorr up_lifequal_now vig_ses, star(.05) - to test correlation between variables

	// Model 4: Group 1 + All controls
	eststo: logistic bc_rec vig_ses `r_char' `v_char'

 // table for analyses
 esttab, eform 

 esttab, eform se noeqlines nolz nogaps noobs label, using 01tables/_raw/gric-do02-01-analyses_tables-ses.rtf,replace ///
 title ({Table #. Odds Ratios from Binary Logistic Regression Model Predicting Contraceptive Recommendation by SES}) ///
 no numbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
 addnote("Source: Public Contraceptive Recommendation Experiment, 2022") star(* 0.05 ** 0.01 *** 0.001)


*****************
//  race
***************** 
 // for supplemental analyses, change reference categories 
 // local variables
 local r_char "r_age r_stab_child r_black r_hispanic r_other_race r_white r_man r_other_gender r_woman r_somecollege r_twoyear r_fouryear r_masters r_highschool com_iud com_pill" 
 local v_char "c_scale w_scale up_lifequal_now promisc up_likely up_welf up_resp_s"
 
 
 // analyses (high-ses as base)
 eststo clear 
	// Model 1: Vig Race - fully unadjusted model 
	eststo: logistic bc_rec b2.vig_race
	
	//Model 2: Group 1 + Respondent Characteristics
	eststo: logistic bc_rec b2.vig_race `r_char'
	// margins vig_race, atmeans // for checking predicted probabilities

	// Model 3: Group 1 + Vignette Characteristics
	eststo: logistic bc_rec b2.vig_race `v_char'

	// Model 4: Group 1 + All controls
	eststo: logistic bc_rec b2.vig_race `r_char' `v_char'

 // table for analyses
 esttab, eform 

 esttab, eform se noeqlines nolz nogaps noobs label, using 01tables/_raw/gric-do02-02-analyses_tables-race.rtf,replace ///
 title ({Table #. Odds Ratios from Binary Logistic Regression Model Predicting Contraceptive Recommendation by Race}) ///
 no numbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
 addnote("Source: Public Contraceptive Recommendation Experiment, 2022") star(* 0.05 ** 0.01 *** 0.001)


*****************
//  race + ses
***************** 
 // local variables
 local r_char "r_age r_stab_child r_black r_hispanic r_other_race r_white r_man r_other_gender r_woman r_somecollege r_twoyear r_fouryear r_masters r_highschool com_iud com_pill" 
 local v_char "c_scale w_scale up_lifequal_now promisc up_likely up_welf up_resp_s"
 
 // analyses (high-ses as base)
 eststo clear 
	// Model 1: Vig Race + SES - fully unadjusted model 
	eststo: logistic bc_rec b2.vig_group
	
	//Model 2: Group 1 + Respondent Characteristics
	eststo: logistic bc_rec b2.vig_group `r_char'
	
	// Model 3: Group 1 + Vignette Characteristics
	eststo: logistic bc_rec b2.vig_group `v_char'

	// Model 3: Group 1 + All controls
	eststo: logistic bc_rec b2.vig_group `r_char' `v_char'

 // table for analyses
 esttab, eform 

 esttab, eform se noeqlines nolz nogaps noobs label, using 01tables/_raw/gric-do02-03-analyses_tables-race_ses.rtf,replace ///
 title ({Table #. Odds Ratios from Binary Logistic Regression Model Predicting Contraceptive Recommendation by Race and SES}) ///
 no numbers mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
 addnote("Source: Public Contraceptive Recommendation Experiment, 2022") star(* 0.05 ** 0.01 *** 0.001)
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-do02-02-analysis_tables.dta", replace

 log close
 exit
