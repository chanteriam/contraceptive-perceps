capture log close
log using "00logs/gric-do01-descriptives", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-do01-descriptives.do
 
// Created 
 local dte   2022-01-14
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-01-15
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-data03-scales.dta", clear
 order c_scale, before(c_comp)
 order w_scale, before(w_friendly)
 
****************************************************************
//  descriptives table
****************************************************************
 * ssc install labvalch3 
 labvalch3 vig_group, strfcn(proper(`"@"')) // what is this for?

 
*****************
//  respondent info
***************** 
 // mean impute missing age values
 // add footnote that one respondent forgot to include their age
 egen agemean = mean(r_age)
 replace r_age=agemean if r_age==. // write this up (mean imputed their age)
 drop agemean
 
 // respondent demographics
 desctable r_age i.r_gender i.r_race_t i.r_educ r_stab_child ///
		   com_iud com_pill, ///
		   title("Table #. Respondent Demographics (n=695)") ///
		   filename(01tables/_raw/gric-do01-01-rdescriptives) ///
		   stats(mean sd min max)

		   
*****************
//  vignette info
***************** 

 // vigentte characteristic - by SES
 desctable bc_rec c_scale w_scale up_lifequal_now promisc up_likely ///
		   up_welf up_resp_s, group(vig_ses) ///
		   title("Table #.  Descriptive Statistics of Contraceptive Recommendation and Vignette Perceptions by SES (n=695)") ///
		   filename(01tables/_raw/gric-do01-02-vdescriptives_s)
 
 // vigentte characteristic - by race
 desctable bc_rec c_scale w_scale up_lifequal_now promisc up_likely ///
		   up_welf up_resp_s, group(vig_race) ///
		   title("Table #.  Descriptive Statistics of Contraceptive Recommendation and Vignette Perceptions by Race (n=695)") ///
		   filename(01tables/_raw/gric-do01-03-vdescriptives_r)
 
 // vigentte characteristic - by race + ses
  desctable bc_rec c_scale w_scale up_lifequal_now promisc up_likely ///
		    up_welf up_resp_s, group(vig_group) ///
		   title("Table #.  Descriptive Statistics of Contraceptive Recommendation and Vignette Perceptions by Race and SES (n=695)") ///
		   filename(01tables/_raw/gric-do01-04-vdescriptives_rs)

****************************************************************
//  descriptive significance testing
****************************************************************
	
*****************
//  competence
***************** 
 // by race
 oneway c_scale vig_race, tab
 pwmean c_scale, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest c_scale, by(vig_ses)
 
 // by race and ses
 oneway c_scale vig_group, tab
 pwmean c_scale, over(vig_group) mcompare(tukey) effects

 
*****************
//  warmth
***************** 
 // by race
 oneway w_scale vig_race, tab
 pwmean w_scale, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest w_scale, by(vig_ses)
 
 // by race and ses
 oneway w_scale vig_group, tab
 pwmean w_scale, over(vig_group) mcompare(tukey) effects


*****************
//  quality of life
***************** 
 // now
   // by race
   oneway up_lifequal_now vig_race, tab
   pwmean up_lifequal_now, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_now, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_now vig_group, tab
   pwmean up_lifequal_now, over(vig_group) mcompare(tukey) effects

   
 // after up
    // by race
   oneway up_lifequal_up vig_race, tab
   pwmean up_lifequal_up, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_up, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_up vig_group, tab
   pwmean up_lifequal_up, over(vig_group) mcompare(tukey) effects


 // for child after up
    // by race
   oneway up_lifequal_child vig_race, tab
   pwmean up_lifequal_child, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_child, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_child vig_group, tab
   pwmean up_lifequal_child, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  promisc
***************** 
 // by race
 oneway promisc vig_race, tab
 pwmean promisc, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest promisc, by(vig_ses)
 
 // by race and ses
 oneway promisc vig_group, tab
 pwmean promisc, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  up_likely
***************** 
 // by race
 oneway up_likely vig_race, tab
 pwmean up_likely, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest up_likely, by(vig_ses)
 
 // by race and ses
 oneway up_likely vig_group, tab
 pwmean up_likely, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  up_welf
***************** 
 // by race
 oneway up_welf vig_race, tab
 pwmean up_welf, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest up_welf, by(vig_ses)
 
 // by race and ses
 oneway up_welf vig_group, tab
 pwmean up_welf, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  up_resp
***************** 
 // state
    // by race
   oneway up_resp_s vig_race, tab
   pwmean up_resp_s, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_resp_s, by(vig_ses)
 
   // by race and ses
   oneway up_resp_s vig_group, tab
   pwmean up_resp_s, over(vig_group) mcompare(tukey) effects
 
 
 // character
   // by race
   oneway up_resp_c vig_race, tab
   pwmean up_resp_c, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_resp_c, by(vig_ses)
 
   // by race and ses
   oneway up_resp_c vig_group, tab
   pwmean up_resp_c, over(vig_group) mcompare(tukey) effects


*****************
//  bc_rec
***************** 
 // by vig race
 tab vig_race bc_rec, row chi2
 pwmean bc_rec, over(vig_race) mcompare(tukey) effects
 
 // by vig ses
 tab vig_ses bc_rec, chi2
 ttest bc_rec, by(vig_ses)

 // by vig race and ses
 tab vig_group bc_rec, chi2
 pwmean bc_rec, over(vig_group) mcompare(tukey) effects
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-do01-descriptives.dta", replace

 log close
 exit
