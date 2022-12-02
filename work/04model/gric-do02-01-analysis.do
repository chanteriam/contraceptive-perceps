capture log close
log using "00logs/gric-do02-01-analysis", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-do02-01-analysis.do
 
// Created 
 local dte   2022-02-02
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-03-13
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-do01-descriptives.dta", clear
 
****************************************************************
//  analyses
****************************************************************

***************** 
//  ses
***************** 
  // key indp var - ses
 logistic bc_rec b1.vig_ses
 
 
 // controls: demographics of respondents
 logistic bc_rec b1.vig_ses r_age r_stab_child i.r_race_t i.r_gender i.r_educ /// 
				 com_iud com_pill
	
 // controls: respondent perception of vig character
 logistic bc_rec b1.vig_ses c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s
		  

*****************
//  race
***************** 
 // key independent variables - race
 logistic bc_rec b2.vig_race

 
 // controls: characteristics of respondents
 logistic bc_rec b2.vig_race r_age r_stab_child i.r_race_t i.r_gender i.r_educ /// 
				 com_iud com_pill		   
  
 // controls: respondent perception of vig character
 logistic bc_rec b2.vig_race c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s
		  
  
*****************
//  race + ses
***************** 
 // key indp var - race + ses
 logistic bc_rec b2.vig_group 

 
 // controls: characteristics of respondents
 logistic bc_rec b2.vig_group r_age r_stab_child i.r_race_t i.r_gender i.r_educ /// 
				 com_iud com_pill
 

 // controls: respondent perception of vig character
 logistic bc_rec b1.vig_group c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s
	 
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-do02-01-analysis.dta", replace

 log close
 exit
